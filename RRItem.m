//
//  RRItem.m
//  Recent Redux
//
//  Created by Tim Schröder on 01.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRItem.h"


@implementation RRItem

@synthesize name, rawName, icon, rawDate, openDay, openTime, itemKind, metadataItem, itemType;

#pragma mark -
#pragma mark Overriden Methods

-(id)init
{
	self = [super init];
	if (self) {
		//init
	}
	return self;
}

-(void)dealloc
{
	[name release];
	[rawName release];
	[icon release];
	[rawDate release];
	[openDay release];
	[openTime release];
	[itemKind release];
	[itemType release];
	[metadataItem release];
	[super dealloc];
}

#pragma mark -
#pragma mark Methoden für View

// Das Array columnKeys wird von RRTableCell für die Darstellung benötigt, es sind nur diejenigen Properties
// drin, die auch angezeigt werden
+ (NSArray *)columnKeys
{
	static NSArray *columnKeys = nil;
	
	if( columnKeys == nil )
		columnKeys = [[NSArray alloc] initWithObjects:	ITEM_NAME,
														ITEM_RAWNAME,
														ITEM_ICON,
														ITEM_RAWDATE,
														ITEM_DAY,
														ITEM_TIME,
														ITEM_KIND,
					  nil];
					  
					  	
	return columnKeys;
}

- (NSDictionary *)columnInfo
{
    return [self dictionaryWithValuesForKeys:[[self class] columnKeys]];
}

#pragma mark -
#pragma mark Controller Methods

// Gibt zurück, ob Item Application ist oder nicht
-(BOOL)isItemApplication
{
	BOOL result = NO;
	NSArray *array = [NSArray arrayWithArray:[self valueForKey:ITEM_TYPE]];
	int i;
	for (i=0;i<[array count];i++) {
		if ([[array objectAtIndex:i] isEqualToString:@"com.apple.bundle"]) result = YES;
	}
	return result;
}

// Gibt zurück, ob Item Folder ist
-(BOOL)isItemFolder
{
	BOOL result = NO;
	NSArray *array = [NSArray arrayWithArray:[self valueForKey:ITEM_TYPE]];
	int i;
	for (i=0;i<[array count];i++) {
		if ([[array objectAtIndex:i] isEqualToString:@"public.folder"]) result = YES;
	}
	return result;
}


@end
