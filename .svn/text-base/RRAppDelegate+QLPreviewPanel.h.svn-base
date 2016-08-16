//
//  RRAppDelegate+QLPreviewPanel.h
//  Recent Redux
//
//  Created by Tim Schröder on 11.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RRAppDelegate.h"


@interface RRAppDelegate (QLPreviewPanel) <QLPreviewPanelDataSource, QLPreviewPanelDelegate>

-(BOOL) previewPanelIsVisible;
-(void)updatePreviewPanel;

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel;
- (void)endPreviewPanelControl:(QLPreviewPanel *)panel;

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel;
- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index;

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event;
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item;
- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect;


@end
