//
//  RRScopeBar.h
//  Recent Redux
//
//  Created by Tim Schröder on 09.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RRScopeBarDelegateProtocol.h"


@interface RRScopeBar: NSView {
	IBOutlet id <RRScopeBarDelegate, NSObject> delegate; // weak reference
	IBOutlet NSScrollView *scrollView;
	IBOutlet NSMenu *filterMenu;
	NSMutableArray *buttons;
	NSPopUpButton *moreButton;
	BOOL hasHiddenButtons;
	float lastWidth;
	float totalWidth;
}

-(id)initWithFrame:(NSRect)frame;
-(void)dealloc;
-(void)setDelegate:(id)newDelegate;
-(void)awakeFromNib;

-(void)loadData;
-(void)reloadData;
-(void)checkIfPredicateChanged:(int)tag;

-(void) createMenuEntries;
-(NSPopUpButton *)makeMoreButton;
-(NSButton *)buttonForItem:(NSNumber*)tag withTitle:(NSString *)title;
-(void)adjustSubviews;

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize;

-(void)processClick:(NSNumber*)tag clicked:(int)sender;
-(void)informDelegateOfStateChange;
-(IBAction)menuClick:(id)sender;
-(IBAction)overflowMenuClick:(id)sender;
-(IBAction)scopeButtonClicked:(id)sender;

- (void)drawRect:(NSRect)dirtyRect;


@property (assign, nonatomic) id delegate;

@end
