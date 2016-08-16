//
//  RRTableCell.m
//  Recent Redux
//
//  Created by Tim Schröder on 29.10.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRTableCell.h"


@implementation RRTableCell


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	
	// Gradient
	/*
	NSColor *startColor, *endColor;
	if ([self isHighlighted]) {
		startColor = [NSColor colorWithCalibratedRed:0.9019 green:0.9019 blue:0.9019 alpha:1.0];
		endColor = [NSColor colorWithCalibratedRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
	} else {
		startColor = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		endColor = [NSColor colorWithCalibratedRed:0.9607 green:0.9607 blue:0.9607 alpha:1.0];
	}
	
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
	[gradient drawInRect: cellFrame angle:90];
	*/
	// Daten für die Anzeige auslesen
	
	NSDictionary *cellValues = [self objectValue];
	
	NSString *itemName = [cellValues valueForKey:ITEM_NAME];
	NSString *itemKind = [cellValues valueForKey:ITEM_KIND];
	NSString *itemChangeDate = [cellValues valueForKey:ITEM_DAY];
	NSString *itemChangeTime = [cellValues valueForKey:ITEM_TIME];
	NSImage *icon = [cellValues valueForKey:ITEM_ICON];
	 
	/*
	NSDateFormatter *weekday = [[[NSDateFormatter alloc] init] autorelease];
	[weekday setDateFormat: @"EEEE"];
	NSString *itemChangeDate = [weekday localizedStringFromDate:[cellValues objectAtIndex:2]];
	*/

	NSMutableParagraphStyle *primaryStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	[primaryStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
	NSMutableParagraphStyle *secondaryStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	[secondaryStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];

	
	NSColor *primaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor textColor];
	NSColor *secondaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor disabledControlTextColor];
	 
	/*
	NSColor *primaryColor = [NSColor textColor];
	NSColor *secondaryColor = [NSColor disabledControlTextColor];
	NSColor *timeColor = [NSColor colorWithCalibratedRed:0.3529 green:0.5058 blue:0.7686 alpha:1.0];
*/
	
	/*
	NSShadow *shadow =  [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor colorWithDeviceWhite:1.0 alpha:0.5]];
	[shadow setShadowOffset:NSMakeSize(1.0, -1.1)];
	 */
	NSFont *primaryFont = [NSFont fontWithName:@"Arial Bold" size:12];
	NSFont *secondaryFont = [NSFont fontWithName:@"Arial" size:11];
	//NSFont *primaryFont = [NSFont systemFontOfSize:11.0];
	//NSFont *secondaryFont = [NSFont systemFontOfSize:11.0];
	
	NSDictionary *primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
										   primaryColor, NSForegroundColorAttributeName,
										   primaryFont, NSFontAttributeName, 
										   primaryStyle, NSParagraphStyleAttributeName, 
										 //  shadow, NSShadowAttributeName,
										   nil];	
	NSDictionary *secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
											 secondaryColor, NSForegroundColorAttributeName,
											 secondaryFont, NSFontAttributeName, 
											 secondaryStyle, NSParagraphStyleAttributeName,
											 nil];
	/*
	NSDictionary *primaryTimeTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
										   timeColor, NSForegroundColorAttributeName,
										   primaryFont, NSFontAttributeName, 
										   primaryStyle, NSParagraphStyleAttributeName, 
										   //  shadow, NSShadowAttributeName,
										   nil];		
	NSDictionary *secondaryTimeTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
											 timeColor, NSForegroundColorAttributeName,
											 secondaryFont, NSFontAttributeName, 
											 secondaryStyle, NSParagraphStyleAttributeName,
											 nil];	
	*/
	 
	// Rechenkonstanten
	
	float height = cellFrame.size.height;
	float width = cellFrame.size.width;
	float iconDim = 28;
	
	// Weite von Uhrzeit und Datum
	float timeWidth;
	NSSize timeSize = [itemChangeTime sizeWithAttributes:primaryTextAttributes];
	timeWidth = roundf(timeSize.width);

	float dateWidth;
	NSSize dateSize = [itemChangeDate sizeWithAttributes:secondaryTextAttributes];
	dateWidth = roundf(dateSize.width);	
	
	// Größere Weite
	float biggerWidth;
	if (timeWidth > dateWidth) {
		biggerWidth = timeWidth;
	} else {
		biggerWidth = dateWidth;
	}
	
	// Daten für File-Namen
	NSRect textRect;
	textRect.origin.x = cellFrame.origin.x + iconDim+6;
	//textRect.origin.x = cellFrame.origin.x +6;
	textRect.origin.y = cellFrame.origin.y;
	textRect.size.height = (height - 1)/2;
	textRect.size.width = width-iconDim-6-biggerWidth-15;

	// File-Namen schreiben
	[itemName drawInRect:textRect withAttributes:primaryTextAttributes];
	
	// itemKind schreiben
		
	textRect.origin.y = cellFrame.origin.y + (height/2);
	textRect.size.width = width-iconDim-6-biggerWidth-15;
	if (itemKind!=nil) [itemKind drawInRect:textRect withAttributes:secondaryTextAttributes]; 
	
	// Uhrzeit schreiben
	
	textRect.origin.y = cellFrame.origin.y;
	textRect.size.height = (height - 1)/2;
	textRect.origin.x = cellFrame.origin.x + width - timeWidth - 5;
	//textRect.origin.y = cellFrame.origin.y+8;
	//textRect.size.height = (height - 10);
	textRect.size.width = timeWidth+5;
	/*
	 NSDictionary* dateTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
	 [NSFont systemFontOfSize:14], NSFontAttributeName, style, NSParagraphStyleAttributeName,nil];
	 */
	[itemChangeTime drawInRect:textRect withAttributes:primaryTextAttributes]; 
	
	// Datum schreiben
	
	textRect.origin.x = cellFrame.origin.x + width - dateWidth - 5;
	textRect.origin.y = cellFrame.origin.y + (height/2);
	textRect.size.width = dateWidth+5;
	[itemChangeDate drawInRect:textRect withAttributes:secondaryTextAttributes]; 

		
	// Icon zeichnen
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	float yOffset = cellFrame.origin.y;
	
	if ([controlView isFlipped]) {
		NSAffineTransform *xform = [NSAffineTransform transform];
		[xform translateXBy:0.0 yBy:height];
		[xform scaleXBy:1.0 yBy:-1.0];
		[xform concat];
		yOffset = 0-cellFrame.origin.y;
	}
	
	NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[icon drawInRect:NSMakeRect (cellFrame.origin.x+2, yOffset+4, iconDim, iconDim)
			fromRect:NSMakeRect (0, 0, [icon size].width, [icon size].height)
		   operation:NSCompositeSourceOver fraction:1.0];
	
	[[NSGraphicsContext currentContext] setImageInterpolation:interpolation];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
}


@end
