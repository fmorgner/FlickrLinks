//
//  NSURL+OAuthAdditions.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 22.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthParameter.h"

@interface NSURL (OAuthAdditions)

- (NSString*)URLStringWithoutQuery;
- (NSURL*)URLByAppendingParameter:(OAuthParameter*)aParameter;
- (NSURL*)URLByAppendingParameters:(NSArray*)theParameters;

@end
