//
//  FlickrLinksAppDelegate.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
	{
	NSUserDefaults* userDefaults = [[NSUserDefaultsController sharedUserDefaultsController] defaults];
	NSString* userID = [userDefaults stringForKey:@"userID"];
	
	if(userID)
		self.keychainItem = [EMGenericKeychainItem genericKeychainItemForService:@"FlickrLinks" withUsername:userID];
		
	__weak FKAuthorizationContext* authContext = [FKAuthorizationContext sharedContext];
	[authContext setKey:apiKey];
	[authContext setSecret:apiSecret];
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
