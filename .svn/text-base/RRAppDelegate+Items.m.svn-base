//
//  RRAppDelegate+Items.m
//  Recent Redux
//
//  Created by Tim Schröder on 27.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+Items.h"
#import "RRItem.h"

@implementation RRAppDelegate (Items)

#pragma mark -
#pragma mark Helper Functions

// Gibt spätestes Datum des Items zurück
-(NSDate*)dateOfItem:(NSMetadataItem *)item
{
	NSDate *date;
	NSDate *date1 = [item valueForAttribute:SEARCH_KEY_1];
	NSDate *date2 = [item valueForAttribute:SEARCH_KEY_2];
	
	if ((date1 == nil) && (date2 == nil)) return nil;
	if ((date1 == nil) || (date2 == nil)) {
		if (date1 == nil) date = date2;
		if (date2 == nil) date = date1;
	} else {
		date = [date1 laterDate:date2]; 
	}
	return date;
}

#pragma mark -
#pragma mark Items Array Functions

// Prüfen, ob Item schon in Array ist
-(int) isItemInArray: (NSMetadataItem *)item
{
	int pos = -1; // -1 meint, dass item nicht im Array enthalten ist
	int cnt;
	cnt = [[itemController arrangedObjects] count];
	int i = 0;
	do {
		if (item == [[[itemController arrangedObjects] objectAtIndex:i] valueForKey:ITEM_META]) {
			pos = i;
		}
		i++;
	} while ((i<cnt) && (pos == -1));
	return pos;
}

-(void)addItemToArray:(RRItem *)item
{
	[itemController addObject:item];
	//NSLog (@"added:%@", [item valueForKey:ITEM_RAWNAME]);
}

// Neues Item in Array aufnehmen
- (RRItem*) makeRRItem: (NSMetadataItem *)item 
{
	NSString *rawName = [item valueForAttribute:MDI_FILE_NAME];
	NSDate *date = [self dateOfItem:item];
	if (!date) return nil;
    
    // Bug Fix für 1.0.2 (Einträge mit künftigem Datum rausfiltern)
    if ([date timeIntervalSinceNow] > 0.0) return nil;
    
    // Bug Fix für 1.0.2 (Eintrag von Recent-Redux-Programm rausfiltern)
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([[item valueForAttribute:MDI_IDENTIFIER] isEqualToString:bundleIdentifier]) return nil;
    
	NSString *itemPath = [item valueForAttribute:MDI_PATH];
	if ([itemPath length] == 0) return nil; // scheint manchmal vorzukommen, wohl temporäre Files, die schon nicht mehr da sind
	NSImage *itemIcon = [[NSWorkspace sharedWorkspace] iconForFile:itemPath];
	NSString *itemKind = [item valueForAttribute:MDI_KIND];
	//NSLog (@"kind: %@", [item valueForAttribute:@"kMDItemContentType"]);
	if (itemKind == nil) {
		itemKind = ITEM_KIND_UNKNOWN;
	};
	
	// Lokalisierter Name der Dateien
	NSString *itemName = [[NSFileManager defaultManager] displayNameAtPath:itemPath];
	
	NSString *itemChangeDate = [NSDateFormatter localizedStringFromDate:date
															  dateStyle: NSDateFormatterShortStyle
															  timeStyle: NSDateFormatterNoStyle];	
	//if (itemChangeDate == NSNull) {
	
	
	NSString *itemChangeTime = [NSDateFormatter localizedStringFromDate:date
															  dateStyle: NSDateFormatterNoStyle
															  timeStyle: NSDateFormatterShortStyle];
	
	// Daten des Items setzen
	RRItem *newItem = [[[RRItem alloc] init] autorelease];
	[newItem setValue:itemName forKey:ITEM_NAME];
	[newItem setValue:rawName forKey:ITEM_RAWNAME];
	[newItem setValue:itemChangeDate forKey:ITEM_DAY];
	[newItem setValue:itemChangeTime forKey:ITEM_TIME];
	[newItem setValue:itemIcon forKey:ITEM_ICON];
	[newItem setValue:date forKey:ITEM_RAWDATE];
	[newItem setValue:item forKey:ITEM_META];
	[newItem setValue:itemKind forKey:ITEM_KIND];
	[newItem setValue:[item valueForAttribute:MDI_TYPE] forKey:ITEM_TYPE];
	
	// Item zu Array hinzufügen
	//[itemController addObject:newItem];
	//[newItem release];
	
	// DEBUG
	/*
	 
	 NSString *logDate = [NSDateFormatter localizedStringFromDate:date
	 dateStyle: NSDateFormatterNoStyle
	 timeStyle: NSDateFormatterLongStyle];
	 
	 
	 NSLog (@"-------------------");
	 NSLog (@"add to array: %@ %@", logDate, itemName);
	 
	 NSLog (@"%@", itemKind);
	 NSLog (@"%@", itemChangeDate);
	 NSLog (@"%@", itemChangeTime);
	 
	 NSArray *ar = [NSArray arrayWithArray:(NSArray*)[item valueForAttribute:@"kMDItemContentTypeTree"]];
	 int i;
	 for (i=0;i<[ar count];i++) {
	 NSLog (@"%@", [ar objectAtIndex:i]);
	 }
	*/
	// DEBUG ENDE
	return newItem;
}

// Item, das bereits in Array ist, updaten
-(void) updateItemAtPos:(NSArray*)updateArray
{
	int pos = [[updateArray objectAtIndex:0] intValue];
	NSMetadataItem *item = [updateArray objectAtIndex:1];
			   
	if (!item) return;
	// Name und Icon
	
	NSString *itemName = [item valueForAttribute:MDI_FILE_NAME];
	
	// Prüfen, ob Name des Items gleich geblieben ist
	if ([itemName isEqualToString:[[items objectAtIndex:pos] valueForKey:ITEM_RAWNAME]]== NO) {
		
		// Prüfen, ob File noch existiert
		NSString *itemPath = [item valueForAttribute:MDI_PATH];
		if ([itemPath length] == 0) return; // Löschen nicht erforderlich, wird automatisch aus Query-Liste gelöscht
		
		// Neuen rawName setzen
		[[items objectAtIndex:pos] setValue: itemName forKey:ITEM_RAWNAME];
		
		// Neues Icon setzen
		NSImage *itemIcon = [[NSWorkspace sharedWorkspace] iconForFile:itemPath];
		[[items objectAtIndex:pos] setValue:itemIcon forKey:ITEM_ICON];
		
		// Neuen Namen setzen
		itemName = [[NSFileManager defaultManager] displayNameAtPath:itemPath];
		[[items objectAtIndex:pos] setValue:itemName forKey:ITEM_NAME];
		
		// Neues itemKind setzen
		NSString *itemKind = [item valueForAttribute:MDI_KIND];
		[[items objectAtIndex:pos] setValue:itemKind forKey:ITEM_KIND];
		
	}
	
	// Datum aktualisieren
	NSDate *date = [self dateOfItem:item];
	if (!date) return;
	if ([date compare:[[items objectAtIndex:pos] valueForKey:ITEM_RAWDATE]] != NSOrderedSame) {
		
		NSString *itemChangeDate = [NSDateFormatter localizedStringFromDate:date
																  dateStyle: NSDateFormatterShortStyle
																  timeStyle: NSDateFormatterNoStyle];	
		NSString *itemChangeTime = [NSDateFormatter localizedStringFromDate:date
																  dateStyle: NSDateFormatterNoStyle
																  timeStyle: NSDateFormatterShortStyle];
		
		[[items objectAtIndex:pos] setValue:itemChangeDate forKey:ITEM_DAY];
		[[items objectAtIndex:pos] setValue:itemChangeTime forKey:ITEM_TIME];
		[[items objectAtIndex:pos] setValue:date forKey:ITEM_RAWDATE];		
		
		// DEBUG
		/*
		 NSString *logDate = [NSDateFormatter localizedStringFromDate:date
		 dateStyle: NSDateFormatterNoStyle
		 timeStyle: NSDateFormatterLongStyle];
		 
		 
		 NSLog (@"**************");
		 NSLog (@"Update: %@ %@", logDate, [item valueForAttribute:@"kMDItemFSName"]);
		 NSLog (@"**************");
		 */
		// DEBUG ENDE
	}
}

-(void)removeItem:(RRItem*)item
{
	[itemController removeObject:item];
}

@end
