//
//  NSString+RRAdditions.h
//  Recent Redux
//
//  Created by Tim Schröder on 28.12.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (RRAdditions)

+(NSString*)stringWithFileSize:(long long) fileSize;
-(NSString*)truncateString;
-(float)calculateStringWidth:(NSControl*)control;

@end
