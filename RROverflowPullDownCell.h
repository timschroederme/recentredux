//
//  RROverflowPullDownCell.h
//  Recent Redux
//
//  Created by Tim Schröder on 13.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RROverflowPullDownCell : NSPopUpButtonCell {

	NSImage *focusImage;
}

@property (nonatomic, retain) NSImage *focusImage;

@end
