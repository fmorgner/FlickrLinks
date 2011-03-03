//
//  FlickrAPIResponse.h
//  FlickrLinks
//
//  Created by Felix Morgner on 03.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrAPIResponse : NSObject
	{
	NSString* status;
	NSString* dataFormat;
	NSData* unparsedData;
	NSArray* content;
	NSError* error;
	}

- (id)initWithData:(NSData*)theData;
+ (FlickrAPIResponse*)responseWithData:(NSData*)theData;

@property(nonatomic,readonly) NSString* status;
@property(nonatomic,readonly) NSString* dataFormat;
@property(nonatomic,readonly) NSData* unparsedData;
@property(nonatomic,readonly) NSArray* content;
@property(nonatomic,readonly) NSError* error;

@end
