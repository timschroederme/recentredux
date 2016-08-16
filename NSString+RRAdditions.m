//
//  NSString+RRAdditions.m
//  Recent Redux
//
//  Created by Tim Schröder on 28.12.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "NSString+RRAdditions.h"


@implementation NSString (RRAdditions)

// Wird von RRAppDelegate (TableViewDelegate) aufgerufen, für Tooltip
+(NSString*)stringWithFileSize:(long long) fileSize
{
	NSString *sizeStr=@"";
	if (fileSize >= GByte) {
		double csize = fileSize/GByte;
		sizeStr = [NSString stringWithFormat:@"%1.2f GB", csize];
	}
	if ((fileSize >= MByte) && (fileSize < GByte)) {
		double csize = fileSize/MByte;
		sizeStr = [NSString stringWithFormat:@"%1.2f MB", csize];
	}
	if ((fileSize >= KByte) && (fileSize < MByte)) {
		double csize = fileSize/KByte;
		sizeStr = [NSString stringWithFormat:@"%1.2f KB", csize];
	}
	if (fileSize < KByte) {
		int isize = (int)fileSize;
		if (isize != 1) {
			sizeStr = [NSString stringWithFormat:@"%i Bytes", isize];
		} else {
			sizeStr = [NSString stringWithFormat:@"%i Byte", isize];
		}
	}
	return sizeStr;
}

// Wird von RRAppDelegate+Actions aufgerufen, um zu lange Filenamen für Menüeintrag zu verkürzen
-(NSString*)truncateString
{
	NSString *result = self;
	int len = [self length];
	if (len > MAX_MENU_LENGTH) { // kürzen
		int delta = len-MAX_MENU_LENGTH;
		NSString *first = [self substringToIndex: ((len/2)-(delta/2))];
		NSString *second = [self substringFromIndex: ((len/2)+(delta/2))];
		result = [NSString stringWithFormat:@"%@...%@", first, second];
	}
	return result;
}

// Wird von RRStatusBar und Localization Controller aufgerufen, um Länge eines Strings zu berechnen
-(float)calculateStringWidth:(NSControl*)control
{
	NSMutableParagraphStyle *primaryStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
									[control font], NSFontAttributeName, 
									primaryStyle, NSParagraphStyleAttributeName, 
									nil];	
	NSSize stringSize = [self sizeWithAttributes:textAttributes];
	return roundf (stringSize.width);
}

@end
