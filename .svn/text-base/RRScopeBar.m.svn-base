//
//  RRScopeBar.m
//  Recent Redux
//
//  Created by Tim Schröder on 09.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRScopeBar.h"
#import "RROverflowPullDownCell.h"


@implementation RRScopeBar

@synthesize delegate;

#pragma mark -
#pragma mark Setup

-(id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
		
    }
    return self;
}

-(void) dealloc
{
	delegate = nil;
	[moreButton release];
	[buttons release];
	[super dealloc];
}

// Delegate für Scope Bar setzen (AppDelegate ist Delegate und liefert Bezeichnungen der Scope Items)
- (void)setDelegate:(id)newDelegate
{
	if (delegate != newDelegate) {
		delegate = newDelegate;
	}
}
	
-(void)awakeFromNib 
{
	if (self.delegate && [delegate conformsToProtocol:@protocol(RRScopeBarDelegate)]) {
		[self loadData];
	}
}

#pragma mark -
#pragma mark Button Utilities

-(void)turnOnButtonAtIndex:(int)index
{
	[[buttons objectAtIndex:index] setState:NSOnState];
	[[[moreButton menu] itemAtIndex:index+1] setState:NSOnState];
	[[filterMenu itemAtIndex:index] setState:NSOnState];	
}

-(void)turnOffButtonAtIndex:(int)index
{
	[[buttons objectAtIndex:index] setState:NSOffState];
	[[[moreButton menu] itemAtIndex:index+1] setState:NSOffState];
	[[filterMenu itemAtIndex:index] setState:NSOffState];	
}


#pragma mark -
#pragma mark Data Management

-(void)loadData
{
	// Daten und Anzeige zurücksetzen
	NSArray *subviews = [[self subviews] copy];
	[subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[subviews release];
	[buttons release];
	buttons = nil;
	totalWidth = 0;
	lastWidth = RRNotFound;
	hasHiddenButtons = NO;
	
	NSArray *menuItems = [filterMenu itemArray];
	int i;
	for (i=0;i<[menuItems count];i++) {
		NSMenuItem *menuItem = [menuItems objectAtIndex:i];
		if (([menuItem tag] != MENU_EDITFILTERS_TAG) && ([menuItem tag] != MENU_EDITFILTERSSEP_TAG)) [filterMenu removeItem:menuItem];
	}
	
	int idx = 0;
	buttons = [[NSMutableArray alloc] initWithCapacity:0];
	
	// Anzeige neu erstellen
	if (self.delegate && [delegate conformsToProtocol:@protocol(RRScopeBarDelegate)]) {
		
		//NSArray *identifiers = [delegate itemIdentifiers];
		int cnt = [delegate itemCount];
		int i;
		int xCoord = SCOPE_BAR_H_INSET;
		for (i=0;i<cnt;i++) {
		//for (NSString *itemID in identifiers) {
			NSDictionary *dict = [delegate itemAtIndex:i];
			if (dict) {
				BOOL enabled = [[dict valueForKey:SCOPE_DICT_ENABLED] boolValue];
				if (enabled) {
					NSNumber *tag = [dict valueForKey:SCOPE_DICT_TAG];
					NSString *title = [dict valueForKey:SCOPE_DICT_TITLE];
					NSButton *button = [self buttonForItem:tag withTitle:title];
					NSRect ctrlRect = [button frame];
					ctrlRect.origin.x = xCoord;
					[button setFrame:ctrlRect];
					[self addSubview:button];
					[buttons addObject:button];
			
					// Key-Loop setzen
					if (idx == 0) [scrollView setNextKeyView:button];
					if (idx > 0) [[buttons objectAtIndex:idx-1] setNextKeyView:button];
			
					xCoord += ctrlRect.size.width + SCOPE_BAR_ITEM_SPACING;
					if (totalWidth > 0) {
						totalWidth += SCOPE_BAR_ITEM_SPACING;
					} else {
						totalWidth += SCOPE_BAR_H_INSET;
					}
					totalWidth += ctrlRect.size.width;
					idx++;
				}
			}
		}
		totalWidth += SCOPE_BAR_H_INSET;
		
		// More-Button erzeugen (anfangs versteckt) und füllen
		float xpos = ([self bounds].size.width) - SCOPE_BAR_H_INSET;
		moreButton = [[self makeMoreButton] retain];
		[moreButton setHidden:YES];
		NSRect ctrlRect = [moreButton frame];
		ctrlRect.origin.x = xpos - ctrlRect.size.width;
		[moreButton setFrame:ctrlRect];
		[self addSubview:moreButton];
		
		// Menü-Einträge erzeugen
		[self createMenuEntries];
		
		//Key-Loop für More-Button setzen
		[[buttons objectAtIndex:[buttons count]-1] setNextKeyView:moreButton];
		[moreButton setNextKeyView:scrollView];
		// All-Item/Menü auf "on" setzen
		[self turnOnButtonAtIndex:0];
	}
	// Anzeige auf Fenstergröße anpassen
	[self adjustSubviews];
	
	// Fenster neu zeichnen
	[self setNeedsDisplay:YES];
}

// Wird über AppDelegate+UserDefaults von Preference Controller aufgerufen
-(void)reloadData
{
	BOOL foundAnything = NO;
	NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
	int i;
	for (i=0;i<[buttons count];i++) {
		if ([[buttons objectAtIndex:i] state] == NSOnState) {
			NSNumber *num = [NSNumber numberWithInt:[[buttons objectAtIndex:i] tag]];
			[tempArray addObject:num];
		}
	}
	[self loadData];
	for (i=0;i<[buttons count];i++) {
		[self turnOffButtonAtIndex:i];
		NSNumber *num = [NSNumber numberWithInt:[[buttons objectAtIndex:i] tag]];
		int j;
		for (j=0;j<[tempArray count];j++) {
			if ([num isEqualToNumber:[tempArray objectAtIndex:j]]) {
				[self turnOnButtonAtIndex:i];
				foundAnything = YES;
			}
		}
	}
	if (!foundAnything) {
		[self turnOnButtonAtIndex:0];
	}
}

// Wird über AppDelegate+UserDefaults von Preference Controller aufgerufen
-(void)checkIfPredicateChanged:(int)tag
{
	int i;
	for (i=0;i<[buttons count];i++) {
		if (([[buttons objectAtIndex:i] state] == NSOnState) && [[buttons objectAtIndex:i] tag] == tag) {
			[self informDelegateOfStateChange];
		}
	}
}


#pragma mark -
#pragma mark Utility Methods

// Menü-Einträge für Scope-Items erzeugen (funktioniert nur, wenn die Buttons schon erzeugt sind)
-(void) createMenuEntries
{
	int i;
	for (i=0;i<[buttons count];i++) {
		NSString *key = @"";
		if (i<9) key = [NSString stringWithFormat:@"%i", i+1];	// nur für die ersten 9 Einträge Shortcuts erzeugen
		NSButton *button = [buttons objectAtIndex:i];
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[button title]
													  action:@selector(menuClick:) 
											   keyEquivalent:key];
		if (i<10) [item setKeyEquivalentModifierMask:NSCommandKeyMask];
		[item setTag:[button tag]];
		[item setTarget:self];
		[filterMenu insertItem:item atIndex:i];
		[item release];
	}
	
}

// Gibt More-Button-Objekt zurück
-(NSPopUpButton *)makeMoreButton
{
	// Button erzeugen
	NSRect ctrlRect = NSMakeRect(0, 0, 50, 20); // arbitrary size
	NSPopUpButton *button = [[NSPopUpButton alloc] initWithFrame:ctrlRect pullsDown:YES];
	RROverflowPullDownCell *cell = [[RROverflowPullDownCell alloc] initTextCell:@"" pullsDown:YES];
	// Image für fokussierte Anzeige setzen
	NSString *focusImagePath = [[NSBundle mainBundle] pathForResource:@"RRscopebarmoreiconfocused" ofType:@"png"];
    NSImage *focusImage = [[NSImage alloc] initWithContentsOfFile:focusImagePath];
	[cell setFocusImage:focusImage];
    [focusImage release];
	[button setCell:cell];
	
	// Menü erzeugen
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu setAutoenablesItems:YES];
	
	// Erstes Item (mit Image) erzeugen
	NSMenuItem *pullDownMenuItem = [menu insertItemWithTitle:@""
													  action:nil
											   keyEquivalent:@""
													 atIndex:0];
	
	// Image für normale Anzeige setzen
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"RRscopebarmoreicon" ofType:@"png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	[pullDownMenuItem setImage:image];
    [image release];
	
	// Menüeinträge für alle Scope-Items erzeugen
	int i;
	for (i=0;i<[buttons count];i++) {
		NSButton *button = [buttons objectAtIndex:i];
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[button title]
													  action:@selector(overflowMenuClick:) 
											   keyEquivalent:@""];
		[item setTag:[button tag]];
		[item setHidden:YES];
		[item setTarget:self];
		[menu insertItem:item atIndex:i+1];
		[item release];
	}
	
	[[button cell] setMenu:menu];
	
	// Button formatieren
	[button setAutoresizingMask:NSViewMinXMargin]; // Button rechtsbündig ausrichten
	[button sizeToFit];
	ctrlRect = [button frame];
	ctrlRect.origin.y = floor(([self frame].size.height - ctrlRect.size.height) / 2.0)+1;
	[button setFrame:ctrlRect];	
    
	// Aufräumen
    [menu release];
	[cell release];
	return [button autorelease];	
}

// Gibt ein Scope-Item-Button-Objekt zurück
-(NSButton *)buttonForItem:(NSNumber*)tag withTitle:(NSString *)title
{
	NSRect ctrlRect = NSMakeRect(0, 0, 40, 20); // arbitrary size
	NSButton *button = [[NSButton alloc] initWithFrame:ctrlRect];
	[button setTitle:title];
	[button setTag:[tag integerValue]];
	[[button cell] setControlSize:NSSmallControlSize];
	[button setFont:[NSFont boldSystemFontOfSize:12.0]];
	[button setTarget:self];
	[button setAction:@selector(scopeButtonClicked:)];
	[button setBezelStyle:NSRecessedBezelStyle];
	[button setButtonType:NSOnOffButton];
	[[button cell] setHighlightsBy:NSCellIsBordered | NSCellIsInsetButton];
	[button setShowsBorderOnlyWhileMouseInside:YES];
	[button sizeToFit];
	ctrlRect = [button frame];
	ctrlRect.origin.y = floor(([self frame].size.height - ctrlRect.size.height) / 2.0);
	[button setFrame:ctrlRect];
	return [button autorelease];
}

// Größe der Scopebar hat sich verändert, ggf. Leiste anpassen
- (void)adjustSubviews
{
	// Prüfen, ob sich wirklich etwas geändert hat
	if ([buttons count] == 0) return;
	float viewWidth = [self bounds].size.width;
	if (viewWidth == lastWidth) return;
	// Prüfen, ob Scope Bar länger oder kürzer geworden ist
	float delta = lastWidth - viewWidth;
	if ((delta > 0) || (lastWidth == RRNotFound)) {
		
		// Scope Bar ist kürzer geworden
		if (viewWidth < (totalWidth+SCOPE_BAR_ITEM_SPACING)) { // Scope Bar ist zu eng geworden 
			float newWidth = totalWidth;
			if (!hasHiddenButtons) newWidth += SCOPE_BAR_MORE_BUTTON_WIDTH; // Muss ja hinzugezählt werden
			int idx = [buttons count];
			do {
				
				// Button verbergen und Menüitem anzeigen
				idx --;
				NSButton *button = [buttons objectAtIndex:idx];
				if (![button isHidden]) {
					[button setHidden:YES];
					NSMenuItem *menuItem = [[moreButton menu] itemAtIndex:idx+1];
					[menuItem setHidden:NO];

					NSRect buttonRect = [button frame];
					newWidth -= buttonRect.size.width;
					newWidth -= SCOPE_BAR_ITEM_SPACING;
				}
			} while (viewWidth < (newWidth+SCOPE_BAR_ITEM_SPACING));
					
			// Ggf. Popupbutton anzeigen
			if (!hasHiddenButtons) {
				[moreButton setHidden:NO];
				hasHiddenButtons = YES;
			}
			
			totalWidth = newWidth;
		}
	} else {
		
		// Scope Bar ist weiter geworden
		if (hasHiddenButtons) {
			int i;
			NSInteger idx=RRNotFound;
			float newWidth = totalWidth;
			for (i=0;i<[buttons count]; i++) {
				if (([[buttons objectAtIndex:i] isHidden]) && (idx==RRNotFound)) idx=i;
			}
			
			do {
				NSRect buttonRect = [[buttons objectAtIndex:idx] frame];
				float width = buttonRect.size.width;
				float compareWidth;
				if (idx == ([buttons count]-1)) { // Breite des Morebuttons rausrechnen
					compareWidth = newWidth+SCOPE_BAR_ITEM_SPACING+width-SCOPE_BAR_MORE_BUTTON_WIDTH;
				} else {
					compareWidth = newWidth+SCOPE_BAR_ITEM_SPACING+width;
				}
				if (viewWidth > compareWidth) { // Genug Platz für Button
					NSButton *button = [buttons objectAtIndex:idx];
					if ([button isHidden]) {
						[button setHidden:NO];
						NSMenuItem *menuItem = [[moreButton menu] itemAtIndex:idx+1];
						[menuItem setHidden:YES];
						
						NSRect buttonRect = [button frame];
						newWidth += buttonRect.size.width;
						newWidth += SCOPE_BAR_ITEM_SPACING;
					}
					idx++;
				} else {
					idx = [buttons count]+1;
				}
			} while (idx < [buttons count]);
			if (idx == [buttons count]) { // Alle Buttons wieder sichtbar, MoreButton verstecken
				hasHiddenButtons = NO;
				[moreButton setHidden:YES];
				newWidth -= SCOPE_BAR_MORE_BUTTON_WIDTH;
			}
			totalWidth = newWidth;
		}
					
	}
	lastWidth = viewWidth;
}

// Notification über Größenänderung der Scope Bar
- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
	[super resizeSubviewsWithOldSize:oldBoundsSize];
	[self adjustSubviews];
}

#pragma mark -
#pragma mark Interaction

// Wird von scopeButtonClick und menuClick aufgerufen und enthält die Logik für die Verarbeitung
-(void)processClick:(NSNumber*)tag clicked:(int)sender
{
	// Per Definition hat das erste Item eine Sonderstellung: Wird es geklickt, werden alle anderen Items entklickt
	// Wenn alle anderen Items entklickt werden, wird das erste Item geklickt
		
	// Rauskriegen, welches Item geklickt wurde
	int i;
	int tagInt = [tag intValue];
	NSInteger index = RRNotFound;
	for (i=0;i<[buttons count];i++) {
		if (tagInt == [[buttons objectAtIndex:i] tag]) {
			index = i;
		}
	}
	if (index != RRNotFound) {
		// Prüfen, ob "All"-Button geklickt wurde
		if (index == 0) {
			// Ja, alle anderen Scope Items und Menüeinträge auf "off" setzen
			int i;
			for (i=1; i<[buttons count]; i++) {
				[self turnOffButtonAtIndex:i];
			}
			// Und Item/Menüeintrag für "All" auf "on" setzen
			[self turnOnButtonAtIndex:0];
		} else {
			// Nein, "All"-Button/Menüeintrag auf Off setzen
			[self turnOffButtonAtIndex:0];
			
			// .. und geklicktes Item/Menü-Eintrag synchronisieren
			if (sender == SCOPE_BAR_OVERFLOW_MENU) {
				NSMenuItem *menuItem = [[moreButton menu] itemAtIndex:index+1];
				if ([menuItem state] == NSOffState) {
					[menuItem setState:NSOnState];
				} else {
					[menuItem setState:NSOffState];
				}
				[[buttons objectAtIndex:index] setState:[menuItem state]];
				[[filterMenu itemAtIndex:index] setState:[menuItem state]];
			}
			if (sender == SCOPE_BAR_MENU) {
				NSMenuItem *menuItem = [filterMenu itemAtIndex:index];
				if ([menuItem state] == NSOffState) {
					[menuItem setState:NSOnState];
				} else {
					[menuItem setState:NSOffState];
				}				
				[[buttons objectAtIndex:index] setState:[menuItem state]];	
				[[[moreButton menu] itemAtIndex:index+1] setState:[menuItem state]];
			}
			if (sender == SCOPE_BAR_BUTTON) {
				NSMenuItem *menuItem = [[moreButton menu] itemAtIndex:index+1];
				[menuItem setState:[[buttons objectAtIndex:index]state]];
				[[filterMenu itemAtIndex:index] setState:[[buttons objectAtIndex:index] state]];
			}
			
			// Rauskriegen, ob auch die Shift-Taste gedrückt wurde
			if (([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) == 0) {
				// Nein, alle außer dem geklickten Button auf Off setzen
				int i;
				for (i=0; i<[buttons count]; i++) {
					if (i!=index) {
						[self turnOffButtonAtIndex:i];
					} else {
						[self turnOnButtonAtIndex:i];
					}
				}
			}
		}
		// Prüfen, ob alle außer dem ersten Item entklickt sind
		BOOL check = YES;
		for (i=1;i<[buttons count];i++) {
			if ([[buttons objectAtIndex:i] state] == NSOnState) check = NO;
		}
		if (check) {
			[self turnOnButtonAtIndex:0];
		}
		
		// Delegate informieren
		[self informDelegateOfStateChange];
	}
}

-(void)informDelegateOfStateChange
{
	if (self.delegate && 
		[delegate conformsToProtocol:@protocol(RRScopeBarDelegate)] && 
		[delegate respondsToSelector:@selector(selectedStateChanged:)]) {
		NSMutableArray *scopeArray = [NSMutableArray arrayWithCapacity:0];
		int i;
		for (i=0;i<[buttons count];i++) {
			NSString *boolString;
			if ([[buttons objectAtIndex:i] state] == NSOnState) {
				boolString = @"YES";
			} else {
				boolString = @"NO";
			}
			NSNumber *scopeTag = [NSNumber numberWithInt:[[buttons objectAtIndex:i] tag]];
			NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
								   scopeTag, SCOPE_DICT_TAG,
								   boolString, SCOPE_DICT_ENABLED,
								   nil] autorelease];
			[scopeArray addObject:dict];
		}
		[delegate selectedStateChanged:scopeArray];
	}
}

// Ein Menu Item wurde angeklickt
-(IBAction)menuClick:(id)sender
{
	[self processClick:[NSNumber numberWithInt:[sender tag]] 
			   clicked:SCOPE_BAR_MENU];
}

// Ein Item im Overflow-Menü wurde angeklickt
-(IBAction)overflowMenuClick:(id)sender
{
	[self processClick:[NSNumber numberWithInt:[sender tag]] 
			   clicked:SCOPE_BAR_OVERFLOW_MENU];
}

// Ein Scope Item wurde geklickt
-(IBAction)scopeButtonClicked:(id)sender
{		
	[self processClick:[NSNumber numberWithInt:[sender tag]] 
			   clicked:SCOPE_BAR_BUTTON];
}

#pragma mark -
#pragma mark Drawing

// Scope Bar zeichnen (nur den Hintergrund)
- (void)drawRect:(NSRect)dirtyRect 
{
	NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedWhite:0.75 alpha:1.0]
														  endingColor: [NSColor colorWithCalibratedWhite:0.90 alpha:1.0]] autorelease];
	[gradient drawInRect:[self bounds] angle:90.0];
	
	// Draw border
	NSRect lineRect = [self bounds];
	lineRect.size.height = SCOPE_BAR_BORDER_WIDTH;
	[[NSColor colorWithCalibratedWhite:0.45 alpha:1.0] set];
	NSRectFill(lineRect);
}

@end
