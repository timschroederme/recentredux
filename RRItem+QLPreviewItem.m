//
//  RRItem+QLPreviewItem.m
//  Recent Redux
//
//  Created by Tim Schröder on 11.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRItem+QLPreviewItem.h"


@implementation RRItem (QLPreviewItem)

- (NSURL *)previewItemURL
{
	NSString *path = [[self valueForKey:ITEM_META] valueForAttribute:MDI_PATH];
	if (path==nil) path=@""; // Falls Item Nil ist, was vorkommen kann. Leerer String erzeugt ewiges Lade-Fenster,
							 // aber keinen Laufzeitfehler
	return [NSURL fileURLWithPath:path];
}

- (NSString *)previewItemTitle
{
	return [self valueForKey:ITEM_NAME];
}


@end
