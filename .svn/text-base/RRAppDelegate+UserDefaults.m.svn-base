//
//  RRAppDelegate+UserDefaults.m
//  Recent Redux
//
//  Created by Tim Schröder on 18.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+UserDefaults.h"
#import "RRAppDelegate+Actions.h"
#import "RRAppDelegate+Email.h"
#import "RREmailController.h"
#import "NSDictionary+RRAdditions.h"
#import "TSHotkeyController.h"


@implementation RRAppDelegate (UserDefaults)


#pragma mark -
#pragma mark Hilfsfunktionen für AlwaysInFront

// Wird beim Programmstart vom AppDelegate aufgerufen und initialisiert Fenstermodus
- (void)setInitialWindowMode
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:DEFAULTS_ALWAYSINFRONT]) {
		[self toggleAlwaysFront:self];
	}
}

// Wird später von AppDelegate aufgerufen, falls sich Status des Fensters ändert und dies gespeichert werden soll
-(void)setWindowMode:(BOOL)flag 
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (flag) {
		[defaults setObject:@"YES" forKey:DEFAULTS_ALWAYSINFRONT];
	} else {
		[defaults setObject:@"NO" forKey:DEFAULTS_ALWAYSINFRONT];
	}

}


#pragma mark -
#pragma mark Hilfsfunktionen für EmailClient

// Setzt neuen Default-Mail-Client
-(void)setDefaultClient:(NSString*)title
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:title forKey:DEFAULTS_MAILCLIENT];
	[defaults synchronize];
}

// Gibt Default-Mail-Client zurück
-(NSString*)defaultClient
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:DEFAULTS_MAILCLIENT];
}


#pragma mark -
#pragma mark Hilfsfunktionen für Query

-(BOOL)largeSearchScope
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL result;
	if ([[defaults objectForKey:DEFAULTS_SEARCHSCOPE] intValue] ==0) {
		result = NO;
	} else {
		result = YES;
	}
	return result;
}

-(NSString*)searchInterval
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *interval = [defaults objectForKey:DEFAULTS_SEARCHINTERVAL];
	return interval;
}

-(NSString*)searchLocation
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *location = [defaults objectForKey:DEFAULTS_SEARCHLOCATION];
	return location;	
}


#pragma mark -
#pragma mark Hilfsfunktion für Hotkey

-(BOOL)hotkeyEnabled
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int value = [[defaults objectForKey:DEFAULTS_HOTKEY] intValue];
	BOOL result = NO;
	if (value==1) result = YES;
	return result;		
}

// Hotkey ein- oder ausschalten
-(void)updateHotkey
{
	TSHotkeyController *hotKeyController = [TSHotkeyController sharedHotKeyController];
	if ([self hotkeyEnabled]) {
		[hotKeyController registerHotKeyWithKeyCode:0x7B 
									  modifierFlags:optionKey 
											 target:self 
											 action:@selector(hotkeyPressed:)];
	} else {
		[hotKeyController unregisterHotKey];
	}
}


#pragma mark -
#pragma mark Hilfsfunktionen für Preference Window

// Wird vom PrefsWindow Controller aufgerufen, wenn irgendwas an Query Items geändert wurde
-(void)reloadScopeBar
{
	[scopeBar reloadData];
}

// Wird von PrefsWindow Controller aufgerufen, wenn Query Predicate geändert wurde
-(void)reloadMainWindow:(int)tag
{
	[scopeBar checkIfPredicateChanged:tag];
}



#pragma mark -
#pragma mark Overriden Methods

// Registering User Defaults - Preferences
+ (void)initialize
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	
	// Standard-Scopefilter erzeugen
	NSMutableArray *filterArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	int cnt = 0;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_ALL 
										withPredicate:SCOPE_PREDICATE_ALL
									  withDescription:SCOPE_DESCRIPTION_ALL
										   isEditable:NO
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_DOCUMENTS 
										withPredicate:SCOPE_PREDICATE_DOCUMENTS
									  withDescription:SCOPE_DESCRIPTION_DOCUMENTS
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_PDF 
										withPredicate:SCOPE_PREDICATE_PDF
									  withDescription:SCOPE_DESCRIPTION_PDF
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_MEDIA 
										withPredicate:SCOPE_PREDICATE_MEDIA
									  withDescription:SCOPE_DESCRIPTION_MEDIA
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_IMAGES 
										withPredicate:SCOPE_PREDICATE_IMAGES
									  withDescription:SCOPE_DESCRIPTION_IMAGES
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_FOLDERS 
										withPredicate:SCOPE_PREDICATE_FOLDERS
									  withDescription:SCOPE_DESCRIPTION_FOLDERS
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++; 
	
	/*
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_MESSAGES 
										withPredicate:SCOPE_PREDICATE_MESSAGES
									  withDescription:SCOPE_DESCRIPTION_MESSAGES
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	cnt++;
	*/
	
	[filterArray addObject:[NSDictionary createFilter:SCOPE_TITLE_APPS 
										withPredicate:SCOPE_PREDICATE_APPS
									  withDescription:SCOPE_DESCRIPTION_APPS
										   isEditable:YES
											  withTag:[NSNumber numberWithInteger:cnt]]];
	 
		
	
	// Alles registrieren
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
								 filterArray, DEFAULTS_SCOPEFILTER,
								 DEFAULTS_ALWAYSINFRONT_PRESET, DEFAULTS_ALWAYSINFRONT,
								 DEFAULTS_MAILCLIENT_PRESET, DEFAULTS_MAILCLIENT,
								 DEFAULTS_SEARCHINTERVAL_PRESET, DEFAULTS_SEARCHINTERVAL,
								 DEFAULTS_SEARCHSCOPE_PRESET, DEFAULTS_SEARCHSCOPE,
								 DEFAULTS_SEARCHLOCATION_PRESET, DEFAULTS_SEARCHLOCATION,
								 DEFAULTS_HOTKEY_PRESET, DEFAULTS_HOTKEY,
								 nil];
	
	
    [defaults registerDefaults:appDefaults];
	[defaults synchronize];
}


@end
