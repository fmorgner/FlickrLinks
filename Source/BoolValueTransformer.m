//
//  BoolValueTransformer.m
//  FlickrLinks
//
//  Created by Felix Morgner on 20.06.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "BoolValueTransformer.h"

@implementation BoolValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
	{
	NSString* returnString;
	if([value boolValue])
		{
		returnString = @"Yes";
		}
	else
		{
		returnString = @"No";
		}
	
	return returnString;
	}

@end
