//
//  RRAppDelegate.h
//  Recent Redux
//
//  Created by Tim Schröder on 28.10.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <Carbon/Carbon.h>
#import "RRScopeBar.h"

@class RRTableView, RRItem, RRStatusBar, RRWindow, RRHUDScopeBar;

@interface RRAppDelegate : NSObject <NSApplicationDelegate, RRScopeBarDelegate, NSMetadataQueryDelegate> {
	NSWindow *window;
	NSMetadataQuery *query;
	NSString *searchKey;
	NSTimeInterval searchTimeInterval;
	NSOperationQueue *operationQueue;
	IBOutlet NSPredicate *arrayPredicate;
	IBOutlet RRTableView *table;
	IBOutlet NSTableColumn *tableColumn;
	IBOutlet NSMutableArray *items;
	IBOutlet NSArrayController *itemController;	
	IBOutlet NSArrayController *filterController;
	IBOutlet NSTextFieldCell *textFieldCell;
	IBOutlet RRScopeBar *scopeBar;
	IBOutlet NSMenu *mainMenu;			
	IBOutlet NSMenu *contextMenu; 
	IBOutlet NSMenuItem *toggleAlwaysInFrontMenuItem; // Wird bei Programmstart benötigt 
	QLPreviewPanel* previewPanel;
	IBOutlet NSPanel *sendMailSheet;
	IBOutlet NSWindow *selectMailClientWindow;
	IBOutlet NSPopUpButton *selectMailPopUpButton;
	IBOutlet RRStatusBar *statusBar;
	NSMenu *dockMenu;
	NSSortDescriptor *arraySortDescriptors;
    IBOutlet NSMenu *helpMenu;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSSortDescriptor *arraySortDescriptors;

@end
