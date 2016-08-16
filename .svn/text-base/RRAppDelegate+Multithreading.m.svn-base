//
//  RRAppDelegate+Multithreading.m
//  Recent Redux
//
//  Created by Tim Schröder on 28.11.10.
//  Copyright 2010 Tentacle Forge. All rights reserved.
//

#import "RRConstants.h"
#import "RRAppDelegate+Multithreading.h"
#import "RRAppDelegate+MetadataQuery.h"
#import "RRStatusBar.h"

@implementation RRAppDelegate (Multithreading)

// Startet neuen separaten Thread
- (void) startNewThread:(NSString*)context withSelector:(SEL)selector withObject:(id)object
{
	NSInvocationOperation *theOp = [[NSInvocationOperation alloc] initWithTarget:self
																		selector:selector
																		  object:object];
	[theOp addObserver:self
			forKeyPath:@"isFinished" 
			   options:NSKeyValueObservingOptionNew
			   context:context];
	[operationQueue addOperation:theOp];
	[theOp release];
}

// Bricht laufenden Thread ab


- (void) cancelThreadWithSelector:(SEL)selector
{
	int i;
	int count = [operationQueue operationCount];
	for (i=0;i<count;i++) {
		if ([[[operationQueue operations] objectAtIndex:i] isMemberOfClass:[NSInvocationOperation class]]) {
			NSInvocationOperation *op = [[operationQueue operations] objectAtIndex:i];
			if ([[op invocation] selector] == selector) [op cancel];
		}
	}
}

- (BOOL) isThreadCancelled:(SEL)selector
{
	BOOL result = NO;
	int i;
	for (i=0;i<[operationQueue operationCount];i++) {
		if ([[[operationQueue operations] objectAtIndex:i] isMemberOfClass:[NSInvocationOperation class]]) {
			NSInvocationOperation *op = [[operationQueue operations] objectAtIndex:i];
			if ([[op invocation] selector] == selector) result = [op isCancelled];
		}
	}
	return result;
}

// Wird aufgerufen, wenn Thread mit der Arbeit fertig ist
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context

{
	if ([(NSString*)context isEqualToString:THREAD_INITIALQUERY]) {
		// Thread wurde von MetadataQuery gestartet
		[object removeObserver:self forKeyPath:@"isFinished"];
		[query enableUpdates];
	}
	if ([(NSString*)context isEqualToString:THREAD_SENDMAIL]) {
		// Thread wurde von Email gestartet
		[object removeObserver:self forKeyPath:@"isFinished"];
		[statusBar showCountLabel];
	}
	if ([(NSString*)context isEqualToString:THREAD_UPDATEQUERY]) {
		// Thread wurde von MetadataQuery gestartet (Update)
		[object removeObserver:self forKeyPath:@"isFinished"];
		[self finalizeQueryUpdate];
    }
}

@end
