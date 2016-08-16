//
//  NSDictionary+RRAdditions.m
//  Recent Redux
//
//  Created by Tim Schröder on 25.01.11.
//  Copyright 2011 Tentacle Forge. All rights reserved.
//

#import "NSDictionary+RRAdditions.h"
#import "RRConstants.h"

@implementation NSDictionary (RRAdditions)

+(NSDictionary*) createFilter:(NSString *)title 
				 withPredicate:(NSString *)predicate
			   withDescription:(NSString *)description
					isEditable:(BOOL)editable
					   withTag:(NSNumber *)tag
{
	NSString *boolString;
	if (editable) {
		boolString = @"YES";
	} else {
		boolString = @"NO";
	}
	NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
						   title, SCOPE_DICT_TITLE,
						   description, SCOPE_DICT_DESCRIPTION,
						   predicate, SCOPE_DICT_PREDICATE,
						   @"NO", SCOPE_DICT_HIDDEN,
						   @"YES", SCOPE_DICT_ENABLED,
						   boolString, SCOPE_DICT_EDITABLE,
						   tag, SCOPE_DICT_TAG,
						   nil] autorelease];
	return dict;
}

@end
