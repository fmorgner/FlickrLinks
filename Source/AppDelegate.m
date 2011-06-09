//
//  FlickrLinksAppDelegate.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize currentPhoto;
@synthesize keychainItem;
@synthesize preferencesWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
	NSUserDefaults* userDefaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
	NSString* username = [userDefaults stringForKey:@"username"];
	
	if(username)
		self.keychainItem = [EMGenericKeychainItem genericKeychainItemForService:@"ch.felixmorgner.FlickrLinks" withUsername:username];
	}

- (NSString*)apiKey
	{
	return apiKey;
	}

- (NSString*)apiSecret
	{
	return apiSecret;
	}

@end
