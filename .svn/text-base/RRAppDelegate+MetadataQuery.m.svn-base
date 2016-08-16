//
//  RRAppDelegate+MetadataQuery.m
//  Recent Redux
//
//  Created by Tim Schröder on 27.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+MetadataQuery.h"
#import "RRAppDelegate+Items.h"
#import "RRItem.h"
#import "RRStatusBar.h"
#import "RRAppDelegate+Multithreading.h"
#import "RRAppDelegate+UserDefaults.h"


@implementation RRAppDelegate (MetadataQuery)

#pragma mark -
#pragma mark Thread Functions

// Wird als separater Thread von queryFinished gestartet
-(void)processQuery
{
	// temporäres Array mit jeweils 25 Items füllen, dann an Main Thread übergeben, zur Aufnahme in ItemsController
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:25];
	int cnt = [query resultCount];
	int i;
	
	for (i=0; i<cnt; i++) {
		// Prüfen, ob Thread abgebrochen wurde
		if ([self isThreadCancelled:@selector(processQuery)]) {
			[tempArray release];
			return;
		}
		
		RRItem *item = [self makeRRItem:[query resultAtIndex:i]];
		if (item) {
			[tempArray addObject:item];
			[statusBar setAnimationValue:i];
			if ([tempArray count]== 25) {
			
				// x Items an Main Thread übergeben
				[self performSelectorOnMainThread:@selector(updateInterface:)
									   withObject:tempArray 
									waitUntilDone:YES];
				[tempArray removeAllObjects];
			}
		}
	} 
	// Restliche Items übergeben
	if ([tempArray count]>0) [self performSelectorOnMainThread:@selector(updateInterface:)
													withObject:tempArray 
												 waitUntilDone:YES];
	
	// StatusBar ändern
	[statusBar showCountLabel];
	
	[tempArray release];
	
}

// Wird als separater Thread von queryUpdated gestartet
-(void)processUpdate
{
	int queryCnt = [query resultCount];
	int itemsCnt = [items count];
	// Prüfen, ob items gelöscht oder upgedatet werden müssen
	int i;
	i=0;
	NSMutableSet *set = [NSMutableSet setWithCapacity:queryCnt];
	if ((queryCnt > 0) && (itemsCnt > 0)) {
		do {
			NSMetadataItem *item = [[items objectAtIndex:i] valueForKey:ITEM_META];
			int pos;
			pos = [query indexOfResult:item];
			// Item nicht mehr in Query-Ergebnis enthalten
			if (pos == -1) {
				[self performSelectorOnMainThread:@selector(removeItem:)
									   withObject:[items objectAtIndex:i] 
									waitUntilDone:YES];
				i--;
				itemsCnt--;
			} else {
				// Item nach wie vor vorhanden, Meta-Daten updaten (falls sich da was geändert hat)
				// Falls diese Routine nicht vorhanden ist, würde Item sonst unten nochmal eingefügt werden
				// Update nur nötig, wenn sich Position in Ergebnisliste verändert hat. 
				NSMetadataItem *queryItem = [query resultAtIndex:pos];
				
				// Prüfen, ob Item upgedated werden muss
				BOOL needsUpdate = NO;
				if (![[item valueForAttribute:MDI_FILE_NAME] isEqualToString:[queryItem valueForAttribute:MDI_FILE_NAME]]) needsUpdate = YES;
				NSDate *date = [self dateOfItem:queryItem];
				if (date) {
					if ([date compare:[[items objectAtIndex:i] valueForKey:ITEM_RAWDATE]] != NSOrderedSame) needsUpdate = YES;
				}

				if (needsUpdate) {
					NSArray *updateArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:i], queryItem, nil];
					
					[self performSelectorOnMainThread:@selector(updateItemAtPos:)
										   withObject:updateArray 
										waitUntilDone:YES];
				}
				[set addObject:queryItem];
			}
			i++;
			if ([self isThreadCancelled:@selector(processUpdate)]) return;
		} while (i<itemsCnt);
	}
	if (queryCnt > [set count]) { // Wenn nicht größer, brauchen wir auch nichts einfügen
		int cc = 0;
		for (i=0;i<queryCnt;i++) {
			if (![set containsObject:[query resultAtIndex:i]]) {
				// Item ist noch nicht im Array, hinzufügen
				RRItem *newItem = [self makeRRItem:[query resultAtIndex:i]];
				if (newItem) {
					[self performSelectorOnMainThread:@selector(addItemToArray:)
										   withObject:newItem 
										waitUntilDone:YES];
				}
				cc++;
			}
		}
	}
}

// Wird im Main Thread aufgerufen, wenn der Thread 20 Items fertig hat, zum Einfügen in den Controller
-(void)updateInterface:(NSMutableArray*)array
{
	int i;
	for (i=0;i<[array count];i++) {
		[self addItemToArray:[array objectAtIndex:i]];
	}
	[itemController rearrangeObjects];
}

#pragma mark -
#pragma mark Result Processing Methods

// Initiale Querysuche beendet, jetzt alle Items in Array und ItemController aufnehmen
- (void)queryFinished:(NSNotification *)notification
{
	//NSLog (@"queryFinished %i", [query resultCount]);
	[query disableUpdates];
	// Alte Items löschen
	[items removeAllObjects];
	[statusBar startDeterminateAnimation:[query resultCount]];
	[self startNewThread:THREAD_INITIALQUERY 
			withSelector:@selector(processQuery) 
			  withObject:nil];
}

- (void)queryUpdated:(NSNotification *)notification 
{
	[query disableUpdates];
	[self startNewThread:THREAD_UPDATEQUERY 
			withSelector:@selector(processUpdate)
			  withObject:nil];
}

// Wird aufgerufen, wenn Background Thread mit Update fertig ist
- (void)finalizeQueryUpdate
{
	// Scrollt zu neu eingefügter Zeile
	/*
	 if ([table selectedRow] != RRNotFound) 
	 {
	 [table scrollRowToVisible:[table selectedRow]];
	 }
	 */ 
	//[itemController rearrangeObjects]; // unklar, ob erforderlich? 
	// [table reloadData];
	[query enableUpdates];
}

- (void)queryProgress:(NSNotification *)notification 
{
	//	NSLog (@"queryProgress");
}


#pragma mark -
#pragma mark Start Query Methods

- (void) notifyOnBackgroundThreadFinish
{
	[operationQueue waitUntilAllOperationsAreFinished];
	[self performSelectorOnMainThread:@selector(reallyStartNewQuery) withObject:nil waitUntilDone:NO];
}


// Beginnt Query
- (void)startNewQuery:(NSString*)queryMode
{
	if (query) [query stopQuery];
	[statusBar showMessageLabel:queryMode];
	
	// Alte Queue entfernen (um Memory Leaks zu vermeiden)
	[self cancelThreadWithSelector:@selector(processQuery)];
	[self cancelThreadWithSelector:@selector(processUpdate)];
	[self performSelectorInBackground:@selector(notifyOnBackgroundThreadFinish) withObject:nil];
}

-(void)reallyStartNewQuery
{
	// Alte Query entfernen
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	if (query) [query release];
	
	//[statusBar stopAnimation];
	
	// Query-Objekt erzeugen
	query = [[NSMetadataQuery alloc] init];
	
	// Bei Query für Notifications registrieren
	[nc addObserver:self
		   selector:@selector(queryFinished:)
			   name:NSMetadataQueryDidFinishGatheringNotification 
			 object:query];
	
	[nc addObserver:self
		   selector:@selector(queryUpdated:)
			   name:NSMetadataQueryDidUpdateNotification
			 object:query];
	
	[nc addObserver:self
		   selector:@selector(queryProgress:)
			   name:NSMetadataQueryGatheringProgressNotification
			 object:query];
			
	// Suchzeitraum und Suchumfang festlegen
	NSDate *today = [NSDate date];
	double interval = [[self searchInterval] doubleValue];
	interval = -(interval * 60.0 * 60.0);
	NSDate *date = [NSDate dateWithTimeInterval:interval sinceDate:today];
	NSPredicate *predicate;
	if ([self largeSearchScope]) {
		NSString *predicateString = @"(%K > %@) || (%K > %@)";
		predicate = [NSPredicate predicateWithFormat:predicateString, SEARCH_KEY_1, date, SEARCH_KEY_2, date];
	} else {
		NSString *predicateString = [SEARCH_KEY_1 stringByAppendingString:@" > %@"];
		predicate = [NSPredicate predicateWithFormat:predicateString, date];
	}
	[query setPredicate:predicate];
	int locFlag = [[self searchLocation] intValue];
	
	// Nur Benutzerordner und Programmordner
	if (locFlag==0) {
		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
		[arr addObject:NSMetadataQueryUserHomeScope];	
        //[arr addObject:NSHomeDirectory()]; // DEBUG TEST
		[arr addObject:PATH_MAINAPPDIR];
		[arr addObject:PATH_DEVELOPAPPDIR];
		[query setSearchScopes:arr];
	}
	// Alle Ordner
	if (locFlag==1) {
		[query setSearchScopes: [NSArray arrayWithObjects: NSMetadataQueryLocalComputerScope, nil]];
	}

	// DEBUG
	// NSString *predicateString = @"_kMDItemGroupId = 8";
	// SString *predicateString = [searchKey2 stringByAppendingString:@" > %@) && (SEARCH_SYSTEM_FILES == TRUE)"];
	// NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
	// NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(kMDItemFSContentChangeDate > %@) && (kMDItemContentType == \"pdf\")", date];
	// DEBUG ENDE
	
	/* DEBUG
	 // Scope der Suche setzen
	 NSString *appDirString = @"/Applications";
	 NSArray *searchScope = [NSArray arrayWithObjects:appDirString, nil];
	 [query setSearchScopes:searchScope];
	 DEBUG ENDE */
	
	// Query starten
	[query startQuery];	
}


@end
