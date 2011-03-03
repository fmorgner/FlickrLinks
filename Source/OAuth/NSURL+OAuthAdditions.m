//
//  NSURL+OAuthAdditions.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 22.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSURL+OAuthAdditions.h"


@implementation NSURL (OAuthAdditions)

- (NSString*)URLStringWithoutQuery
	{
	return [[[self absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0];
	}
	
- (NSURL*)URLByAppendingParameter:(OAuthParameter*)aParameter
	{
	NSURL* returnURL = nil;
	NSString* urlAbsoluteString = [self absoluteString];
	NSString* urlQueryString = [self query];
	NSString* parameterString = [NSString stringWithFormat:@"%@=%@", aParameter.key, aParameter.value];
	NSRange parameterRange = [urlAbsoluteString rangeOfString:@"?"];
	
	if(parameterRange.location == NSNotFound)
		{
		returnURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?%@", urlAbsoluteString, parameterString]];
		}
	else
		{
		NSString* urlBaseString = [[urlAbsoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
		returnURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@&%@", urlBaseString, parameterString, urlQueryString]];		
		}
	
	return returnURL;
	}

- (NSURL*)URLByAppendingParameters:(NSArray*)theParameters
	{
	NSURL* returnURL = nil;
	NSString* urlAbsoluteString = [self absoluteString];
	NSString* urlQueryString = [self query];
	NSMutableString* parameterString = [NSMutableString new];
	OAuthParameter* firstParameter = [theParameters objectAtIndex:0];
	NSRange parameterRange = [urlAbsoluteString rangeOfString:@"?"];
	
	if([theParameters count] == 1)
		{
		[parameterString appendFormat:@"%@=%@", firstParameter.key, firstParameter.value];
		}
	else
		{
		[parameterString appendFormat:@"%@=%@", firstParameter.key, firstParameter.value];

		for(OAuthParameter* parameter in theParameters)
			{
			[parameterString appendFormat:@"&%@=%@", firstParameter.key, firstParameter.value];
			}
		}

	if(parameterRange.location == NSNotFound)
		{
		returnURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?%@", urlAbsoluteString, parameterString]];
		}
	else
		{
		NSString* urlBaseString = [[urlAbsoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
		returnURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@&%@", urlBaseString, parameterString, urlQueryString]];		
		}
		
	return returnURL;
	}
@end
