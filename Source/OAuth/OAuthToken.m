//
//  OAuthToken.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthToken.h"


@implementation OAuthToken

#pragma mark - Properties

@synthesize key;
@synthesize secret;
@synthesize authorized;

#pragma mark - Object Lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		self.key = @"";
		self.secret = @"";
		self.authorized = NO;
		}
	
	return self;
	}

- (id)initWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized
	{
	if((self = [super init]))
		{
		self.key = theKey;
		self.secret = theSecret;
		self.authorized = isAuthorized;
		}
	
	return self;	
	}

- (void)dealloc
	{
	[key release];
	[secret release];
	[super dealloc];
	}

#pragma mark - Convenience Allocators

+ (OAuthToken*)tokenWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized
	{
	return [[[OAuthToken alloc] initWithKey:theKey secret:theSecret authorized:isAuthorized] autorelease];
	}

+ (OAuthToken*)token
	{
	return [[[OAuthToken alloc] init] autorelease];
	}

#pragma mark - NSObject methods

- (NSString *)description
	{
	NSString* authorizedState = nil;
	(authorized) ? (authorizedState = @"YES") : (authorizedState = @"NO");
	return [NSString stringWithFormat:@"%@ {key = %@, secret = %@, authorized = %@}", [self class], key, secret, authorizedState];
	}

@end
