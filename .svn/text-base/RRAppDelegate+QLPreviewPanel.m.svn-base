//
//  RRAppDelegate+QLPreviewPanel.m
//  Recent Redux
//
//  Created by Tim Schröder on 11.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+QLPreviewPanel.h"
#import "RRItem.h"
#import "RRTableView.h"


@implementation RRAppDelegate (QLPreviewPanel)

#pragma mark -
#pragma mark Custom Methods

// Hilfsfunktion, die sagt, ob Panel sichtbar ist, wird u.a. von RRAppDelegate+Actions aufgerufen
-(BOOL) previewPanelIsVisible
{
	if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) return YES;
	return NO;
}

// Wird von RRTableView aufgerufen, wenn Cursor nach oben/unten bewegt wird
-(void)updatePreviewPanel
{
	if (![self previewPanelIsVisible]) return;
	[[QLPreviewPanel sharedPreviewPanel] reloadData];
}

#pragma mark -
#pragma mark QLPreviewPanelController 

// QLPreviewPanelController ist ein informelles Protokoll

// Quick Look panel support

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    previewPanel = [panel retain];
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
	[previewPanel setLevel:NSFloatingWindowLevel]; // für alle Fälle zurücksetzen
	[previewPanel release];
    previewPanel = nil;
}

#pragma mark -
#pragma mark PreviewPanel Data Source Delegate

// Es wird immer nur ein Item im PreviewPanel angezeigt
- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return 1;
}

// Objekt des anzuzeigenden Items zurückgeben
- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{	
	NSInteger idx = [table activeRow];
	if (idx != RRNotFound) return [[filterController arrangedObjects] objectAtIndex:idx];
	return nil;
}

#pragma mark -
#pragma mark PreviewPanel Delegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
    // redirect all key down events to the table view
    if ([event type] == NSKeyDown) {
        [table keyDown:event];
        return YES;
    }
    return NO;
}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item
{
	if ([window level] > [panel level]) [panel setLevel:[window level]+1]; // Damit PreviewPanel auch im Vordergrund bleibt, wenn Hauptfenster AlwaysInFront ist

	NSInteger index = [table activeRow];
    if (index == RRNotFound) return NSZeroRect;
	
    NSRect iconRect = [table frameOfCellAtColumn:0 row:index];

    // check that the icon rect is visible on screen
    NSRect visibleRect = [table visibleRect];
    
    if (!NSIntersectsRect(visibleRect, iconRect)) return NSZeroRect;
    
    // convert icon rect to screen coordinates
    iconRect = [table convertRectToBase:iconRect];
    iconRect.origin = [[table window] convertBaseToScreen:iconRect.origin];
	iconRect.size.width = iconRect.size.height; // Damit Icon-Zoom funktioniert
	
    return iconRect;
}

// This delegate method provides a transition image between the table view and the preview panel

- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect
{
    RRItem* previewItem = (RRItem *)item;
	NSImage* image = [previewItem valueForKey:ITEM_ICON];
	[image setSize:NSMakeSize(36, 36)];
	return image;
}

@end
