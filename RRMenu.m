//
//  RRMenu.m
//  Recent Redux
//
//  Created by Tim Schröder on 21.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRMenu.h"


@implementation RRMenu


// Interne Hilfsroutine zum Durchsuchen von Menüs
-(NSMenuItem *)scanMenu:(NSMenu*)menu forTag:(NSInteger)aTag
{
	int i;
	NSMenuItem *result=nil;
	NSArray *array = [menu itemArray];
	for (i=0;i<[array count];i++) {
		NSMenuItem *tempItem = nil;
		tempItem = [array objectAtIndex:i];
		if ([tempItem tag] == aTag) {
			result = tempItem;
		} else {
			if ([tempItem submenu] != nil) {
				NSMenuItem *subResult=nil;
				subResult = [self scanMenu:[tempItem submenu]
								 forTag:aTag];
				if (subResult != nil) result = subResult;
			}
		}
	}
	return result;
}

// Durchsucht Hauptmenü und Submenüs nach Menüeinträgen mit dem Tag "aTag" (overriden)
- (NSMenuItem *)itemWithTag:(NSInteger)aTag
{
	NSMenuItem *result = nil;
	result = [self scanMenu:self forTag:aTag];
	return result;
}

@end
