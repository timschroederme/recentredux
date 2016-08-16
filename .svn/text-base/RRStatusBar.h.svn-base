//
//  RRStatusBar.h
//  Recent Redux
//
//  Created by Tim Schröder on 02.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RRStatusBar : NSView {
	NSTextField *countLabel;
	NSTextField *messageLabel;
	NSProgressIndicator *waitProgressIndicator;
	NSArrayController *filterController;
}

-(void)setCountBinding:(NSArrayController*)arrayController;

-(void)setMessage:(NSString*)caption;
-(void)startAnimation;
-(void)startDeterminateAnimation:(int)maxValue;
-(void)setAnimationValue:(int)value;
-(void)stopAnimation;

-(void)showCountLabel;
-(void)showMessageLabel:(NSString*)message;

@end
