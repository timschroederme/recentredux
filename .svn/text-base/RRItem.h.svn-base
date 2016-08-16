//
//  RRItem.h
//  Recent Redux
//
//  Created by Tim Schröder on 01.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RRItem : NSObject {
	NSString *name;
	NSString *rawName;
	NSImage *icon;
	NSDate *rawDate;
	NSString *openDay;
	NSString *openTime;
	NSString *itemKind;
	NSArray *itemType;
	NSMetadataItem *metadataItem;
}

-(BOOL)isItemApplication;
-(BOOL)isItemFolder;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rawName;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSDate *rawDate;
@property (nonatomic, copy) NSString *openDay;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *itemKind;
@property (nonatomic, retain) NSArray *itemType;
@property (nonatomic, retain) NSMetadataItem *metadataItem;

@property (nonatomic, readonly) NSDictionary *columnInfo;

@end
