//
//  FlickrLinksAppDelegate.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <FlickrKit/FlickrKit.h>
#import "apiKey.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	FlickrPhoto* currentPhoto;
}

- (NSString*)apiKey;
- (NSString*)apiSecret;

@property (assign) IBOutlet NSWindow *window;
@property (assign) FlickrPhoto* currentPhoto;

@end
