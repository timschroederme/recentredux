//
//  RRStatusBar.m
//  Recent Redux
//
//  Created by Tim Schröder on 02.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRStatusBar.h"
#import "NSString+RRAdditions.h"


@implementation RRStatusBar


#pragma mark -
#pragma mark Overriden Methods

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
	}
    return self;
}

-(void)dealloc
{
	[messageLabel release];
	[countLabel release];
	[waitProgressIndicator release];
	[super dealloc];
}

-(void)awakeFromNib 
{
	// Label erzeugen
	NSRect labelFrame;
	labelFrame.origin.x = 4;
	labelFrame.origin.y = 4;
	labelFrame.size.width = 131;
	labelFrame.size.height = 14;
	messageLabel = [[NSTextField alloc] initWithFrame:labelFrame];
	[messageLabel setStringValue:@""];
	[messageLabel setEditable:NO];
	[messageLabel setDrawsBackground:NO];
	[messageLabel setBordered:NO];
	[[messageLabel cell] setControlSize:NSSmallControlSize];
	[messageLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	[messageLabel setHidden:YES];
	[self addSubview:messageLabel];

	countLabel = [[NSTextField alloc] initWithFrame:labelFrame];
	[countLabel setStringValue:@""];
	[countLabel setEditable:NO];
	[countLabel setDrawsBackground:NO];
	[countLabel setBordered:NO];
	[[countLabel cell] setControlSize:NSSmallControlSize];
	[countLabel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	[countLabel setHidden:YES];
	[self addSubview:countLabel];
	
	// ProgressIndicator erzeugen
	NSRect progressFrame;
	progressFrame.origin.x = 140;
	progressFrame.origin.y = 4;
	progressFrame.size.width = 50;
	progressFrame.size.height = 12;
	waitProgressIndicator = [[NSProgressIndicator alloc] initWithFrame:progressFrame];
	[waitProgressIndicator setControlSize:NSSmallControlSize];
	[waitProgressIndicator setAutoresizingMask:NSViewWidthSizable];
	[waitProgressIndicator setIndeterminate:NO];
	//[waitProgressIndicator setCanDrawConcurrently:YES];
	[waitProgressIndicator setDisplayedWhenStopped:NO];
	[waitProgressIndicator setUsesThreadedAnimation:YES];
	
	[self addSubview:waitProgressIndicator];
}


#pragma mark -
#pragma mark Bindings-Methoden

-(void)setCountBinding:(NSArrayController*)arrayController
{
	filterController = arrayController; // Zwischenspeichern
	
	[countLabel bind:@"displayPatternValue1" 
	   toObject:arrayController 
	withKeyPath:@"arrangedObjects.@count" 
		options:nil];
	
	NSDictionary *optionsDict = [NSDictionary dictionaryWithObject:@"%{value1}@ %{value2}@" forKey:@"NSDisplayPattern"];
	[countLabel bind:@"displayPatternValue2" 
	   toObject:self 
	withKeyPath:@"itemOritems" 
		options:optionsDict];
}

- (NSString *)itemOritems
{
	if (!filterController) return STATUS_ITEM_PLURAL;
	if ([[filterController arrangedObjects] count] == 1)
		return STATUS_ITEM_SINGULAR;
	return STATUS_ITEM_PLURAL;
}

#pragma mark -
#pragma mark Anzeigemethoden

// Passt Länge der Items in der StatusBar an Textlänge an und setzt Text
-(void)setMessage:(NSString*)caption
{
	// Erforderliche Länge des Textfeldes ausrechnen und setzen
	/*
	NSMutableParagraphStyle *primaryStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
									[messageLabel font], NSFontAttributeName, 
									primaryStyle, NSParagraphStyleAttributeName, 
									nil];	
	NSSize stringSize = [caption sizeWithAttributes:textAttributes];
	NSRect noticeRect = [messageLabel frame];
	noticeRect.size.width = stringSize.width+10;
	[messageLabel setFrame:noticeRect];*/
	
	
	NSRect noticeRect = [messageLabel frame];
	float width = [caption calculateStringWidth:(NSControl*)messageLabel];
	noticeRect.size.width = width + 10;
	[messageLabel setFrame:noticeRect];
	
	
	// Länge des ProgressIndicators ausrechnen und setzen
	NSRect progressRect = [waitProgressIndicator frame];
	progressRect.origin.x = noticeRect.origin.x + noticeRect.size.width;
	NSRect windowRect = [[self window] frame];
	progressRect.size.width = windowRect.size.width-progressRect.origin.x-19;
	[waitProgressIndicator setFrame:progressRect];
	
	// Text setzen
	[messageLabel setStringValue:caption];
}


-(void)startAnimation
{
	[waitProgressIndicator startAnimation:self];
	[waitProgressIndicator display];
}

-(void)startDeterminateAnimation:(int)maxValue
{
	[waitProgressIndicator setIndeterminate:NO];
	[waitProgressIndicator setMinValue:0];
	[waitProgressIndicator setMaxValue:maxValue];
}

-(void)setAnimationValue:(int)value
{
	[waitProgressIndicator setDoubleValue:value];
}

-(void)stopAnimation
{
	[waitProgressIndicator stopAnimation:self];
	[waitProgressIndicator setHidden:YES];
	[waitProgressIndicator setIndeterminate:YES];
}

#pragma mark -
#pragma mark Convenience Methods

-(void)showCountLabel
{
	[self stopAnimation];
	[messageLabel setHidden:YES];
	[self stopAnimation];
	[countLabel setHidden:NO];
	
}

-(void)showMessageLabel:(NSString*)message
{
 	[countLabel setHidden:YES];
	[self setMessage:message];
	[messageLabel setHidden:NO];
	[waitProgressIndicator setHidden:NO];
	[waitProgressIndicator setIndeterminate:YES];
	[waitProgressIndicator startAnimation:self];
	[waitProgressIndicator display];
	//[messageLabel display];
	// [self display];
}

@end
