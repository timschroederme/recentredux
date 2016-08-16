//
//  RREmailController.h
//  Recent Redux
//
//  Created by Tim Schröder on 05.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RREmailController : NSObject {

}

+ (RREmailController *)sharedEmailController;

- (NSURL*)URLForTitle:(NSString*)title;
- (NSString*)bundleIdentifier:(NSURL*)url;
- (BOOL)hasValidEmailClient;
- (NSDictionary*)preferredEmailClient;
- (NSDictionary*)getClientInfo:(NSURL*)url;
- (BOOL)isValidMailClient:(NSURL*)url;
- (NSArray*)availableEmailClients;
- (NSMenu*)emailClientMenu;

@end
