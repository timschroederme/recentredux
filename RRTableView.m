//
//  RRTableView.m
//  Recent Redux
//
//  Created by Tim Schröder on 07.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRTableView.h"
#import "RRAppDelegate.h"
#import "RRAppDelegate+Actions.h"
#import "RRAppDelegate+QLPreviewPanel.h"


@implementation RRTableView

-(void)awakeFromNib 
{
	// Doppelclick-Methode registrieren
	[self setDoubleAction:@selector(doubleClick:)];
	
//	[self  registerForDraggedTypes: [NSArray arrayWithObject:MyPrivateTableViewDataType] ];];
}

// Leitet Doppelclick in RRAppDelegate+Actions um
-(IBAction)doubleClick:(id)sender
{
	if ([self activeRow] != RRNotFound) [[NSApp delegate] tableDoubleClick];
}

// Fängt <SPACE>-Taste sowie Cursor-Tasten ab, um Quick Look auszulösen
- (void)keyDown:(NSEvent *)theEvent
{
	// SPACE-Taste: Preview togglen
	if (([theEvent keyCode] == KEY_SPACE) && ([self selectedRow] != RRNotFound)) {
		[[NSApp delegate] togglePreviewPanel:self];
		return;
	}
	// Cursor-Taste: Ggf. Preview updaten

	if (([theEvent keyCode] == KEY_CURSOR_DOWN) || ([theEvent keyCode] == KEY_CURSOR_UP)) {
		[[NSApp delegate] updatePreviewPanel];
	}
	[super keyDown:theEvent];
}
/*
- (void)mouseDown:(NSEvent *)theEvent

{
	
    NSImage *dragImage;
	
    NSPoint dragPosition;
	
	
	
    // Write data to the pasteboard
	
	NSString *filePath1 =  @"/Users/Tim/Desktop/Uni/Ministerbrief - ACRP3 - Food Security - Food Security risks for Austria caused by climate change - K10AC1K00044 (Pr.Nr._ B068650).pdf";
	
    NSArray *fileList = [NSArray arrayWithObjects:filePath1, nil];
	
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	
    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType]
	 
				   owner:nil];
	
    [pboard setPropertyList:fileList forType:NSFilenamesPboardType];
	
	
	
    // Start the drag operation
	
    dragImage = [[NSWorkspace sharedWorkspace] iconForFile:filePath1];
	
    dragPosition = [self convertPoint:[theEvent locationInWindow]
					
							 fromView:nil];
	
    dragPosition.x -= 16;
	
    dragPosition.y -= 16;
	
    [self dragImage:dragImage
	 
				 at:dragPosition
	 
			 offset:NSZeroSize
	 
			  event:theEvent
	 
		 pasteboard:pboard
	 
			 source:self
	 
		  slideBack:YES];
	
}
*/
// Gibt aktive Zeile zurück (Convenience Method)
-(NSInteger)activeRow
{
	NSInteger result = RRNotFound;
	if ([self clickedRow] != RRNotFound) {
		result = [self clickedRow];
	} else {
		result = [self selectedRow];
	}
	return result;		
}

@end
