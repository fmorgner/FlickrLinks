//
//  OAuthHMAC.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"
#import "OAuthSignerProtocol.h"

@interface OAuthSignerHMAC : NSObject <OAuthSigner>
	{

	}

@end
