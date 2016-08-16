//
//  NSFileManager+RRAdditions.m
//  Recent Redux
//
//  Created by Tim Schröder on 28.12.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "NSFileManager+RRAdditions.h"


@implementation NSFileManager (RRAdditions)

// Berechnet die Größe eines Folders (private Methode)
- (unsigned long long) fastFolderSizeAtFSRef:(FSRef*)theFileRef isApp:(BOOL)anApp
{
	BOOL maxSizeReached = NO;
    FSIterator    thisDirEnum = NULL;
    unsigned long long totalSize = 0;
	unsigned long long maxSize = MAX_ATTACHMENT_SIZE; // Wenn Größe mehr als 25 MB, vorzeitig abbrechen!
	
    // Iterate the directory contents, recursing as necessary
    if (FSOpenIterator(theFileRef, kFSIterateFlat, &thisDirEnum) == noErr)
    {
        const ItemCount kMaxEntriesPerFetch = 40;
        ItemCount actualFetched;
        FSRef    fetchedRefs[kMaxEntriesPerFetch];
        FSCatalogInfo fetchedInfos[kMaxEntriesPerFetch];
		
		OSErr fsErr = FSGetCatalogInfoBulk(thisDirEnum, kMaxEntriesPerFetch, &actualFetched,
										   NULL, kFSCatInfoDataSizes | kFSCatInfoRsrcSizes |
										   kFSCatInfoNodeFlags, fetchedInfos, fetchedRefs, NULL, NULL);
        while ((fsErr == noErr) || (fsErr == errFSNoMoreItems))
        {
            ItemCount thisIndex;
            for (thisIndex = 0; thisIndex < actualFetched; thisIndex++)
            {
                // Recurse if it's a folder
                if (fetchedInfos[thisIndex].nodeFlags & kFSNodeIsDirectoryMask)
                {
                    totalSize += [self fastFolderSizeAtFSRef:&fetchedRefs[thisIndex] isApp:anApp];
                }
                else
                {
                    // add the size for this item
                    totalSize += fetchedInfos [thisIndex].dataLogicalSize;
                }
				// Prüfen, ob Maximalgröße erreicht (falls keine App) 
				if ((totalSize > maxSize) && (anApp == NO)) {
					maxSizeReached = YES;
					break;
				}
            }
			
            if ((fsErr == errFSNoMoreItems) || maxSizeReached)
            {
                break;
            }
            else
            {
                // get more items
                fsErr = FSGetCatalogInfoBulk(thisDirEnum, kMaxEntriesPerFetch, &actualFetched,
											 NULL, kFSCatInfoDataSizes | kFSCatInfoNodeFlags, fetchedInfos,
											 fetchedRefs, NULL, NULL);
            }
        }
        FSCloseIterator(thisDirEnum);
    }
    return totalSize;
}

// Öffentliche Methode, wird von RRAppDelegate+Email und RRAppDelegate (TableViewDelegate) aufgerufen
-(unsigned long long) fastFolderSizeAtPath:(NSString*)path isApp:(BOOL)anApp
{
	FSRef aFSRef;
	OSStatus os = FSPathMakeRef((const UInt8 *)[path fileSystemRepresentation], &aFSRef, NULL);
	if (os != noErr) return 0;
	return [self fastFolderSizeAtFSRef:&aFSRef isApp:anApp];
}

// Gibt Einträge für Kontextmenü zurück
-(NSArray *) openWithMenuForFile:(NSString*)filePath
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
	NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	if (!fileURL) return nil;
	
	// Alle geeigneten Apps ermitteln
	CFArrayRef array = NULL;
	array = LSCopyApplicationURLsForURL ((CFURLRef)fileURL, kLSRolesAll);
	if (array == NULL) return nil;
	int i;
	for (i=0;i<[(NSArray*)array count];i++) {
		NSURL *appURL = [[(NSURL*)[(NSArray*)array objectAtIndex:i] copy] autorelease];
		NSString *appPath = [appURL path];
		
		/*
		CFStringRef outDisplayName;
		LSCopyDisplayNameForURL	((CFURLRef)[(NSArray*)array objectAtIndex:i], &outDisplayName);	
		NSString *appName = [[(NSString*)outDisplayName copy] autorelease];
		if (outDisplayName != NULL) CFRelease(outDisplayName); //// weil String über Methode gefüllt wird, die "copy" im Titel enthält
		 */
		NSString *appName = [[NSFileManager defaultManager] displayNameAtPath:appPath];
		NSBundle *bundle = [NSBundle bundleWithPath:appPath];
		NSString *appVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
		if (appVersion == nil) appVersion = @"";
		[dict setObject:appPath forKey:@"appPath"];
		[dict setObject:appName forKey:@"appName"];
		[dict setObject:appVersion forKey:@"appVersion"];
		
		
		// Gleich sortieren und ggf. Versionsnummern hinzufügen
		int j;
		BOOL alreadySorted = NO;
		if ([result count] == 0) {
			[result addObject:dict];
		} else {
			for (j=0;j<[result count];j++) {
				if (alreadySorted == NO) {
					NSMutableDictionary *sortDict = [result objectAtIndex:j]; //?
					NSString *sortName = [sortDict valueForKey:@"appName"];
					NSComparisonResult compResult = [appName compare:sortName];
					if (compResult != NSOrderedDescending) {
						alreadySorted = YES;
						BOOL isSame = NO;
						// Wenn 2x der gleiche Name, dann Versionsnummern hinzufügen
						if (compResult == NSOrderedSame) {
							NSString *longAppName;
							NSString *longSortName;
							NSString *sortVersion;
							sortVersion = [sortDict valueForKey:@"appVersion"];
							if (![appVersion compare:sortVersion] == NSOrderedSame) {
								if (![appVersion isEqualToString:@""]) {
									longAppName = [NSString stringWithFormat:@"%@ (%@)", appName, appVersion];
									[dict setValue:longAppName forKey:@"appName"];
								} else {
									longAppName = appName;
								}
								if (![sortVersion isEqualToString:@""]) {
									longSortName = [NSString stringWithFormat:@"%@ (%@)", sortName, sortVersion];
									[[result objectAtIndex:j] setValue:longSortName forKey:@"appName"];
								} else {
									longSortName = sortName;
								}
								if ([longAppName isEqualToString:longSortName]) isSame = YES;
							} else {
								isSame = YES;
							}
						}
						if (!isSame) [result insertObject:dict atIndex:j];
					}

				}
			}
			if (alreadySorted == NO) [result insertObject:dict atIndex:[result count]];
		}
	}

	// Hier noch rauskriegen, was Makro SAFE_RELEASE ist
	if (array != NULL) CFRelease(array); // weil Array über Methode gefüllt wird, die "copy" im Titel enthält

	if (result) return [NSArray arrayWithArray:result];
	return nil;
}

	
@end
