//
//  RREmailController.m
//  Recent Redux
//
//  Created by Tim Schröder on 05.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RREmailController.h"

static RREmailController *_sharedEmailController = nil;

@implementation RREmailController

#pragma mark -
#pragma mark Singleton Methods

+ (RREmailController *)sharedEmailController
{
	if (!_sharedEmailController) {
        _sharedEmailController = [[super allocWithZone:NULL] init];
    }
    return _sharedEmailController;
}	
	
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedEmailController] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}


#pragma mark -
#pragma mark Email Methods

// Gibt URL für Titel eines Clients zurück
-(NSURL*)URLForTitle:(NSString*)title
{
	NSURL *resultURL;
	resultURL = nil;
	NSArray *clients = [self availableEmailClients];
	int i;
	for (i=0;i<[clients count];i++) {
		NSDictionary *dict = [clients objectAtIndex:i];
		if ([[dict valueForKey:MAILCLIENT_TITLE] isEqualToString:title]) resultURL = [dict valueForKey:MAILCLIENT_URL];
	}
	return resultURL;
}

// Gibt Bundle-Identifier eines Clients zurück
-(NSString*)bundleIdentifier:(NSURL*)url
{
	NSBundle *bundle = [NSBundle bundleWithURL:url];
	NSDictionary *dict = [bundle infoDictionary];
	return [dict valueForKey:@"CFBundleIdentifier"];
}

// Gibt zurück, ob unterstützter Email-Client installiert ist
-(BOOL)hasValidEmailClient
{
	BOOL returnFlag = NO;
	NSArray *clients = [self availableEmailClients];
	if ([clients count] > 0) returnFlag = YES;
	return returnFlag;
}

// Gibt Infos des installierten Default-Clients zurück
-(NSDictionary*)preferredEmailClient
{
	CFURLRef emailURL = NULL;
	LSGetApplicationForURL((CFURLRef)[NSURL URLWithString:@"mailto:"], kLSRolesAll, NULL, &emailURL);
	NSURL *pathURL = [(NSURL *)emailURL autorelease]; 
	if (pathURL) return [self getClientInfo:pathURL];
	return nil;
}

// Sucht Daten zu einem Pfad einer Mail-App heraus
-(NSDictionary*)getClientInfo:(NSURL*)url
{
	NSBundle *bundle = [NSBundle bundleWithURL:url];
	NSDictionary *dict = [bundle infoDictionary];
	NSString *displayName = [dict valueForKey:@"CFBundleDisplayName"];
	NSString *name = [dict valueForKey:@"CFBundleName"];
	NSString *version = [dict valueForKey:@"CFBundleShortVersionString"];
	NSString *identifier = [dict valueForKey:@"CFBundleIdentifier"];
	NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:[url path]];
	
	NSString *title;
	if (displayName) {
		title = displayName;
	} else {
		title = name;
	}
	
	NSString *longTitle = [title stringByAppendingFormat:@" (%@)", version];
	NSDictionary *returnDict = [NSDictionary dictionaryWithObjectsAndKeys:
								title, MAILCLIENT_TITLE,
								longTitle, MAILCLIENT_LONGTITLE,
								version, MAILCLIENT_VERSION,
								identifier, MAILCLIENT_IDENTIFIER,
								image, MAILCLIENT_ICON,
								url, MAILCLIENT_URL,
								nil];
	return returnDict;
}

// Prüft, ob ein Mail-Client unterstützt wird
-(BOOL)isValidMailClient:(NSURL*)url
{
	NSArray *validClients = [NSArray arrayWithObjects:
							 CLIENT_APPLEMAIL, 
							 CLIENT_OUTLOOK,
							 CLIENT_ENTOURAGE,
							 CLIENT_POSTBOX,
							 nil];
	BOOL returnFlag = NO;
	NSString *identifier = [self bundleIdentifier:url];
	int i;
	for (i=0;i<[validClients count];i++) {
		if ([[validClients objectAtIndex:i] isEqualToString:identifier]) returnFlag = YES;
	}
	return returnFlag;
}

// Gibt Array mit Bezeichnungen + Icons der konkret verfügbaren (! nicht der installierten) Clients zurück
-(NSArray*)availableEmailClients
{		
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
	CFArrayRef array = NULL;
	NSString *mailto = @"mailto";
	array = LSCopyAllHandlersForURLScheme ((CFStringRef)mailto);
	int i;
	for (i=0;i<[(NSArray*)array count];i++) {
		NSString *identifier = [(NSArray*)array objectAtIndex:i];
		NSString *path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:identifier];
        if (path) {
            NSURL *url = [NSURL fileURLWithPath:path];
            if (url) {
                if ([self isValidMailClient:url]) {
                    NSDictionary *dict = [self getClientInfo:url];
                    [returnArray addObject:dict];
                }
            }
        }
	}
	if (array != NULL) CFRelease(array);
	return [NSArray arrayWithArray:returnArray];
}

// Gibt Menü mit unterstützten und installierten Email-Clients zurück
-(NSMenu*)emailClientMenu
{
	NSMenu *clientMenu;
	clientMenu = [[[NSMenu alloc] init] autorelease];
	[clientMenu setAutoenablesItems:NO];
	NSArray *availableArray = [self availableEmailClients];
	NSArray *supportedArray = [NSArray arrayWithObjects: CLIENT_APPLEMAIL_TITLE, CLIENT_ENTOURAGE_TITLE, CLIENT_OUTLOOK_TITLE, CLIENT_POSTBOX_TITLE, nil];
	NSSize size;
	size.width = 16;
	size.height = 16;
	NSImage *emptyImage = [NSImage imageNamed:@"rrempty16.png"];
	int i;
	for (i=0;i<[supportedArray count];i++) {
		NSString *title = [supportedArray objectAtIndex:i];
		NSMenuItem *item = [clientMenu addItemWithTitle:title
													  action:NULL
											   keyEquivalent:@""];
		[item setEnabled:NO];
		[item setImage:emptyImage];
		int j;
		for (j=0;j<[availableArray count];j++) {
			if ([title isEqualToString:[[availableArray objectAtIndex:j] valueForKey:MAILCLIENT_TITLE]]) {
				[item setEnabled:YES];
				NSImage *image = [[availableArray objectAtIndex:j] valueForKey:MAILCLIENT_ICON];
				[image setSize:size];
				[item setImage:image];
			}
		}
	}
	return clientMenu;
}

@end
