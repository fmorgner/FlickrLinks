//
//  OAuthAdditions.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 03.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSDictionary+OAuthAdditions.h"


@implementation NSDictionary (OAuthAdditions)

+ (NSDictionary*)dictionaryWithOauthParameters:(NSArray*)theParameters
	{
	NSMutableDictionary* parameterDictionary = [NSMutableDictionary dictionary];
	
	for(OAuthParameter* parameter in theParameters)
		{
		[parameterDictionary setValue:parameter.value forKey:parameter.key];
		}
	
	return (NSDictionary*)parameterDictionary;
	}


@end
