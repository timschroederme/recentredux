//
//  RRAppDelegate+Email.h
//  Recent Redux
//
//  Created by Tim Schröder on 24.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RRAppDelegate.h"

@interface RRAppDelegate (Email)

-(IBAction)selectMailClientWindowOK:(id)sender;
-(IBAction)selectMailClientWindowCancel:(id)sender;
-(void)selectEmailClientAndSendMail:(NSMetadataItem*)item;

-(void)prepareEmail:(NSMetadataItem*)item;
-(void)sendMail:(NSMetadataItem*)item;


@end
