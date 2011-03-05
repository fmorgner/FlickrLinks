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
