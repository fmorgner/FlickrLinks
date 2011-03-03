//
//  OAuthSignerProtocol.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol OAuthSigner <NSObject>

@required
+ (NSString*)signClearText:(NSString*)theClearText withSecret:(NSString*)theSecret;
+ (NSString*)signatureType;
@end
