//
//  RRPrefsWindowController.m
//  Recent Redux
//
//  Created by Tim Schröder on 31.12.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRPrefsWindowController.h"
#import "RRAppDelegate+MetadataQuery.h"
#import "RREmailController.h"
#import "RRAppDelegate+UserDefaults.h"
#import "NSDictionary+RRAdditions.h"

#define RRQUERY_DRAG_AND_DROP @"RRQueryDragAndDrop"

static RRPrefsWindowController *_sharedPrefsWindowController = nil;


#pragma mark -
#pragma mark Focus Ring Methods

// Vergleicht Layers von Views, für Focus Ring
int compareViews (id firstView, id secondView, void *context);
int compareViews (id firstView, id secondView, void *context)
{
	NSResponder *responder = [[firstView window] firstResponder];
	if (!responder) return NSOrderedSame;
	if (responder == firstView) return NSOrderedDescending;
	if ([responder respondsToSelector:@selector(isDescendantOf:)]) {
		NSView *testView = (NSView*)responder;
		if ([testView isDescendantOf:firstView]) return NSOrderedDescending;
	}
	if ([firstView isKindOfClass:[NSScrollView class]]) return NSOrderedDescending;
	return NSOrderedSame;
}


@implementation RRPrefsWindowController

#pragma mark -
#pragma mark Class Methods

+ (RRPrefsWindowController *)sharedPrefsWindowController
{
	if (!_sharedPrefsWindowController) {
		_sharedPrefsWindowController = [[self alloc] initWithWindowNibName:@"Preferences"];
	}
	return _sharedPrefsWindowController;
}

#pragma mark -
#pragma mark Enable Predicate Editor Notification Methods

// Wird aufgerufen, wenn sich im Predicate Editor was ändert
-(void)predicateEditorChanged:(NSNotification *)notification
{
	if ([predicateEditor numberOfRows] > 1) {
		[predicateEditorOKButton setEnabled:YES];
	} else {
		[predicateEditorOKButton setEnabled:NO];
	}
}

#pragma mark -
#pragma mark KVO Methods

-(void)observeValue:(NSString*)keypath
{
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
															  forKeyPath:keypath 
																 options:NSKeyValueObservingOptionOld
																 context:nil];
}

-(void)stopObserving:(NSString*)keypath
{
	[[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self 
																 forKeyPath:keypath];
}


// Gibt Keypath zurück
-(NSString *)keyPath:(NSString*)tag
{
	NSString *key = @"values.";
	NSString *path = [key stringByAppendingString:tag];
	return path;
}


// Wird aufgerufen, wenn User Einstellungen ändert
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context

{
	// Fokus Ring - Focus has changed
	if (([[contentSubview subviews] objectAtIndex:0] == queryPrefsView) && ([keyPath isEqualToString:FIRSTRESPONDERKEY])) {
		[queryPrefsView sortSubviewsUsingFunction:(NSComparisonResult (*)(id, id, void*))compareViews context:nil];
	}
	
	// Hauptfenster updaten, wenn Einstellungen der Query geändert wurden
	if ([keyPath isEqual:[self keyPath:DEFAULTS_SCOPEFILTER]]) {
		[[NSApp delegate] reloadScopeBar];
	}
	
	// User Defaults have changed
    if ([keyPath isEqual:[self keyPath:DEFAULTS_SEARCHINTERVAL]]) {
		// SearchInterval changed
		[[NSApp delegate] startNewQuery:STATUS_UPDATING];
	}
	
	if ([keyPath isEqual:[self keyPath:DEFAULTS_SEARCHSCOPE]]) {
		// SearchScope changed
		[[NSApp delegate] startNewQuery:STATUS_UPDATING];
	}
	
	if ([keyPath isEqual:[self keyPath:DEFAULTS_SEARCHLOCATION]]) {
		// SearchLocation changed
		[[NSApp delegate] startNewQuery:STATUS_UPDATING];
	}
	
	if ([keyPath isEqual:[self keyPath:DEFAULTS_HOTKEY]]) {
		// Hotkey Preferences changed
		[[NSApp delegate] updateHotkey];
	}
	
	if ([keyPath isEqual:[self keyPath:DEFAULTS_MAILCLIENT]]) {
		[self stopObserving:[self keyPath:DEFAULTS_MAILCLIENT]];
		[[NSApp delegate] setDefaultClient:[[selectMailPopUpButton selectedItem] title]];
		[self observeValue:[self keyPath:DEFAULTS_MAILCLIENT]];
	}

}


#pragma mark -
#pragma mark Setup & Teardown

- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:nil];
	if (self != nil) {
		// Set up an array and some dictionaries to keep track
		// of the views we'll be displaying.
		toolbarIdentifiers = [[NSMutableArray alloc] init];
		toolbarViews = [[NSMutableDictionary alloc] init];
		toolbarItems = [[NSMutableDictionary alloc] init];

		// Set up an NSViewAnimation to animate the transitions.
		viewAnimation = [[NSViewAnimation alloc] init];
		[viewAnimation setAnimationBlockingMode:NSAnimationNonblocking];
		[viewAnimation setAnimationCurve:NSAnimationEaseInOut];
		[viewAnimation setDelegate:self];
		
		windowLevel = NSNormalWindowLevel;
	}
	return self;
	(void)window;  // To prevent compiler warnings.
}

- (void)windowDidLoad
{
	// Create a new window to display the preference views.
	// If the developer attached a window to this controller
	// in Interface Builder, it gets replaced with this one.
	NSWindow *window = [[[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,1000,1000)
												    styleMask:(NSTitledWindowMask |
															   NSClosableWindowMask |
															   NSMiniaturizableWindowMask)
													  backing:NSBackingStoreBuffered
													    defer:YES] autorelease];
	[window setAutorecalculatesKeyViewLoop:YES];
	//[window setAllowsConcurrentViewDrawing:YES];
	[self setWindow:window];
	[window setDelegate:self];
	[[self window] setLevel:windowLevel];
	contentSubview = [[[NSView alloc] initWithFrame:[[[self window] contentView] frame]] autorelease];
	[contentSubview setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
	[[[self window] contentView] addSubview:contentSubview];
	[[self window] setShowsToolbarButton:NO];
	// Drag and Drop vorbereiten
	[queryTable registerForDraggedTypes:[NSArray arrayWithObject:RRQUERY_DRAG_AND_DROP]];
}

- (void)windowWillClose:(NSNotification *)notification
{
	// Notification entfernen (Predicate Editor)
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];	
	
	[self stopObserving:[self keyPath:DEFAULTS_SEARCHINTERVAL]];
	[self stopObserving:[self keyPath:DEFAULTS_SEARCHSCOPE]];
	[self stopObserving:[self keyPath:DEFAULTS_SEARCHLOCATION]];
	[self stopObserving:[self keyPath:DEFAULTS_HOTKEY]];
	[self stopObserving:[self keyPath:DEFAULTS_MAILCLIENT]];
	
	[[self window] removeObserver:self forKeyPath:FIRSTRESPONDERKEY];
		
	[self stopObserving:[self keyPath:DEFAULTS_SCOPEFILTER]];
		
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Scope Bar aktualisieren
	[[NSApp delegate] reloadScopeBar];
}

- (void) dealloc {
	[toolbarIdentifiers release];
	[toolbarViews release];
	[toolbarItems release];
	[viewAnimation release];
	[super dealloc];
}


#pragma mark -
#pragma mark Configuration

-(void)updateWindowMode
{
	windowLevel = [[[NSApp delegate] window] level];
	if ([self isWindowLoaded]) [[self window] setLevel:windowLevel];
}

- (void)setupToolbar
{
	[self addView:generalPrefsView 
			label:PREFWINDOW_GENERALPANE
			image:[NSImage imageNamed:@"General"]];
	[self addView:advancedPrefsView 
			label:PREFWINDOW_SEARCHPANE
			image:[NSImage imageNamed:@"Search"]];
	[self addView:queryPrefsView 
			label:PREFWINDOW_QUERIESPANE
			image:[NSImage imageNamed:@"Queries"]];	
}

- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image
{
	NSAssert (view != nil,
			  @"Attempted to add a nil view when calling -addView:label:image:.");
	
	NSString *identifier = [[label copy] autorelease];
	
	[toolbarIdentifiers addObject:identifier];
	[toolbarViews setObject:view forKey:identifier];
	
	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];
	[item setLabel:label];
	[item setImage:image];
	[item setTarget:self];
	[item setAction:@selector(toggleActivePreferenceView:)];
	
	[toolbarItems setObject:item forKey:identifier];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)showWindow:(id)sender openFilterPane:(BOOL)openFilterPaneFlag
{
	(void)[self window];
	// Clear the last setup and get a fresh one.
	[toolbarIdentifiers removeAllObjects];
	[toolbarViews removeAllObjects];
	[toolbarItems removeAllObjects];
	[self setupToolbar];

	NSAssert (([toolbarIdentifiers count] > 0),
			  @"No items were added to the toolbar in -setupToolbar.");
	
	if ([[self window] toolbar] == nil) {
		NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"RRPreferencesToolbar"];
		[toolbar setAllowsUserCustomization:NO];
		[toolbar setAutosavesConfiguration:NO];
		[toolbar setSizeMode:NSToolbarSizeModeDefault];
		[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
		[toolbar setDelegate:self];
		[[self window] setToolbar:toolbar];
		[toolbar release];
	}
	
	// Pane auswählen, das zunächst angezeigt wird, und Key-View-Loop erneuern
	NSString *identifierToBeShown;
	if (openFilterPaneFlag) {
		identifierToBeShown = PREFWINDOW_QUERIESPANE;
	} else {
		identifierToBeShown = [toolbarIdentifiers objectAtIndex:0];
	}
	[[[self window] toolbar] setSelectedItemIdentifier:identifierToBeShown];
	[self displayViewForIdentifier:identifierToBeShown animate:NO];
	[[self window] recalculateKeyViewLoop];

	// Richtige Defaults-Einstellung für Client-Liste erzeugen
	[selectMailPopUpButton setMenu:[[[[RREmailController sharedEmailController] emailClientMenu] copy] autorelease]];
	[selectMailPopUpButton selectItem:nil];
	
	int i;
	for (i=0;i<[[selectMailPopUpButton menu] numberOfItems];i++) {
		NSMenuItem *item = [[selectMailPopUpButton menu] itemWithTitle:[[NSApp delegate] defaultClient]];
        
        // Bug Fix für 1.0.1
		if (item) [selectMailPopUpButton selectItem:item];
	}
	if (![selectMailPopUpButton selectedItem]) {
		NSString *defaultTitle = [[[RREmailController sharedEmailController] preferredEmailClient] valueForKey:MAILCLIENT_TITLE];
		NSMenuItem *item = [[selectMailPopUpButton menu] itemWithTitle:defaultTitle];
        
        // Bug Fix für 1.0.1
		if (item) [selectMailPopUpButton selectItem:item];
	}
	
	// Fensterposition und -level festlegen
	[[self window] center];
	[[self window] setLevel:[[[NSApp delegate] window] level]];
	
	// KVO für UserDefaults hinzufügen
	[self observeValue:[self keyPath:DEFAULTS_SEARCHINTERVAL]];
	[self observeValue:[self keyPath:DEFAULTS_SEARCHSCOPE]];
	[self observeValue:[self keyPath:DEFAULTS_SEARCHLOCATION]];
	[self observeValue:[self keyPath:DEFAULTS_HOTKEY]];
	[self observeValue:[self keyPath:DEFAULTS_MAILCLIENT]];
	
	// KVO für Fokus Ring
	[[self window] addObserver:self
					forKeyPath:FIRSTRESPONDERKEY
					   options:NSKeyValueObservingOptionOld
					   context:nil];
	
	// KVO für Update der Scope Bar
	[self observeValue:[self keyPath:DEFAULTS_SCOPEFILTER]];
		
	// Auswahl in Query-Liste setzen
	[queryArrayController setSelectionIndex:0];
	
	// Notification einrichten (für Predicate Editor)
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(predicateEditorChanged:)
			   name:NSRuleEditorRowsDidChangeNotification 
			 object:predicateEditor];
	
	
	[super showWindow:sender];
}

// Neue Query erzeugen
-(IBAction)addQuery:(id)sender
{
	
	// Neues eindeutiges Tag ermitteln
	int newTag = 0;
	int i;
	BOOL foundTag = NO;
	BOOL alreadyThere = NO;
	int count = [[queryArrayController arrangedObjects] count];
	do {
		for (i=0;i<count;i++) {
			if ((!foundTag) && (!alreadyThere)) {
				NSNumber *compareTag = [[[queryArrayController arrangedObjects] objectAtIndex:i] valueForKey:SCOPE_DICT_TAG];
				if ([compareTag intValue] == newTag) alreadyThere = YES;
			}
		}
		if (!alreadyThere) {
			foundTag = YES;
		} else {
			newTag++;
			alreadyThere = NO;
		}
	} while (foundTag == NO);
	
	// Neue Query erzeugen
	NSDictionary *dict = [NSDictionary createFilter:QUERY_DEFAULTTITLE 
									  withPredicate:@""
									withDescription:QUERY_DEFAULTDESCRIPTION
										 isEditable:YES
											withTag:[NSNumber numberWithInteger:newTag]];
	
	
	NSInteger index = [queryArrayController selectionIndex];
	if (index == NSNotFound) {
		index = 0;
	} else index++;
	
	[queryArrayController insertObject:dict
				 atArrangedObjectIndex:index];
	[queryArrayController setSelectionIndex:index];
	[queryTable scrollRowToVisible:index];
	 
}

// Query löschen
-(IBAction)removeQuery:(id)sender
{
	NSInteger index = [queryArrayController selectionIndex];
	if (index == NSNotFound) return;
	[queryArrayController removeObjectAtArrangedObjectIndex:index];
	int cnt;
	cnt = [[queryArrayController arrangedObjects] count];
	if (index >= cnt) index--;
	[queryArrayController setSelectionIndex:index];
}
	
-(NSPredicate*)predicateFromPredicateString:(NSString*)predicateString
{
	NSPredicate *predicate;
	if ((predicateString == nil) || ([predicateString length] == 0)) {
		predicate = [NSCompoundPredicate orPredicateWithSubpredicates:nil];
	} else {
		NSPredicate *smallPredicate = [NSPredicate predicateWithFormat:predicateString];
		if (![smallPredicate isKindOfClass:[NSCompoundPredicate class]]) {
			NSArray *predArray = [NSArray arrayWithObject:smallPredicate];
			predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predArray];
		} else {
			predicate = smallPredicate;
		}
	}
	return predicate;
}

// Query editieren
- (IBAction) editQuery:(id)sender
{
	// Predicate setzen
	NSInteger index = [queryArrayController selectionIndex];
	if (index == NSNotFound) return;
	NSString *predicateString = [[[queryArrayController arrangedObjects] objectAtIndex:index] valueForKey:SCOPE_DICT_PREDICATE];
	
	// Fehler mit NOT-Operatoren korrigieren
	NSPredicate *predicate;
	predicate = [self predicateFromPredicateString:predicateString];

	[predicateEditor setObjectValue:predicate];
	
	[NSApp beginSheet:editQueryPanel
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

-(IBAction) endSheet:(id)sender 
{
	[NSApp endSheet:[sender window]
		 returnCode:[sender tag]];
	[[sender window] orderOut:self];
}

-(void) sheetDidEnd: (NSWindow*)sheet
		 returnCode:(int)returnCode
		contextInfo:(void *)contextInfo
{
	if (returnCode == 1) {

		// KVO vorübergehend ausschalten
		[self stopObserving:[self keyPath:DEFAULTS_SCOPEFILTER]];

		// Neues Predicate Setzen
		NSString *predicateString;
		NSPredicate *predicate;
		predicate = [predicateEditor predicate];
		if (predicate == nil) {
			predicateString = @"";
		} else {
			predicateString = [predicate predicateFormat];
		}
		NSInteger index = [queryArrayController selectionIndex];
		if (index == NSNotFound) return;
		NSMutableDictionary *dict = [[[[queryArrayController arrangedObjects] objectAtIndex:index] mutableCopy] autorelease];
		[dict setValue:predicateString forKey:SCOPE_DICT_PREDICATE];
		[queryArrayController removeObjectAtArrangedObjectIndex:index];
		int cnt;
		cnt = [[queryArrayController arrangedObjects] count];
		if (index > cnt) index--;
		[queryArrayController insertObject:dict
					 atArrangedObjectIndex:index];
		[queryArrayController setSelectionIndex:index];
		[queryTable scrollRowToVisible:index];
		
		// KVO wieder einschalten
		[self observeValue:[self keyPath:DEFAULTS_SCOPEFILTER]];

		// Wenn aktualisierte Query im Hauptfenster ausgewählt ist, Hauptfenster updaten
		int tag = [[[[queryArrayController arrangedObjects] objectAtIndex:index] valueForKey:SCOPE_DICT_TAG] intValue];
		[[NSApp delegate] reloadMainWindow:tag];
	}
}


#pragma mark -
#pragma mark TableView Delegate

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard

{
    // Copy the row numbers to the pasteboard.
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:RRQUERY_DRAG_AND_DROP] owner:self];
    [pboard setData:data forType:RRQUERY_DRAG_AND_DROP];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op

{
	int result = NSDragOperationNone;
	if ((op == NSTableViewDropAbove) && (row != 0)) {
		result = NSDragOperationMove;
	}
    return result;
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:RRQUERY_DRAG_AND_DROP];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    NSInteger dragRow = [rowIndexes firstIndex];
	if (dragRow == 0) return NO;
	NSDictionary *dict = [[[queryArrayController arrangedObjects] objectAtIndex:dragRow] copy];
	[queryArrayController removeObjectAtArrangedObjectIndex:dragRow];
	int cnt;
	cnt = [[queryArrayController arrangedObjects] count];
	if (row >= cnt) row--;
	[queryArrayController insertObject:dict
				 atArrangedObjectIndex:row];
	[dict release];
	[queryArrayController setSelectionIndex:row];
	return YES;
}

#pragma mark -
#pragma mark Toolbar

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	return toolbarIdentifiers;
	(void)toolbar;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar 
{
	return toolbarIdentifiers;
	(void)toolbar;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return toolbarIdentifiers;
	(void)toolbar;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted 
{
	return [toolbarItems objectForKey:identifier];
	(void)toolbar;
	(void)willBeInserted;
}


- (void)toggleActivePreferenceView:(NSToolbarItem *)toolbarItem
{
	[self displayViewForIdentifier:[toolbarItem itemIdentifier] animate:YES];
}


- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate
{	
	// Find the view we want to display.
	NSView *newView = [toolbarViews objectForKey:identifier];
	[[[self window] toolbar] setSelectedItemIdentifier:identifier];

	// See if there are any visible views.
	NSView *oldView = nil;
	if ([[contentSubview subviews] count] > 0) {
		// Get a list of all of the views in the window. Usually at this
		// point there is just one visible view. But if the last fade
		// hasn't finished, we need to get rid of it now before we move on.
		NSEnumerator *subviewsEnum = [[contentSubview subviews] reverseObjectEnumerator];
		
		// The first one (last one added) is our visible view.
		oldView = [subviewsEnum nextObject];
		
		// Remove any others.
		NSView *reallyOldView = nil;
		while ((reallyOldView = [subviewsEnum nextObject]) != nil) {
			[reallyOldView removeFromSuperviewWithoutNeedingDisplay];
		}
	}
	
	if (![newView isEqualTo:oldView]) {		
		NSRect frame = [newView bounds];
		frame.origin.y = NSHeight([contentSubview frame]) - NSHeight([newView bounds]);
		[newView setFrame:frame];
		[contentSubview addSubview:newView];
		[[self window] setInitialFirstResponder:newView];

		if (animate)
			[self crossFadeView:oldView withView:newView];
		else {
			[oldView removeFromSuperviewWithoutNeedingDisplay];
			[newView setHidden:NO];
			[[self window] setFrame:[self frameForView:newView] display:YES animate:animate];
		}
		NSString *titleString = [NSString stringWithFormat:PREFWINDOW_TITLE, [[toolbarItems objectForKey:identifier] label]];
		[[self window] setTitle:titleString];
	}
}


#pragma mark -
#pragma mark Cross-Fading Methods

- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView
{
	[viewAnimation stopAnimation];
	[viewAnimation setDuration:0.25];
	
	NSDictionary *fadeOutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		oldView, NSViewAnimationTargetKey,
		NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *fadeInDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		newView, NSViewAnimationTargetKey,
		NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *resizeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		[self window], NSViewAnimationTargetKey,
		[NSValue valueWithRect:[[self window] frame]], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect:[self frameForView:newView]], NSViewAnimationEndFrameKey,
		nil];
	
	NSArray *animationArray = [NSArray arrayWithObjects:
		fadeOutDictionary,
		fadeInDictionary,
		resizeDictionary,
		nil];
	
	[viewAnimation setViewAnimations:animationArray];
	[viewAnimation startAnimation];
}


- (void)animationDidEnd:(NSAnimation *)animation
{
	NSView *subview;
	
	// Get a list of all of the views in the window. Hopefully
	// at this point there are two. One is visible and one is hidden.
	NSEnumerator *subviewsEnum = [[contentSubview subviews] reverseObjectEnumerator];
	
	// This is our visible view. Just get past it.
	subview = [subviewsEnum nextObject];

	// Remove everything else. There should be just one, but
	// if the user does a lot of fast clicking, we might have
	// more than one to remove.
	while ((subview = [subviewsEnum nextObject]) != nil) {
		[subview removeFromSuperviewWithoutNeedingDisplay];
	}

		// This is a work-around that prevents the first
		// toolbar icon from becoming highlighted.
	[[self window] makeFirstResponder:nil];

	(void)animation;
}


- (NSRect)frameForView:(NSView *)view
	// Calculate the window size for the new view.
{
	NSRect windowFrame = [[self window] frame];
	NSRect contentRect = [[self window] contentRectForFrameRect:windowFrame];
	float windowTitleAndToolbarHeight = NSHeight(windowFrame) - NSHeight(contentRect);

	windowFrame.size.height = NSHeight([view frame]) + windowTitleAndToolbarHeight;
	windowFrame.size.width = NSWidth([view frame]);
	windowFrame.origin.y = NSMaxY([[self window] frame]) - NSHeight(windowFrame);
	
	return windowFrame;
}
		

@end
