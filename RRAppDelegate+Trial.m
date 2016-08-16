//
//  AppDelegate+Trial.m
//
//  Created by Tim Schröder on 04.04.11.
//

#import "RRAppDelegate+Trial.h"
#import "TrialConstants.h"

@implementation RRAppDelegate (Trial)

// Check if paid application version is present on system
-(BOOL)checkIfAppStoreVersionIsInstalled
{
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSString *pathToAppStoreVersion = [workspace absolutePathForAppBundleWithIdentifier:APPSTORE_IDENTIFIER];
    if (pathToAppStoreVersion) {
        NSString *message = [NSString stringWithFormat:APPSTORE_EXIST_MESSAGE, APPSTORE_NAME, [pathToAppStoreVersion stringByDeletingLastPathComponent]];
        NSInteger result = [[NSAlert alertWithMessageText:APPSTORE_DIALOG_CAPTION defaultButton:APPSTORE_QUIT_BUTTON alternateButton:APPSTORE_IGNORE_BUTTON otherButton:nil informativeTextWithFormat:message] runModal];
		if (result == NSAlertDefaultReturn) {
			[workspace selectFile:[[NSBundle mainBundle] bundlePath] inFileViewerRootedAtPath:nil];
			exit(0);
		}
        return YES;
    } else {
        return NO;
    }
}

// Registriert Trial-Daten in UserDefaults
-(void)registerTrialData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval registerInterval = [[NSDate date] timeIntervalSince1970];
    [defaults setInteger:(int)(registerInterval/TRIAL_FACTOR) forKey:DEFAULTS_TRIALINTERVAL];
    
    NSString *temp = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSInteger bundleVersion = [temp integerValue];
    [defaults setInteger:bundleVersion forKey:DEFAULTS_VERSION];
    [defaults synchronize];
}

// Check if trial period has expired or not
-(BOOL)checkIfExpired
{
    BOOL expired = NO;
    
    // Versionskontrolle (Trial fängt bei neuer Version neu an zu laufen)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultsVersion = [defaults integerForKey:DEFAULTS_VERSION];
    NSString *temp = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSInteger bundleVersion = [temp integerValue];
    
    if (bundleVersion > defaultsVersion) {
        // Trial zurücksetzen
        [self registerTrialData];
    } else {
        if ([self remainingTrialPeriod] == 0) expired = YES;
    }
    
    return expired;
}

// Calculate remaining trial period
-(int)remainingTrialPeriod
{
    int daysRemaining;
 	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSTimeInterval defaultsInterval = (double)[defaults integerForKey:DEFAULTS_TRIALINTERVAL]*TRIAL_FACTOR;
    if (defaultsInterval!=0) {
        // trial key already present in preferences, calculate remaining trial period
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        double diff = nowInterval - defaultsInterval;
        double rest = (60*60*24*TRIAL_PERIOD)-diff;
        if (diff > (60*60*24*TRIAL_PERIOD)) {
            daysRemaining = 0;
        } else {
            daysRemaining = (int)(rest/(60*60*24));
            daysRemaining++;
        }
    } else {
        // trial key not present in preferences, register it with present date
        [self registerTrialData];
        daysRemaining = 28;
    }
    return daysRemaining;
}

// Show message window that trial period has expired, then quit the application
-(void)showExpiredMessage
{
    NSString *message = [NSString stringWithFormat:TRIAL_EXPIRED_MESSAGE, APPSTORE_NAME];
    NSString *caption = [NSString stringWithFormat:TRIAL_EXPIRED_CAPTION, APPSTORE_NAME];
    NSString *launch = [NSString stringWithFormat:TRIAL_LAUNCH_BUTTON, APPSTORE_NAME];
    NSInteger result = [[NSAlert alertWithMessageText:caption 
                                        defaultButton:TRIAL_CLOSE_BUTTON 
                                      alternateButton:launch 
                                          otherButton:nil 
                            informativeTextWithFormat:message] runModal];
    if (result == NSAlertAlternateReturn) [self openAppStore];
    
    exit(0);
}    

// Show message window with info on remaining trial period
-(void)showRemainingTrialMessage
{
    NSString *message = [NSString stringWithFormat:TRIAL_MESSAGE, APPSTORE_NAME, [self remainingTrialPeriod]];
    NSString *caption = [NSString stringWithFormat:TRIAL_DIALOG_CAPTION, APPSTORE_NAME];
    NSString *launch = [NSString stringWithFormat:TRIAL_LAUNCH_BUTTON, APPSTORE_NAME];
    NSInteger result = [[NSAlert alertWithMessageText:caption 
                                        defaultButton:TRIAL_OK_BUTTON 
                                      alternateButton:launch 
                                          otherButton:nil 
                            informativeTextWithFormat:message] runModal];
    if (result == NSAlertAlternateReturn) [self openAppStore];
}

// Launch Mac App Store to show application
-(void)openAppStore
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:APPSTORE_URL]];
}

@end
