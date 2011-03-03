//
//  OAuthConsumer.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthConsumer.h"


@implementation OAuthConsumer


#pragma mark - Convenience Allocators

+ (OAuthConsumer*)consumerWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized
	{
	return [[[OAuthConsumer alloc] initWithKey:theKey secret:theSecret authorized:isAuthorized] autorelease];
	}

+ (OAuthConsumer*)consumer
	{
	return [[[OAuthConsumer alloc] init] autorelease];
	}

@end
