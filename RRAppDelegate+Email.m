//
//  RRAppDelegate+Email.m
//  Recent Redux
//
//  Created by Tim Schröder on 24.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+Email.h"
#import "RRAppDelegate+UserDefaults.h"
#import "NSFileManager+RRAdditions.h"
#import "RRStatusBar.h"
#import "RRAlert.h"
#import "RRAppDelegate+Multithreading.h"
#import "RREmailController.h"


@implementation RRAppDelegate (Email)


#pragma mark -
#pragma mark EmailClient auswählen

// Wird aufgerufen, wenn Sheet zum Auswählen des Clients geschlossen wird

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{	
	// Sheet schließen
	[selectMailClientWindow orderOut:nil];
	if (returnCode != NSOKButton) return;
	
	// Neue UserDefaults speichern
	NSString *title = [[selectMailPopUpButton selectedItem] title];
	[self setDefaultClient:title];
	
	// Email erstellen
	[self sendMail:contextInfo];
}

- (IBAction)selectMailClientWindowOK: (id)sender
{
    [NSApp endSheet:selectMailClientWindow returnCode: NSOKButton];	
}

- (IBAction)selectMailClientWindowCancel: (id)sender
{
	[NSApp endSheet:selectMailClientWindow returnCode: NSCancelButton];
}

// Wird von AppDelegate+Actions aufgerufen
-(void)selectEmailClientAndSendMail:(NSMetadataItem*)item
{
	// Ggf. Fenster laden
	if (!selectMailClientWindow) [NSBundle loadNibNamed:@"SelectMailClient" owner:self];
	
	// Client-Liste erzeugen
	[selectMailPopUpButton setMenu:[[[[RREmailController sharedEmailController] emailClientMenu] copy] autorelease]];
	[selectMailPopUpButton selectItem:nil];

	// Richtige User-Defaults-Einstellung einstellen
	NSString *title = [self defaultClient];
	if ([title isEqualToString:@""]) title = [[[RREmailController sharedEmailController] preferredEmailClient] valueForKey:MAILCLIENT_TITLE];
	[selectMailPopUpButton selectItem:[[selectMailPopUpButton menu] itemWithTitle:title]];

	// Sheet anzeigen
	[NSApp beginSheet: selectMailClientWindow
	   modalForWindow: window
		modalDelegate: self
            didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
		  contextInfo: item];
}

#pragma mark -
#pragma mark Email-Versand vorbereiten

-(void)prepareEmail:(NSMetadataItem*)item
{
	// Rauskriegen, ob gültige Client-Einstellung in Defaults
	NSString *title;
	title = [self defaultClient];
	if (![title isEqualToString:@""]) {
		// Ja: Prüfen, ob sie noch gültig ist
		if ([[RREmailController sharedEmailController] isValidMailClient:[[RREmailController sharedEmailController] URLForTitle:title]]) {
			// Ja: Mailfenster öffnen
			[self sendMail:item];
		} else {
			// Nein: Auwahlfenster für Clients öffnen und ggf. Mail erstellen
			[self selectEmailClientAndSendMail:item];
		}
		return;
	}
	
	// Nein, prüfen, ob überhaupt Clients installiert sind
	if ([[RREmailController sharedEmailController] hasValidEmailClient]) {
		// Prüfen, ob DefaultClient ok ist
		if ([[RREmailController sharedEmailController] isValidMailClient:[[[RREmailController sharedEmailController] preferredEmailClient] valueForKey:MAILCLIENT_URL]]) {
			[self sendMail:item];
		} else {
			// Nein: Auswahlfenster für Clients öffnen und ggf. Mail erstellen
			[self selectEmailClientAndSendMail:item]; 
		}
	} else {
		// Fehlermeldung anzeigen
		[RRAlert showError:[NSNumber numberWithInt: ERROR_CODE_CLIENT]];
	}
}


#pragma mark -
#pragma mark Email versenden

// Wird in separatem Thread aufgerufen, wenn Mail-Application geöffnet werden soll
-(void)executeMailScript:(NSString*)script
{
	// Skript ausführen
	NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
	if (appleScript != nil)
	{
		NSDictionary* errors = [NSDictionary dictionary];
		NSAppleEventDescriptor *descriptor = [appleScript executeAndReturnError: &errors];
		if (!descriptor) {
			[self performSelectorOnMainThread:@selector(showScriptError)
											   withObject:nil 
											waitUntilDone:YES];
		}	
		[appleScript release];
    }
}

// Wird von executeMailScript bei Mailerror aufgerufen
-(void)showScriptError
{
	[RRAlert showError:[NSNumber numberWithInt:ERROR_CODE_SCRIPT]];
}

// Öffnet Mail im Mailprogramm
-(void)sendMail:(NSMetadataItem*)item
{
	NSString *path = [item valueForAttribute:MDI_PATH];
	
	// Nachricht in StatusBar anzeigen
	[statusBar showMessageLabel:STATUS_EMAIL];
	
	// Größe des zu sendenden Objekts berechnen
	unsigned long long fileSize = 0;
	NSNumber *size = [item valueForAttribute:MDI_SIZE];
	unsigned long long lsize = [size longValue];
	if (lsize != 0) {
		fileSize = lsize;
	} else {
		fileSize = [[NSFileManager defaultManager] fastFolderSizeAtPath:path isApp:NO];
	}		
	
	// Über Maximal-Größe: Fehlermeldung
	if (fileSize > MAX_ATTACHMENT_SIZE) {
		[statusBar showCountLabel];
		[RRAlert showError:[NSNumber numberWithInt:ERROR_CODE_ATTACHMENT]];
		return;
	}
		
	// Prüfen, ob es gültigen Client gibt
	RREmailController *mailController = [RREmailController sharedEmailController];
	NSString *mailClientTitle;
	mailClientTitle = [self defaultClient];
	
	if (![mailClientTitle isEqualToString:@""]) {
		if (![mailController isValidMailClient:[mailController URLForTitle:mailClientTitle]]) mailClientTitle = @"";
	} else {
		NSDictionary *dict = [mailController preferredEmailClient];
		if (dict) mailClientTitle = [dict valueForKey:MAILCLIENT_TITLE];
	}
	if ([mailClientTitle isEqualToString:@""]) {
		[RRAlert showError:[NSNumber numberWithInt: ERROR_CODE_CLIENT]];
		[statusBar showCountLabel];
		return;
	}	
	
	// Richtiges Skript auswählen (je nach Mail-Client)
	NSString *mailClientIdentifier;
	mailClientIdentifier = [mailController bundleIdentifier:[mailController URLForTitle:mailClientTitle]];
	
	NSString *scriptName;
	if ([mailClientIdentifier isEqualToString:CLIENT_APPLEMAIL]) scriptName = @"sendmailinmailapp";
	if ([mailClientIdentifier isEqualToString:CLIENT_OUTLOOK]) scriptName = @"sendmailinoutlook";
	if ([mailClientIdentifier isEqualToString:CLIENT_ENTOURAGE]) scriptName = @"sendmailinentourage";	
	if ([mailClientIdentifier isEqualToString:CLIENT_POSTBOX]) scriptName = @"sendmailinpostbox";	
	
	NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:@"txt"];
	if (!scriptPath) {
		[RRAlert showError:[NSNumber numberWithInt: ERROR_CODE_SCRIPT]];
		[statusBar showCountLabel];
		return;
	}

	// Skript laden
	NSString *rawScript = [NSString stringWithContentsOfFile:scriptPath
													encoding:NSASCIIStringEncoding
													   error:NULL];
	if (!rawScript) return;
	
	// Pfad des zu versendenden Files konvertieren
	
	NSString *finalPath;
	if (([mailClientIdentifier isEqualToString:CLIENT_APPLEMAIL]) || ([mailClientIdentifier isEqualToString:CLIENT_OUTLOOK] || ([mailClientIdentifier isEqualToString:CLIENT_ENTOURAGE]))) {
		CFURLRef myURL = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)path, kCFURLPOSIXPathStyle, NO);
		finalPath = [(NSString *)CFURLCopyFileSystemPath(myURL, kCFURLHFSPathStyle) autorelease];
		[(NSURL*)myURL release];
	}
	
	if ([mailClientIdentifier isEqualToString:CLIENT_POSTBOX]) {
		finalPath = path;
	}
															 
	// Skript mit Pfad vervollständigen
	NSString *script = [NSString stringWithFormat:rawScript, finalPath];
		
	// Thread zum Öffnen der Mail starten
	[self startNewThread:THREAD_SENDMAIL 
			withSelector:@selector(executeMailScript:) 
			  withObject:script];
}

@end
