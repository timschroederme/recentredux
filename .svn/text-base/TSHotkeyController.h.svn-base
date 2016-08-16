//
//  TSHotkeyController.h
//  
//
//  Created by Tim Schröder on 20.02.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@interface TSHotkeyController : NSObject {
	EventHandlerRef	hotKeysEventHandler;
	id target;
	SEL action;
}

+ (TSHotkeyController*)sharedHotKeyController;

- (void) registerHotKeyWithKeyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags target:(id)aTarget action:(SEL)anAction;
-(void) unregisterHotKey;

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData);

@property (nonatomic, retain) id target;
@property (nonatomic) SEL action;


@end
