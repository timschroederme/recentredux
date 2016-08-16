//
//  RRScopeBarDelegateProtocol.h
//  Recent Redux
//
//  Created by Tim Schröder on 10.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol RRScopeBarDelegate


// Methods used to configure the scope bar

@required

-(NSDictionary *)itemAtIndex:(int)index;
-(int)itemCount;


// Notification method: Benutzer hat Scope Item geklickt

@optional
- (void) selectedStateChanged:(NSArray*)scopeArray;


@end
