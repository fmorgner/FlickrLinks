//
//  OAuthConsumer.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthToken.h"

@interface OAuthConsumer : OAuthToken
	{
	}

+ (OAuthConsumer*)consumerWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized;
+ (OAuthConsumer*)consumer;

@end
