//
//  FlickrAPIResponse.m
//  FlickrLinks
//
//  Created by Felix Morgner on 03.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrAPIResponse.h"


@implementation FlickrAPIResponse

@synthesize status;
@synthesize dataFormat;
@synthesize unparsedData;
@synthesize content;
@synthesize error;

- (id)init
	{
	if ((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithData:(NSData*)theData
	{
	if ((self = [super init]))
		{
		unparsedData = theData;
		
		NSError* xmlError = nil;
		NSArray* tempArray = nil;
		
		NSXMLDocument* document = [[NSXMLDocument alloc] initWithData:theData options:0 error:&xmlError];
		if(xmlError != nil)
			return nil;
		
		tempArray = [document nodesForXPath:@"rsp" error:&xmlError];
		
		if(![tempArray count])
			return nil;
		
		status = [[[tempArray objectAtIndex:0] attributeForName:@"stat"] stringValue];
		
		if([status isEqualToString:@"fail"])
			{
			tempArray = [document nodesForXPath:@"rsp/err" error:&xmlError];
			NSString* errorDescription = [[[tempArray objectAtIndex:0] attributeForName:@"msg"] stringValue];
			NSInteger errorCode = [[[[tempArray objectAtIndex:0] attributeForName:@"code"] stringValue] intValue];
			error = [NSError errorWithDomain:kFlickrErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
			}
		else if([status isEqualToString:@"ok"])
			{
			content = [[[document nodesForXPath:@"rsp" error:&xmlError] objectAtIndex:0] children];
			}
		}
	return self;
	}

+ (FlickrAPIResponse*)responseWithData:(NSData*)theData;
	{
	return [[[FlickrAPIResponse alloc] initWithData:theData] autorelease];
	}


- (void)dealloc
{
	[super dealloc];
}

@end
