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

@implementation AccountPreferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
    }
    
  return self;
	}

- (void)awakeFromNib
	{
	EMKeychainItem* keychainItem = [[NSApp delegate] valueForKey:@"keychainItem"];

	if(keychainItem)
		{
		usernameField.stringValue = [keychainItem username];
		}
	else
		{
		AddAccountSheetController* sheetController = [[AddAccountSheetController alloc] initWithWindowNibName:@"AddAccountSheet"];
		[sheetController presentSheet];
		}
	}

- (void)dealloc
	{
  [super dealloc];
	}

- (IBAction)viewInSafari:(id)sender
	{
	
	}
	
- (IBAction)removeAccount:(id)sender
	{
	
	}

@end
