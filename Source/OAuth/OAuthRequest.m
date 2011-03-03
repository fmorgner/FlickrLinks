//
//  OAuthRequest.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequest.h"
#import "OAuthToken.h"
#import "OAuthSignerHMAC.h"
#import "OAuthSignerProtocol.h"
#import "OAuthParameter.h"
#import "NSString+OAuthAdditions.h"
#import "NSMutableURLRequest+OAuthAdditions.h"
#import "NSURL+OAuthAdditions.h"

@interface OAuthRequest (Private)

- (NSString*)generateNonce;
- (NSString*)generateTimestamp;
- (NSString*)signatureBaseString;

@end

@implementation OAuthRequest (Private)

- (NSString*)generateNonce
	{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	NSString* nonceString = (NSString*)uuidString;
	CFMakeCollectable(uuidString);
	CFRelease(uuid);
	
	return nonceString;
	}
	
- (NSString*)generateTimestamp
	{
	return [NSString stringWithFormat:@"%d", time(NULL)];
	}

- (NSString*)signatureBaseString
	{
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_callback" andValue:@"oob"]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_consumer_key" andValue:consumer.key]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_signature_method" andValue:[signerClass signatureType]]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_timestamp" andValue:timestamp]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_nonce" andValue:nonce]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_version" andValue:@"1.0"]];
	
	if(![token.key isEqualToString:@""])
		{
		[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_token" andValue:token.key]];
		}
		
	[oauthParameters sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease]]];
	NSMutableArray* keyValuePairStrings = [NSMutableArray arrayWithCapacity:[oauthParameters count]];
	
	for(OAuthParameter* parameter in [self parameters])
		{
		[keyValuePairStrings addObject:[parameter concatenatedKeyValuePair]];
		}

	for(OAuthParameter* parameter in oauthParameters)
		{
		[keyValuePairStrings addObject:[parameter concatenatedKeyValuePair]];
		}

	NSString* baseString = [keyValuePairStrings componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@&%@&%@", [self HTTPMethod], [[[self URL] URLStringWithoutQuery] stringUsingOAuthURLEncoding], [baseString stringUsingOAuthURLEncoding]];
	}

@end

@implementation OAuthRequest

#pragma mark - Properties

@synthesize consumer;
@synthesize token;
@synthesize nonce;
@synthesize realm;
@synthesize signature;
@synthesize timestamp;
@synthesize signerClass;
@synthesize oauthParameters;

#pragma mark - Object Lifecycle

- (id)init
	{
	if ((self = [super init]))
		{
		
    }
    
	return self;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	if ((self = [super initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0]))
		{
		[self setConsumer:theConsumer];

		(theToken == nil) ? [self setToken:[OAuthToken token]] : [self setToken:theToken];
		(theRealm == nil) ? [self setRealm:[NSString stringWithString:@""]] : [self setRealm:theRealm];

		if([theSignerClass conformsToProtocol:@protocol(OAuthSigner)])
			{
			[self setSignerClass:theSignerClass];
			}
		else
			{
			[self setSignerClass:[OAuthSignerHMAC class]];
			}

		[self setNonce:[self generateNonce]];
		[self setTimestamp:[self generateTimestamp]];
		
		self.oauthParameters = [[NSMutableArray alloc] init];
    }

	return self;
	}

- (void)dealloc
	{
	[consumer release];
	[token release];
	[nonce release];
	[realm release];
	[signature release];
	[timestamp release];
	[oauthParameters release];
	[super dealloc];
	}

#pragma mark - Convenience Allocators

+ (OAuthRequest*)request
	{
	return [[[OAuthRequest alloc] init] autorelease];
	}

+ (OAuthRequest*)requestWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	return [[[OAuthRequest alloc] initWithURL:theURL consumer:theConsumer token:theToken realm:theRealm signerClass:theSignerClass] autorelease];
	}


#pragma mark - Utility Methods

- (void)addParameter:(OAuthParameter*)aParameter
	{
	if(aParameter)
		{
		[oauthParameters addObject:aParameter];
		}
	}

- (void)prepare
	{
	NSString* sigKey = [NSString stringWithFormat:@"%@&%@", consumer.secret, token.secret];
	NSString* sigBase = [self signatureBaseString];
	[self setSignature:[signerClass signClearText:sigBase withSecret:sigKey]];

	NSMutableString* oauthHeaderString = [NSMutableString stringWithFormat:@"OAuth realm=\"%@\"", [realm stringUsingOAuthURLEncoding]];
	
	for(OAuthParameter* parameter in oauthParameters)
		{
		[oauthHeaderString appendFormat:@", %@=\"%@\"", [[parameter key] stringUsingOAuthURLEncoding], [[parameter value] stringUsingOAuthURLEncoding]];
		}

	[oauthHeaderString appendFormat:@", oauth_signature=\"%@\"", [signature stringUsingOAuthURLEncoding]];

	[self setValue:oauthHeaderString forHTTPHeaderField:@"Authorization"];
	}

@end
