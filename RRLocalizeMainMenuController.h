//
//  RRLocalizeMainMenuController.h
//  Recent Redux
//
//  Created by Tim Schröder on 22.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RRLocalizeMainMenuController : NSObject {
	IBOutlet NSMenuItem *about;
	IBOutlet NSMenuItem *preferences;
	IBOutlet NSMenuItem *services;
	IBOutlet NSMenuItem *hide;
	IBOutlet NSMenuItem *hideOthers;
	IBOutlet NSMenuItem *showAll;
	IBOutlet NSMenuItem *quit;
	
	IBOutlet NSMenu *file;
	IBOutlet NSMenuItem	*quickLook;
	IBOutlet NSMenuItem *open;
	IBOutlet NSMenuItem *openWith;
	IBOutlet NSMenuItem *showInFinder;
	IBOutlet NSMenuItem *share;
	IBOutlet NSMenuItem *email;
	
	IBOutlet NSMenu *edit;
	IBOutlet NSMenuItem *undo;
	IBOutlet NSMenuItem *redo;
	IBOutlet NSMenuItem *cut;
	IBOutlet NSMenuItem *copy;
	IBOutlet NSMenuItem *copyPath;
	IBOutlet NSMenuItem *paste;
	IBOutlet NSMenuItem *delete;
	IBOutlet NSMenuItem *selectAll;
	IBOutlet NSMenuItem *find;
	IBOutlet NSMenuItem *findSomething;
	IBOutlet NSMenuItem *findNext;
	IBOutlet NSMenuItem *findPrevious;
	IBOutlet NSMenuItem *findUseSelection;
	IBOutlet NSMenuItem *findJumpToSelection;
	
	IBOutlet NSMenu *filter;
	IBOutlet NSMenuItem *editFilters;
	
	IBOutlet NSMenu *window;
	IBOutlet NSMenuItem *alwaysFront;
	IBOutlet NSMenuItem *minimize;
	IBOutlet NSMenuItem *zoom;
	IBOutlet NSMenuItem *close;
	IBOutlet NSMenuItem *bringAllToFront;
	
	IBOutlet NSMenu *helpCaption;
	IBOutlet NSMenuItem *help;
	
	IBOutlet NSMenuItem *contextOpen;
	IBOutlet NSMenuItem *contextOpenWith;
	IBOutlet NSMenuItem *contextShowInFinder;
	IBOutlet NSMenuItem *contextCopyPath;
	IBOutlet NSMenuItem *contextShare;
	IBOutlet NSMenuItem *contextEmail;
}

@end
