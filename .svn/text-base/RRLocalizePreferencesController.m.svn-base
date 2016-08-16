//
//  RRLocalizePreferencesController.m
//  Recent Redux
//
//  Created by Tim Schröder on 22.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRLocalizePreferencesController.h"
#import "NSString+RRAdditions.h"


@implementation RRLocalizePreferencesController

-(void)awakeFromNib
{
	[hotkey setStringValue:PREFWINDOW_HOTKEY];
	[hotkeyCheck setTitle:PREFWINDOW_HOTKEYCHECK];
	[sendEmailWith setStringValue:PREFWINDOW_SENDEMAILWITH];

	[searchTime setStringValue:PREFWINDOW_SEARCHTIME];
	
	NSString *prefix = PREFWINDOW_SEARCHTIMEPREFIX;
	[searchTimePrefix setStringValue:prefix];
	float prefixWidth =  [prefix calculateStringWidth:(NSControl*)searchTimePrefix];
	NSRect inputRect = [searchTimeInput frame];
	NSRect prefixRect = [searchTimePrefix frame];
	prefixRect.size.width = prefixWidth + 5;
	[searchTimePrefix setFrame:prefixRect];
	inputRect.origin.x = prefixRect.origin.x + prefixWidth + 10;
	[searchTimeInput setFrame:inputRect];
	NSRect suffixRect = [searchTimeSuffix frame];
	suffixRect.origin.x = inputRect.origin.x + inputRect.size.width + 5;
	[searchTimeSuffix setFrame:suffixRect];
	// Position von searchTimeInput festlegen, je nach Stringlänge
	// Position von searchTimeSuffix festlegen, je nach Stringlänge
	[searchTimeSuffix setStringValue:PREFWINDOW_SEARCHTIMESUFFIX];

	[searchScope setStringValue:PREFWINDOW_SEARCHSCOPE];
	[searchScopeSmall setTitle:PREFWINDOW_SEARCHSCOPESMALL];
	[searchScopeBig setTitle:PREFWINDOW_SEARCHSCOPEBIG];

	[searchLocation setStringValue:PREFWINDOW_SEARCHLOCATION];
	[searchLocationSmall setTitle:PREFWINDOW_SEARCHLOCATIONSMALL];
	[searchLocationBig setTitle:PREFWINDOW_SEARCHLOCATIONBIG];
		
	[queryTitle setStringValue:PREFWINDOW_QUERYTITLE];
	[queryDescription setStringValue:PREFWINDOW_QUERYDESCRIPTION];
	[queryEnabledCheckBox setTitle:PREFWINDOW_QUERYENABLEDCHECKBOX];
	
	NSString *title = PREFWINDOW_EDITQUERYBUTTON;
	[editQueryButton setTitle:PREFWINDOW_EDITQUERYBUTTON];
	float titleWidth = [title calculateStringWidth:(NSControl*)editQueryButton];
	titleWidth = titleWidth+41;
	if (titleWidth < 96) titleWidth = 96;
	NSRect queryTitleRect = [editQueryButton frame];
	float diff = queryTitleRect.size.width-titleWidth;
	queryTitleRect.origin.x = queryTitleRect.origin.x+diff;
	queryTitleRect.size.width = titleWidth;
	[editQueryButton setFrame:queryTitleRect];
	
	title = PREFWINDOW_EDITOROKBUTTON;
	[editorOKButton setTitle:PREFWINDOW_EDITOROKBUTTON];
	titleWidth = [title calculateStringWidth:(NSControl*)editQueryButton];
	titleWidth = titleWidth+41;
	if (titleWidth < 96) titleWidth = 96;
	queryTitleRect = [editorOKButton frame];
	diff = queryTitleRect.size.width-titleWidth;
	queryTitleRect.origin.x = queryTitleRect.origin.x+diff;
	queryTitleRect.size.width = titleWidth;
	[editorOKButton setFrame:queryTitleRect];
	NSRect saveRect = queryTitleRect;
	
	title = PREFWINDOW_EDITORCANCELBUTTON;
	[editorCancelButton setTitle:PREFWINDOW_EDITORCANCELBUTTON];
	titleWidth = [title calculateStringWidth:(NSControl*)editQueryButton];
	titleWidth = titleWidth+41;
	if (titleWidth < 96) titleWidth = 96;
	queryTitleRect = [editorCancelButton frame];
	diff = queryTitleRect.size.width-titleWidth;
	queryTitleRect.origin.x = saveRect.origin.x-titleWidth;
	queryTitleRect.size.width = titleWidth;
	[editorCancelButton setFrame:queryTitleRect];
}

@end
