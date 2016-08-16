//
//  RRAppDelegate+UserDefaults.h
//  Recent Redux
//
//  Created by Tim Schröder on 18.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RRAppDelegate.h"

@interface RRAppDelegate (UserDefaults)

+ (void)initialize;
- (void)setInitialWindowMode;
- (void)setWindowMode:(BOOL)flag;

-(void)setDefaultClient:(NSString*)title;
-(NSString*)defaultClient;

-(BOOL)largeSearchScope;
-(NSString*)searchInterval;
-(NSString*)searchLocation;

-(BOOL)hotkeyEnabled;
-(void)updateHotkey;

-(void)reloadScopeBar;
-(void)reloadMainWindow:(int)tag;

@end
