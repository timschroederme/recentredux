//
//  NSFileManager+RRAdditions.h
//  Recent Redux
//
//  Created by Tim Schröder on 28.12.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSFileManager (RRAdditions)

-(unsigned long long) fastFolderSizeAtPath:(NSString*)path isApp:(BOOL)anApp;
-(NSArray *) openWithMenuForFile:(NSString*)filePath;

@end
