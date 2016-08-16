//
//  RRAlert.m
//  Recent Redux
//
//  Created by Tim Schröder on 02.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAlert.h"


@implementation RRAlert

#pragma mark -
#pragma mark Error Alert Display Method

+(void)showError:(NSNumber*)errorCode
{
	NSString *title;
	NSString *notice;
	int iErrorCode = [errorCode intValue];
	if (iErrorCode == ERROR_CODE_ATTACHMENT) {
		title = ERROR_ATTACHMENT_TITLE;
		notice = ERROR_ATTACHMENT_NOTICE;
	}
	if (iErrorCode == ERROR_CODE_SCRIPT) {
		title = ERROR_SCRIPT_TITLE;
		notice = ERROR_SCRIPT_NOTICE;
	}
	if (iErrorCode == ERROR_CODE_CLIENT) {
		title = ERROR_CLIENT_TITLE;
		notice = ERROR_CLIENT_NOTICE;
	}
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:title];
	[alert setInformativeText:notice];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[[NSApp delegate] window] 
					  modalDelegate:self 
					 didEndSelector:nil 
						contextInfo:nil];
}

@end
