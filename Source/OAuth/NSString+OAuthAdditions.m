//
//  NSString+OAuthAdditions.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSString+OAuthAdditions.h"


@implementation NSString (OAuthAdditions)

- (NSString*)stringUsingOAuthURLEncoding
	{
	NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
	return [encodedString autorelease];
	}

@end
