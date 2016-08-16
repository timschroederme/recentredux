//
//  TSHotkeyController.m
//  
//
//  Created by Tim Schröder on 20.02.11.
//  Copyright 2011 Tim Schröder. All rights reserved.
//

#import "TSHotkeyController.h"
#import <Carbon/Carbon.h>

@implementation TSHotkeyController

static TSHotkeyController *_sharedHotkeyController = nil;

@synthesize target, action;


#pragma mark -
#pragma mark Singleton Methods

+ (TSHotkeyController*)sharedHotKeyController
{
    if (_sharedHotkeyController == nil) {
        _sharedHotkeyController = [[super allocWithZone:NULL] init];
    }
    return _sharedHotkeyController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedHotKeyController] retain];
}

-(id)init 
{
	if (self = [super init]) {
		hotKeysEventHandler = NULL;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}


#pragma mark -
#pragma mark Hotkey Configuration Methods

- (void) registerHotKeyWithKeyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags target:(id)aTarget action:(SEL)AnAction 
{
	[self unregisterHotKey];
	if (hotKeysEventHandler == NULL) {
		EventHotKeyRef gMyHotKeyRef;
		EventHotKeyID gMyHotKeyID;
		EventTypeSpec eventType;
		eventType.eventClass = kEventClassKeyboard;
		eventType.eventKind = kEventHotKeyPressed;
		InstallApplicationEventHandler (&hotKeyHandler,1,&eventType,NULL,&hotKeysEventHandler);
		gMyHotKeyID.signature='htk1';
		gMyHotKeyID.id=1;
		RegisterEventHotKey(keyCode, flags, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
		
		target = aTarget;
		action = AnAction;
	}
}


-(void)unregisterHotKey
{
	if (hotKeysEventHandler != NULL) {
		RemoveEventHandler(hotKeysEventHandler);
		hotKeysEventHandler = NULL;
	}
}


#pragma mark -
#pragma mark Invoke Hotkey

// Wird aufgerufen, wenn Hotkey gedrückt wird, und bringt Hauptfenster in den Vordergrund
OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData)
{
	TSHotkeyController *sharedHotKeyController = [TSHotkeyController sharedHotKeyController];
	if ([sharedHotKeyController target] != nil && [sharedHotKeyController action] != nil && [[sharedHotKeyController target] respondsToSelector:[sharedHotKeyController action]]) {
		[[sharedHotKeyController target] performSelector:[sharedHotKeyController action]];
	}
	return noErr;
}

@end
