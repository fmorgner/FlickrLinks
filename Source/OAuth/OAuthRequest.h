//
//  OAuthRequest.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAuthToken.h"
#import "OAuthParameter.h"
#import "OAuthSignerProtocol.h"

@interface OAuthRequest : NSMutableURLRequest
	{
	Class signerClass;
	OAuthConsumer* consumer;
	OAuthToken*	token;
	NSString* realm;
	NSString* signature;
	NSString* nonce;
	NSString* timestamp;
	NSMutableArray* oauthParameters;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)realm signerClass:(Class)theSignerClass;

+ (OAuthRequest*)requestWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass;
+ (OAuthRequest*)request;

- (void)prepare;
- (void)addParameter:(OAuthParameter*)aParameter;

@property(nonatomic, retain) OAuthConsumer* consumer;
@property(nonatomic, retain) OAuthToken*	token;
@property(nonatomic, retain) NSString* realm;
@property(nonatomic, retain) NSString* signature;
@property(nonatomic, retain) NSString* nonce;
@property(nonatomic, retain) NSString* timestamp;
@property(nonatomic, assign) Class signerClass;
@property(nonatomic, assign) NSMutableArray* oauthParameters;

@end
