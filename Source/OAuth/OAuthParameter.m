//
//  OAuthParameter.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthParameter.h"

@implementation OAuthParameter

#pragma mark - Properties

@synthesize key;
@synthesize value;

#pragma mark - Object Lifecycle

- (id)initWithKey:(NSString*)theKey andValue:(NSString*)theValue
	{
	if((self = [super init]))
		{
		[self setValue:theValue];
		[self setKey:theKey];
		}
	
	return self;
	}

- (id)init
	{
	if((self = [super init]))
		{
		self.value = nil;
		self.key = nil;
		}
	
	return self;
	}	

- (void)dealloc
	{
	[key release];
	[value release];
	[super dealloc];
	}
#pragma mark - Convenience Allocators

+ (OAuthParameter*)parameterWithKey:(NSString*)theKey andValue:(NSString*)theValue
	{
	return [[[OAuthParameter alloc] initWithKey:theKey andValue:theValue] autorelease];
	}

+ (OAuthParameter*)parameter
	{
	return [[[OAuthParameter alloc] init] autorelease];
	}

#pragma mark - Utility Methods
	
- (NSString*)OAuthURLEncodedKey
	{
	return [key stringUsingOAuthURLEncoding];
	}
	
- (NSString*)OAuthURLEncodedValue
	{
	return [value stringUsingOAuthURLEncoding];
	}

- (NSString*)OAuthURLEncodedKeyValuePair
	{
	NSString* keyValuePair = [NSString stringWithFormat:@"%@=%@", key, value];
	return [keyValuePair stringUsingOAuthURLEncoding];
	}

- (NSString*)concatenatedKeyValuePair
	{
	NSString* keyValuePair = [NSString stringWithFormat:@"%@=%@", key, value];
	return keyValuePair;
	}
@end
