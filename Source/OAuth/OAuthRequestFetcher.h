//
//  OAuthRequestFetcher.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 21.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthRequestFetcher : NSObject
	{
	NSURLRequest* request;
	NSURLConnection* connection;
	NSMutableData* receivedData;
	void (^completionHandler)(id);
	}

- (void)fetchRequest:(NSURLRequest*)aRequest completionHandler:(void (^)(id fetchResult))block;

@property(nonatomic,retain) NSURLRequest* request;
@property(nonatomic,retain) NSURLConnection* connection;
@property(nonatomic,retain) NSMutableData* receivedData;
@property(nonatomic,copy) void (^completionHandler)(id);


@end
