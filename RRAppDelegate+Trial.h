//
//  AppDelegate+Trial.h
//
//  Created by Tim Schröder on 04.04.11.
//

#import "RRAppDelegate.h"

@interface RRAppDelegate (Trial)

-(BOOL)checkIfAppStoreVersionIsInstalled;
-(BOOL)checkIfExpired;
-(int)remainingTrialPeriod;
-(void)showExpiredMessage;
-(void)showRemainingTrialMessage;
-(void)openAppStore;

@end
