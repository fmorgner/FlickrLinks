//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrPhoto : NSObject
	{
	NSImage* image;
	NSString* title;
	NSInteger commentCount;
	
	NSArray* sets;
	NSArray* pools;
	NSArray* tags;
	NSArray* comments;
	NSArray* favorites;
	NSArray* galleries;
	
	NSString* ID;
	}


@property(nonatomic, retain) NSImage* image;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, assign) NSInteger commentCount;

@property(nonatomic, retain) NSArray* sets;
@property(nonatomic, retain) NSArray* pools;
@property(nonatomic, retain) NSArray* tags;
@property(nonatomic, retain) NSArray* comments;
@property(nonatomic, retain) NSArray* favorites;
@property(nonatomic, retain) NSArray* galleries;

@property(nonatomic, retain) NSString* ID;

@end
