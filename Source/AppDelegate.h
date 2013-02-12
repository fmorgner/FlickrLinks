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
#import "EMKeychainItem.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (NSString*)apiKey;
- (NSString*)apiSecret;

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) NSWindow* preferencesWindow;
@property (weak) FKPhoto* currentPhoto;
@property (strong) EMGenericKeychainItem* keychainItem;

@end
