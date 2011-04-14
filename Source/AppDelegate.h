//
//  FlickrLinksAppDelegate.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "apiKey.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
}

- (NSString*)apiKey;

@property (assign) IBOutlet NSWindow *window;

@end
