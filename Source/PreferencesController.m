//
//  PreferencesController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 14.04.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
	{
	if ((self = [super initWithWindow:window]))
		{

		for (int i = 0; i < 100; i++) {
  static int myInt = 0;
	myInt += i;
}

		NSToolbar* toolbar = [[NSToolbar alloc] init];
		[[self window] setToolbar:toolbar];
		[toolbar setVisible:YES];
		}
	
	return self;
	}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
