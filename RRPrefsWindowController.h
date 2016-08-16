//
//  RRPrefsWindowController.h
//  Recent Redux
//
//  Created by Tim Schröder on 31.10.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface RRPrefsWindowController : NSWindowController <NSAnimationDelegate, NSToolbarDelegate, NSWindowDelegate> {
	NSMutableArray *toolbarIdentifiers;
	NSMutableDictionary *toolbarViews;
	NSMutableDictionary *toolbarItems;
	
	IBOutlet NSView *generalPrefsView;
	IBOutlet NSView *sharePrefsView;
	IBOutlet NSView *advancedPrefsView;
	IBOutlet NSView *queryPrefsView;
	IBOutlet NSPopUpButton *selectMailPopUpButton;
	IBOutlet NSArrayController *queryArrayController;
	IBOutlet NSPanel *editQueryPanel;
	IBOutlet NSPredicateEditor *predicateEditor;
	IBOutlet NSTableView *queryTable;
	IBOutlet NSButton *predicateEditorOKButton;

	NSView *contentSubview;
	NSViewAnimation *viewAnimation;
	NSInteger windowLevel;
}

+ (RRPrefsWindowController *)sharedPrefsWindowController;

- (void)updateWindowMode;

- (void)setupToolbar;
- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image;

- (IBAction) showWindow:(id)sender openFilterPane:(BOOL)openFilterPaneFlag;
- (IBAction) addQuery:(id)sender;
- (IBAction) removeQuery:(id)sender;
- (IBAction) editQuery:(id)sender;
- (IBAction) endSheet:(id)sender;
- (void) sheetDidEnd: (NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;


- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate;
- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView;
- (NSRect)frameForView:(NSView *)view;


@end
