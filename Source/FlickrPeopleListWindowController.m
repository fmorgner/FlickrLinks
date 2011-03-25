//
//  FlickrPeopleListWindowController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 25.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrPeopleListWindowController.h"

@implementation FlickrPeopleListWindowController

@synthesize peopleArray;

- (id)initWithWindow:(NSWindow *)window
	{
	if ((self = [super initWithWindow:window]))
		{
    }
	return self;
	}

- (id)initWithWindowNibName:(NSString *)windowNibName
	{
	if ((self = [super initWithWindowNibName:windowNibName]))
		{
		peopleArray = [[FlickrPersonManager sharedManager] people];		
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
	}

@end
