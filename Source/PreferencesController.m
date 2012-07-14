//
//  PreferencesController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 14.04.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "PreferencesController.h"
#import "AccountPreferenceViewController.h"
#import "AppDelegate.h"

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
	{
	if ((self = [super initWithWindow:window]))
		{
		}
	
	return self;
	}

- (void)awakeFromNib
	{
	}


- (void)windowDidLoad
	{
  [super windowDidLoad];
	}

- (IBAction)showPreference:(id)sender
	{
	if(([sender isKindOfClass:[NSToolbarItem class]] && [(NSToolbarItem*)sender tag] == 2) || ([sender isKindOfClass:[NSString class]] && [(NSString*)sender isEqualToString:@"user"]))
		{
  	AccountPreferenceViewController* accountPreferenceViewController = [[AccountPreferenceViewController alloc] initWithNibName:@"AccountPreferenceViewController" bundle:[NSBundle mainBundle]];
		NSRect currentContentSize = [[self.window contentView] bounds];
		NSRect frame = [self.window frame];
		NSRect newContentSize = [[accountPreferenceViewController view] bounds];
		
		CGFloat deltaHeight = currentContentSize.size.height - newContentSize.size.height;
		CGFloat deltaWidth = currentContentSize.size.width - newContentSize.size.width;
		
		frame.origin.y += deltaHeight;
		frame.size.height -= deltaHeight;
		frame.size.width -= deltaWidth;

		[self.window setFrame:frame display:YES animate:YES];
		self.window.contentView = accountPreferenceViewController.view;
		}
	}

@end
