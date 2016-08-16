//
//  RRAppDelegate+Actions.m
//  Recent Redux
//
//  Created by Tim Schröder on 21.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+Actions.h"
#import "RRAppDelegate+UserDefaults.h"
#import "RRAppDelegate+QLPreviewPanel.h"
#import "RRAppDelegate+Email.h"
#import "RRTableView.h"
#import "NSString+RRAdditions.h"
#import "NSFileManager+RRAdditions.h"
#import "RRPrefsWindowController.h"
#import "RRAlert.h"
#import "RRItem.h"

@implementation RRAppDelegate (Actions)

#pragma mark -
#pragma mark MenuItems & MenuItems Validation

// Kontextmenü für Open-With-Methode erzeugen
- (NSMenu*)menuForFilePath:(NSString*)filePath
{
	NSMenu *menu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	
	NSSize size;
	size.width = 16;
	size.height = 16;
	
	// Default App in Menü aufnehmen
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	NSURL *appURL = [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:fileURL];
	NSString *defaultPath = @"";
	NSString *defaultName = @"";
	NSString *defaultVersion = @"";
	if (appURL) {
		defaultPath = [appURL path];
		defaultName = [[NSFileManager defaultManager] displayNameAtPath:defaultPath];
		
		NSBundle *bundle = [NSBundle bundleWithPath:defaultPath];
		defaultVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
		if (defaultVersion==nil) defaultVersion = @"";
		NSString *title = [NSString stringWithFormat:@"%@ (%@)", defaultName, MENU_STANDARD];
		NSMenuItem *defaultItem = [[[NSMenuItem alloc] initWithTitle:title
															  action:@selector(openFileWith:)
													   keyEquivalent:@""] autorelease];
		NSImage *defaultImage = [[NSWorkspace sharedWorkspace] iconForFile:defaultPath];
		if (defaultImage) {
			[defaultImage setSize:size];
			[defaultItem setImage:defaultImage];
		}
		[defaultItem setTarget:self];
		[defaultItem setRepresentedObject:defaultPath];
		[defaultItem setEnabled:YES];
		[menu addItem:defaultItem];
		
		NSMenuItem *separatorItem = [NSMenuItem separatorItem];
		[menu addItem:separatorItem];
		
	}
	
	// Alle übrigen Apps in Menü aufnehmen
	NSArray *appArray = [[NSFileManager defaultManager] openWithMenuForFile:filePath];
	int i;
	for (i=0;i<[appArray count]; i++) {
		NSDictionary *dict = [appArray objectAtIndex:i];
		NSString *appName = [dict valueForKey:@"appName"];
		NSString *appPath = [dict valueForKey:@"appPath"];
		// Prüfen, ob schon als Standard-App vorhanden
		BOOL isDefaultApp = NO;
		if ([appPath isEqualToString:defaultPath]) isDefaultApp = YES;
		if (([appName isEqualToString:defaultName]) && ([defaultVersion isEqualToString:[dict valueForKey:@"appVersion"]])) isDefaultApp = YES;
		if (!isDefaultApp) {
			NSMenuItem *menuItem = [[[NSMenuItem alloc] initWithTitle:appName
															   action:@selector(openFileWith:) 
														keyEquivalent:@""] autorelease];
			NSImage *itemImage = [[NSWorkspace sharedWorkspace] iconForFile:[dict valueForKey:@"appPath"]];
			if (itemImage) {
				[itemImage setSize:size];
				[menuItem setImage:itemImage];
			}
			[menuItem setTarget:self];
			[menuItem setRepresentedObject:appPath];
			[menu addItem:menuItem];
		}
	}
	
	// Ggf. weiteren Separator hinzufügen
	if ([menu numberOfItems] > 0) {
		NSMenuItem *lastItem = [menu itemAtIndex:[menu numberOfItems]-1];
		if (![lastItem isSeparatorItem]) {
			NSMenuItem *separatorItem = [NSMenuItem separatorItem];
			[menu addItem:separatorItem];
		}
	}
	
	// Eintrag zum Auswählen eines anderen Programms (zum Öffnen) einfügen
	NSMenuItem *menuItem = [[[NSMenuItem alloc] initWithTitle:MENU_OTHERAPP
													   action:@selector(openFileWith:) 
												keyEquivalent:@""] autorelease];
	[menuItem setTarget:self];
	[menuItem setRepresentedObject:MENU_OTHERAPP];
	[menu addItem:menuItem];
	return menu;
}

// Menuitems validieren und dynamische Bezeichnungen, Unterscheidung der verschiedenen Items über Tags
- (BOOL)validateMenuItem:(NSMenuItem *)item 
{
	// Quicklook
	if ([item tag] == MENU_QUICKLOOK_TAG) {
		NSInteger index = [table activeRow];
		if ([self previewPanelIsVisible]) {
			// Bezeichnung in Menüs ändern 
			[[mainMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:MENU_QUICKLOOK_ACTIVE];
			[[contextMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:MENU_QUICKLOOK_ACTIVE];				
		} else {
			// Bezeichnung in Menüs ändern
			if (index != RRNotFound) {
				NSString *filename = [[[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_NAME] truncateString];
				
				NSString *menuCaption = [NSString stringWithFormat:@"%@ \"%@\"", MENU_QUICKLOOK, filename];
				
				[[mainMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:menuCaption];
				[[contextMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:menuCaption];
				
			} else {
				[[mainMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:MENU_QUICKLOOK];
				[[contextMenu itemWithTag:MENU_QUICKLOOK_TAG] setTitle:MENU_QUICKLOOK];
			}
		}
		if (([table activeRow] != RRNotFound) || ([[QLPreviewPanel sharedPreviewPanel] isVisible])) return YES;
	}
	
	// Copy Path to Clipboard
	if ([item tag] == MENU_COPYPATH_TAG) {
		if ([table activeRow] != RRNotFound) return YES;
	}
	
	// Copy File to Clipboard
	if ([item tag] == MENU_COPY_TAG) {
		NSInteger index = [table activeRow];
		if (index != RRNotFound) {
			NSString *filename = [[[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_NAME]
								  truncateString];
			
			NSString *menuCaption = [NSString stringWithFormat: MENU_COPY_FILE, filename];
						
			[[mainMenu itemWithTag:MENU_COPY_TAG] setTitle:menuCaption];
			[[contextMenu itemWithTag:MENU_COPY_TAG] setTitle:menuCaption];
			return YES;
		} else {
			[[mainMenu itemWithTag:MENU_COPY_TAG] setTitle:MENU_COPY];
			[[contextMenu itemWithTag:MENU_COPY_TAG] setTitle:MENU_COPY];
		}
	}
	
	// Show in Finder
	if ([item tag] == MENU_SHOWINFINDER_TAG) {
		if ([table activeRow] != RRNotFound) return YES;
	}
	
	// Always in Front
	if ([item tag] == MENU_ALWAYSINFRONT_TAG) {
		
		return YES;
	}
	
	// Open File
	if ([item tag] == MENU_OPENFILE_TAG) {
		if ([table activeRow] != RRNotFound) {
			// nur YES zurückgeben, wenn Standard-App definiert ist
			NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:[table activeRow]] valueForKey:ITEM_META];
			NSString *path = [item valueForAttribute:MDI_PATH];

			NSURL *pathURL = [NSURL fileURLWithPath:path];
			if (pathURL == nil) return NO; 
			
			// Standard-App starten
			if ([[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:pathURL] == nil) return NO;
			
			return YES;
		}
	}
	
	// Open File With
	if ([item tag] == MENU_OPENWITH_TAG) {
		if ([table activeRow] != RRNotFound) {
			// Kontext-Menü bestücken
			NSMetadataItem *mdItem = [[[filterController arrangedObjects] objectAtIndex:[table activeRow]] valueForKey:ITEM_META];
			NSString *path = [mdItem valueForAttribute:MDI_PATH];
			
			// Wenn App selektiert ist, kein Open With anbieten
			RRItem *selItem = [[filterController arrangedObjects] objectAtIndex:[table activeRow]];
			if (([selItem isItemApplication]) || ([selItem isItemFolder])) {
				[item setHidden:YES];
				return NO;
			} else {
				[item setHidden:NO];
				NSMenu *subMenu = [self menuForFilePath:path];
				[item setSubmenu:subMenu];
				return YES;
			}
		}
	}
	// Für die Einträge im Kontextmenü "Open With"
	if ([item tag] == MENU_OPENWITHENTRY_TAG) return YES; 
	
	// Share with Email
	if ([item tag] == MENU_EMAIL_TAG) {
		if ([table activeRow] != RRNotFound) return YES;
	}
	
	// Edit Filters
	if ([item tag] == MENU_EDITFILTERS_TAG) {
		return YES;
	}
	
	// Close Window
	if ([item tag] == MENU_CLOSE_TAG) {
		return YES;
	}
	
	// Preferences Window
	if ([item tag] == MENU_PREFERENCES_TAG) {
		return YES;
	}
	
	return NO;
}


#pragma mark -
#pragma mark Show Main Window

-(IBAction) showMainWindow:(id)sender
{
	NSApplication *thisApp = [NSApplication sharedApplication];
	[thisApp activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:nil];
}

#pragma mark -
#pragma mark Preview Panel (Quicklook)

// Wird von RRTableView und von Hauptmenü/Kontextmenü aufgerufen und zeigt Panel an bzw. verbirgt es
- (IBAction)togglePreviewPanel:(id)sender
{
	if (([table activeRow] != RRNotFound) || ([self previewPanelIsVisible])) {
		if ([self previewPanelIsVisible]) {
			[[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
		} else {
			[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
		}
	}
}

#pragma mark -
#pragma mark Copy Path to Clipboard

// Wird von RRTableView und von Hauptmenü/Kontextmenü aufgerufen und kopiert Pfad in Zwischenablage
-(IBAction)copyPathToClipboard:(id)sender
{
	NSInteger index = [table activeRow];
	if (index != RRNotFound) {
		
		// Path ermitteln
		NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
		NSString *path = [item valueForAttribute:MDI_PATH];
		
		// in Pasteboard kopieren
		NSPasteboard *pboard = [NSPasteboard generalPasteboard];
		[pboard clearContents];
		NSArray *copiedObjects = [NSArray arrayWithObject:path];
		[pboard writeObjects:copiedObjects];
	}
}

#pragma mark -
#pragma mark Share with Email

-(IBAction) shareWithEmail:(id)sender
{
	NSInteger index = [table activeRow];
	if (index != RRNotFound) {
		NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
		[self prepareEmail:item];
	}
}

#pragma mark -
#pragma mark Copy File to Clipboard

// Wird von RRTableView und von Hauptmenü/Kontextmenü aufgerufen und kopiert Pfad in Zwischenablage
-(IBAction)copyFileToClipboard:(id)sender
{
	NSInteger index = [table activeRow];
	if (index != RRNotFound) {
		
		// Path ermitteln
		NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
		NSString *path = [item valueForAttribute:MDI_PATH];
		
		// in Pasteboard kopieren
		NSPasteboard *pboard = [NSPasteboard generalPasteboard];
		[pboard clearContents];
		NSURL *url = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
		NSArray *copiedObjects = [NSArray arrayWithObject:url];
		[pboard writeObjects:copiedObjects];
	}
}

#pragma mark -
#pragma mark Show in Finder

// Wird von RRTableView und von Hauptmenü/Kontextmenü aufgerufen und zeigt Datei im Finder an
-(IBAction)showInFinder:(id)sender
{
	NSInteger index = [table activeRow];
	if (index != RRNotFound) {
		NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
		NSString *path = [item valueForAttribute:MDI_PATH];
		
		NSWorkspace *ws = [NSWorkspace sharedWorkspace];
		[ws selectFile:path inFileViewerRootedAtPath:nil];
	}
}

#pragma mark -
#pragma mark Always in Front


// Implementierung des Menübefehls für die Funktion, das Hauptfenster immer im Vordergrund zu halten
-(IBAction)toggleAlwaysFront:(id)sender
{
	if ([window level] != NSNormalWindowLevel) {
		[window setLevel:NSNormalWindowLevel];
		[toggleAlwaysInFrontMenuItem setState:NSOffState];			// Im Prinzip hier auch Nachricht an "sender" möglich
		[self setWindowMode:NO];
		[[RRPrefsWindowController sharedPrefsWindowController] updateWindowMode];
	} else {
		// BAUSTELLE:
		// Statt window besser [[[NSApp delegate] mainController] window]????
		
		[window setLevel:NSMainMenuWindowLevel];
		[window setCollectionBehavior:NSWindowCollectionBehaviorManaged];
		[window makeKeyAndOrderFront:self];
		[toggleAlwaysInFrontMenuItem setState:NSOnState];			// Allerdings dann Probleme bei Programmstart
		[self setWindowMode:YES];
		[[RRPrefsWindowController sharedPrefsWindowController] updateWindowMode];
	}

}

#pragma mark -
#pragma mark Open


// File öffnen
-(IBAction)openFile:(id)sender
{
	[self tableDoubleClick];
}

// File öffnen
-(void)tableDoubleClick
{
	NSInteger index = [table activeRow];
	if (index != RRNotFound) {
		NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
		[self openFileWithItem:item];
	}
}

-(void)openFileWithItem:(NSMetadataItem*)item
{
	NSString *path = [item valueForAttribute:MDI_PATH];
	
	// Pfad der Standard-App ermitteln
	NSURL *pathURL = [NSURL fileURLWithPath:path];
	if (pathURL == nil) return; 
	
	// Standard-App starten
	[[NSWorkspace sharedWorkspace] openURL:pathURL];
}

-(IBAction) openFileWith:(id)sender
{
	if ([sender representedObject] == nil) return; // Falls direkt auf den Eintrag "Open with" geklickt wird
	//NSLog (@"%@", [sender representedObject]);
	NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:[table activeRow]] valueForKey:ITEM_META];
	NSString *itemPath = [item valueForAttribute:MDI_PATH];
	NSString *appPath = [sender representedObject];
	
	// Ggf. NSOpenPanel anzeigen
	if ([appPath isEqualToString:MENU_OTHERAPP]) {
		NSOpenPanel *openPanel = [NSOpenPanel openPanel];
		[openPanel setTreatsFilePackagesAsDirectories:NO];
		[openPanel setAllowsMultipleSelection:NO];
		[openPanel setCanChooseDirectories:NO];
		[openPanel setCanChooseFiles:YES];
		NSArray *paths = NSSearchPathForDirectoriesInDomains (NSApplicationDirectory, NSLocalDomainMask, YES);
		if ([paths count] > 0) {
			NSString *appFolder = [paths objectAtIndex:0];
			NSURL *appURL = [NSURL fileURLWithPath:appFolder];
			[openPanel setDirectoryURL:appURL];
		}
		// Cancel-Button umbenennen
		NSArray *sviews = [[openPanel contentView] subviews];
		int i;
		for (i=0;i<[sviews count];i++) {
			NSArray *ssviews = [[sviews objectAtIndex:i] subviews];
			int j;
			for (j=0;j<[ssviews count];j++) {
				if ([[ssviews objectAtIndex:j] isKindOfClass:[NSButton class]]) {
					
					if ([[[ssviews objectAtIndex:j] title] isEqualToString:OPEN_WITH_CANCEL_ORG]) {
						NSButton *cancelButton = [ssviews objectAtIndex:j];
						NSRect ctrlRect1 = [cancelButton frame];
						[cancelButton setTitle:CANCELBUTTONCAPTION];
						[cancelButton sizeToFit];
						NSRect ctrlRect2 = [cancelButton frame];
						double d = ctrlRect2.size.width-ctrlRect1.size.width+15;
						ctrlRect2.origin.x=ctrlRect2.origin.x-d;
						ctrlRect2.size.width=ctrlRect2.size.width+15;
						[cancelButton setFrame:ctrlRect2];	
					}
				}
			}
		}
		
		[openPanel setTitle:MENU_OPENWITHCAPTION];
		[openPanel setPrompt:OPEN_WITH_OK_LOC];
		NSString *message = [NSString stringWithFormat:OPEN_WITH_CAPTION, [[[filterController arrangedObjects] objectAtIndex:[table activeRow]] valueForKey:ITEM_NAME]];
		[openPanel setMessage:message];
		[openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
		
		[openPanel beginSheetModalForWindow:window
						  completionHandler:^(NSInteger result) {
			if (result == NSOKButton) {
				[openPanel orderOut:self]; // close panel before we might present an error
				[[NSWorkspace sharedWorkspace] openFile:itemPath withApplication:[[openPanel URL] path]];
			}
		}];
	} else {
		[[NSWorkspace sharedWorkspace] openFile:itemPath withApplication:appPath];
	}
}


#pragma mark -
#pragma mark Hotkey

-(IBAction) hotkeyPressed:(id)sender
{
	NSApplication *thisApp = [NSApplication sharedApplication];
	[thisApp activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:nil];
}

#pragma mark -
#pragma mark Dock Menu

// Wird aufgerufen, wenn Item im Dock-Menü geclickt wird
-(IBAction)dockMenuClicked:(id)sender
{
	// Hier potentielle Fehlerquelle, wenn sich Array verändert, während Dockmenü offen ist
	int index = [dockMenu indexOfItem:sender];
	NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:index] valueForKey:ITEM_META];
	if (item) [self openFileWithItem:item];
}

// Erzeugt dynamisch das DockMenu mit den jüngsten Einträgen der Liste
- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
	if (!dockMenu) {
		dockMenu = [[NSMenu alloc] initWithTitle:@""];
		[dockMenu setAutoenablesItems:NO];
	} else {
		[dockMenu removeAllItems];
	}
	
	int count = 10;
	
	if ([[filterController arrangedObjects] count] < count) count = [[filterController arrangedObjects] count];
	if (count == 0) return nil;
	int i;
	for (i=0;i<count;i++) {
		NSString *name = [[[filterController arrangedObjects] objectAtIndex:i] valueForKey:ITEM_NAME];
		NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:[name truncateString]
													   action:@selector(dockMenuClicked:)
												keyEquivalent:@""] autorelease];
		NSMetadataItem *metaItem = [[[filterController arrangedObjects] objectAtIndex:i] valueForKey:ITEM_META];
		NSString *path = [metaItem valueForAttribute:MDI_PATH];
		NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:path];
		[item setImage:image]; 
		[dockMenu addItem:item];
		
	}
	return dockMenu;
}


#pragma mark -
#pragma mark Preferences Window

- (IBAction)openPreferencesWindow:(id)sender
{
	[[RRPrefsWindowController sharedPrefsWindowController] showWindow:self openFilterPane:NO];
}

-(IBAction) editFilters:(id)sender
{
	[[RRPrefsWindowController sharedPrefsWindowController] showWindow:self openFilterPane:YES];
}


@end
