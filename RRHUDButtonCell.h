//
//  RRHUDButtonCell.h
//  Recent Redux
//
//  Created by Tim Schröder on 12.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RRHUDButtonCell : NSButtonCell {

	NSImage *buttonLeftN;
	NSImage *buttonFillN;
	NSImage *buttonRightN;
	NSImage *buttonLeftP;
	NSImage *buttonFillP;
	NSImage *buttonRightP;
	NSColor *enabledColor;
	NSColor *disabledColor;
}

@end
