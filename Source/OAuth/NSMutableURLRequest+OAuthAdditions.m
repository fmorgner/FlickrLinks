//
//  NSMutableURLRequest+OAuthParameters.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 20.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSMutableURLRequest+OAuthAdditions.h"


@implementation NSMutableURLRequest (OAuthAdditions)

- (NSArray*)parameters
	{
	NSString* parameterString;
	
	if([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"])
		{
		parameterString = [[self URL] query];
		}
	else
		{
		parameterString = [[[NSString alloc] initWithData:[self HTTPBody] encoding:NSASCIIStringEncoding] autorelease];
		}
	
	if((parameterString == nil) || [parameterString isEqualToString:@""])
		{
		return nil;
		}
	
	NSArray* parameterPairs = [parameterString componentsSeparatedByString:@"&"];
	NSMutableArray* requestParameters = [[NSMutableArray alloc] init];
	
	for(NSString* pair in parameterPairs)
		{
		NSArray* pairElements = [pair componentsSeparatedByString:@"="];
		OAuthParameter *parameter = [OAuthParameter parameterWithKey:[[pairElements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] andValue:[[pairElements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[requestParameters addObject:parameter];
		}
	
	return requestParameters;
	}
	
- (void)setParameters
	{
	}

@end
