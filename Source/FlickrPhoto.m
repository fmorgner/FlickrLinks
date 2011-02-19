//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrPhoto.h"


@implementation FlickrPhoto

@synthesize image, information;

- (id)init
	{
	if((self = [super init]))
		{
		information = [NSMutableDictionary new];
		}
	return self;
	}

@end
