//
//  OAuthAdditions.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 03.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthParameter.h"

@interface NSDictionary (OAuthAdditions)

+ (NSDictionary*)dictionaryWithOauthParameters:(NSArray*)theParameters;

@end
