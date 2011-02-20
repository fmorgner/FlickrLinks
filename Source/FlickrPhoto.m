//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrPhoto.h"


@implementation FlickrPhoto

@synthesize image, pools, tags, sets, comments, commentCount, title, favorites, galleries;

- (id)init
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (void)dealloc
	{
	[tags release];
	[image release];
	[pools release];
	[sets release];
	[comments release];
	[title release];
	[favorites release];
	[galleries release];
	[super dealloc];
	}

@end
