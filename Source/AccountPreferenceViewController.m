//
//  AccountPreferenceViewController.m
//  
//
//  Created by Felix Morgner on 04.05.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "AccountPreferenceViewController.h"
#import "AddAccountSheetController.h"
#import "AppDelegate.h"
#import "EMKeychainItem.h"
#import "BoolValueTransformer.h"
#import <FlickrKit/FlickrKit.h>

@implementation AccountPreferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiceAuthenticationToken:) name:FlickrAuthorizationControllerDidReceiveToken object:nil];
    }
    
  return self;
	}

- (void)awakeFromNib
	{
	EMKeychainItem* keychainItem = [[NSApp delegate] valueForKey:@"keychainItem"];

	if(keychainItem)
		{
		BoolValueTransformer* boolValueTransformer = [[BoolValueTransformer alloc] init];
		[NSValueTransformer setValueTransformer:boolValueTransformer forName:@"BoolValueTransformer"];
		
		FlickrPerson* user = [FlickrPerson personWithID:[keychainItem username]];
		NSObjectController* userController = [[NSObjectController alloc] initWithContent:user];
		[userController bind:@"content" toObject:user withKeyPath:@"self" options:nil];
		
		[usernameField bind:@"stringValue" toObject:userController withKeyPath:@"selection.username" options:nil];
		[proStatusField bind:@"stringValue" toObject:userController withKeyPath:@"selection.proStatus" options:@{NSValueTransformerNameBindingOption: @"BoolValueTransformer"}];
		[photoCountField bind:@"stringValue" toObject:userController withKeyPath:@"selection.photoCount" options:nil];
		}
	else
		{
		AddAccountSheetController* sheetController = [[AddAccountSheetController alloc] initWithWindowNibName:@"AddAccountSheet"];
		[sheetController presentSheet];
		}
	}


- (IBAction)viewInSafari:(id)sender
	{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.flickr.com/people/%@", [usernameField stringValue]]]];
	}
	
- (IBAction)removeAccount:(id)sender
	{
	
	}

- (void)didReceiceAuthenticationToken:(NSNotification*)aNotification
	{
	FlickrToken* receivedToken = [[aNotification userInfo] valueForKey:FlickrTokenKey];
	EMGenericKeychainItem* keychainItem = [EMGenericKeychainItem addGenericKeychainItemForService:@"FlickrLinks" withUsername:receivedToken.user.ID password:receivedToken.tokenString];
	if(keychainItem)
		{
		NSUserDefaults* userDefaults =  [[NSUserDefaultsController sharedUserDefaultsController] defaults];
		[userDefaults setObject:receivedToken.user.ID forKey:@"userID"];
		[userDefaults synchronize];
		}
	}
@end
