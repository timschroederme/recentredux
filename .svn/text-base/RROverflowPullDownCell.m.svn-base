//
//  RROverflowPullDownCell.m
//  Recent Redux
//
//  Created by Tim Schröder on 13.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RROverflowPullDownCell.h"


@implementation RROverflowPullDownCell

@synthesize focusImage;

-(id)initTextCell:(NSString *)stringValue pullsDown:(BOOL)pullDown {
    if (!(self = [super initTextCell:stringValue pullsDown:YES]))
        return nil;
    
	[self setButtonType:NSMomentaryChangeButton];
    [self setArrowPosition:NSPopUpNoArrow];
    [self setControlSize:NSSmallControlSize];
    [self setImagePosition:NSNoImage];
    [self setBordered:NO];
    //[self setHighlightsBy:NSNoCellMask]; // Die Einstellungen werden von der drawWithFrame-Methode ohnehin ignoriert
	//[self setShowsStateBy:NSNoCellMask];	
    //[self setAutoenablesItems:NO];
    //[self setAltersStateOfSelectedItem:NO];
    [self setUsesItemFromMenu:YES];
	return self;
}

-(void)dealloc
{
	[focusImage release];
	[super dealloc];
}

// Gibt Größe der Zelle zurück, von Bedeutung für das Zeichnen des Overflow-Buttons
-(NSSize)cellSize {
    NSMenu *cellMenu = [self menu];
    if (!cellMenu || ([cellMenu numberOfItems] == 0))
        return NSZeroSize;
    
    // Cell size of the overflow button is based on the image
    NSMenuItem *firstItem = [cellMenu itemAtIndex:0];
    if (![firstItem image])
        return NSZeroSize;
    
    return [[firstItem image] size];
}

// Zeichnet das "More"-Symbol, ignoriert so gut wie alle Formatierungen...
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	BOOL focus = controlView == [[controlView window] firstResponder];
	NSImage *image;
	if (([self isHighlighted]) || focus) {
		image = [self focusImage];
	} else {
		image = [self image];
	}
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	
	[image drawInRect:cellFrame
			 fromRect:NSZeroRect
			operation:NSCompositeSourceOver 
			 fraction:1.0];
	
	[[NSGraphicsContext currentContext] setImageInterpolation:interpolation];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end
