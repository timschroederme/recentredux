//
//  RRAppDelegate+Multithreading.h
//  Recent Redux
//
//  Created by Tim Schröder on 28.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RRAppDelegate.h"

@interface RRAppDelegate (Multithreading)

- (void) startNewThread:(NSString*)context withSelector:(SEL)selector withObject:(id)object;
- (void) cancelThreadWithSelector:(SEL)selector;
- (BOOL) isThreadCancelled:(SEL)selector;

@end
