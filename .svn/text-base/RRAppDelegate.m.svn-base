//
//  RRAppDelegate.m
//  Recent Redux
//
//  Created by Tim Schröder on 28.10.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate.h"
#import "RRTableCell.h"
#import "RRAppDelegate+UserDefaults.h"
#import "NSString+RRAdditions.h"
#import "NSFileManager+RRAdditions.h"
#import "RRAppDelegate+Actions.h"
#import "RRItem.h"
#import "RRTableView.h"
#import "RRAppDelegate+MetadataQuery.h"
#import "RRStatusBar.h"
#import "RRAppDelegate+Trial.h"

#pragma mark -
#pragma mark Application Delegate


@implementation RRAppDelegate

@synthesize window, arraySortDescriptors;

#pragma mark -
#pragma mark Overriden Methods

- (id)init
{
    self = [super init];
    if (self) {
		
		// Item-Array erzeugen (ist iVar)
		items = [[NSMutableArray alloc] init];
		
		// Sortierung für ItemController (wird in XIB-Datei verknüpft)
		NSSortDescriptor *des = [[NSSortDescriptor alloc] initWithKey:ITEM_RAWDATE
															 ascending:NO
															 selector:@selector(compare:)];
		arraySortDescriptors = [[NSArray arrayWithObjects:des, nil] retain];
		[des release];
		
		// Operation Queue für Background-Threads erzeugen
		operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)dealloc
{
	[items release];
	[arraySortDescriptors release];
	[arrayPredicate release];
	[query release];
	[operationQueue release];
	[dockMenu release];
	[super dealloc];
}

-(void)awakeFromNib 
{
	// Custom Table Cell initialisieren
	RRTableCell *tableCell = [[RRTableCell alloc] init];
	[tableColumn setDataCell:tableCell];
	[tableCell release];
	/*
	arrayPredicate = [NSPredicate predicateWithFormat:@"itemType CONTAINS 'public.executable'"];
	[filterController setFilterPredicate:arrayPredicate];
	 */
	
	// Modus des Fensters setzen (AlwaysInFront)
	[self setInitialWindowMode];
	//[window setAllowsConcurrentViewDrawing:YES];

	// Hotkey initialisieren
	[self updateHotkey];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{	
	// Binding für StatusBar setzen
	[statusBar setCountBinding:filterController];
	
    // Bug Fix für 1.0.2: Code zum Anzeigen des Trial-Fensters aus awakeFromNib hierher verschoben
#ifdef TRIAL
    // Wenn Trial-Version, entsprechende Methoden aufrufen
    // if ([self checkIfAppStoreVersionIsInstalled] == NO) {
    // Wenn App Store Version installiert ist, keine Trial-Prüfung, sonst dieser Code
    if ([self checkIfExpired]) {
        // expired
        [self showExpiredMessage];
    } else
    {
        // not expired
        [self showRemainingTrialMessage];
    }
    // }
#endif
    
	// Query starten
	[self startNewQuery:STATUS_FETCHING];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification 
{	
}


#pragma mark -
#pragma mark TableView Delegate

// Expansion ToolTips ausschalten (würden nämlich das NSDictionary von RRItem anzeigen)
- (BOOL)tableView:(NSTableView *)tableView 
		shouldShowCellExpansionForTableColumn:(NSTableColumn *)tableColumn 
			  row:(NSInteger)row 
{
	return NO;
}

// Als ToolTip der Zeilen werden der Dateipfad und die Dateigröße angezeigt
- (NSString *)tableView:(NSTableView *)aTableView 
		 toolTipForCell:(NSCell *)aCell 
				   rect:(NSRectPointer)rect 
			tableColumn:(NSTableColumn *)aTableColumn 
					row:(NSInteger)row 
		  mouseLocation:(NSPoint)mouseLocation
{
	NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:row] valueForKey:ITEM_META];
	
	// Pfad
	NSString *path = [item valueForAttribute:MDI_PATH];
	NSString *formattedPath = [[path stringByAbbreviatingWithTildeInPath] stringByDeletingLastPathComponent];
	
	// Filegröße
	NSNumber *size = [item valueForAttribute:MDI_SIZE];
	long long lsize = [size longValue];
	BOOL isAnApp = [[[filterController arrangedObjects] objectAtIndex:row] isItemApplication];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (isAnApp) lsize = [fileManager fastFolderSizeAtPath:path
													 isApp:YES];
	if (lsize != 0) {
		return [NSString stringWithFormat:@"%@ (%@)", formattedPath, [NSString stringWithFileSize:lsize]];
	}
	return [NSString stringWithFormat:@"%@", formattedPath];
}

// Implementierung von Drag und Drop
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard

{
	if ([rowIndexes count] == 0) return NO;
    NSRect rect = [table frameOfCellAtColumn:0 row:[rowIndexes firstIndex]];
	if ([table isFlipped]) {
		NSRect taRect = [[table enclosingScrollView] frame];
		NSRect baRect = [table convertRectToBase:rect];
		float diff = taRect.origin.y-baRect.origin.y;
		rect.origin.y=rect.origin.y-diff+(rect.size.height/2.0);
	}
	NSMetadataItem *item = [[[filterController arrangedObjects] objectAtIndex:[rowIndexes firstIndex]]
							valueForKey:ITEM_META];
	NSString *path = [item valueForAttribute:MDI_PATH];
	[table dragFile:(NSString *)path fromRect:rect slideBack:YES event:nil];
	return YES;
}	


#pragma mark -
#pragma mark RRScopeBarDelegate

-(NSDictionary *)itemAtIndex:(int)index
{
	NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_SCOPEFILTER];
	if (array) {
		if (index < [array count]) {
			return [array objectAtIndex:index];
		}
	}
	return nil;
}

-(int)itemCount
{
	NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_SCOPEFILTER];
	if (array) {
		return [array count];
	}
	return -1;
}

// In Scopebar wurde ein Item ausgewählt/abgewählt
- (void) selectedStateChanged:(NSArray*)scopeArray
{
	[filterController setFilterPredicate:nil];
	NSString *predicateString = @"";
	NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_SCOPEFILTER];

	for (NSDictionary *dict in scopeArray) {
		if ([[dict valueForKey:SCOPE_DICT_ENABLED] isEqualToString:@"YES"]) {
			NSNumber *tag = [dict valueForKey:SCOPE_DICT_TAG];
			int j;
			NSString *predicate = @"";
			for (j=0;j<[array count];j++) {
				if ([[[array objectAtIndex:j] valueForKey:SCOPE_DICT_TAG] isEqualToNumber: tag]) {
					predicate = [[array objectAtIndex:j] valueForKey:SCOPE_DICT_PREDICATE];
				}
			}
			if (![predicate isEqualToString:@""]) {
				if (![predicateString isEqualToString:@""]) {
					predicateString = [predicateString stringByAppendingString:@" OR "];
				}
				predicateString = [predicateString stringByAppendingString:predicate];
			}
		}
	}
	// Wenn Predicate Leer ist, keinen neuen Filter setzen
	if (![predicateString isEqualToString:@""]) {
		arrayPredicate = [NSPredicate predicateWithFormat:predicateString];
		[filterController setFilterPredicate:arrayPredicate];
	}
}

#pragma mark -
#pragma mark Main Window Delegate

// Wird von windowShouldClose aufgerufen, erzeugt Menüeintrag für Hauptfenster im Menü
- (void) orderOutMyWindow: (id) sender {
	NSString* title = [self.window title];
	[self.window orderOut: sender];
	[NSApp addWindowsItem: (NSWindow*)self.window 
					title: title 
				 filename: NO];
}

// Delegate Method, wird vor Schließen des Hauptfensters aufgerufen
- (BOOL) windowShouldClose: (id) sender {
	[self performSelector: @selector (orderOutMyWindow:) withObject: sender afterDelay: 0.0];
	return NO;
}

@end
