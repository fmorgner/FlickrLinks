//
//  FlickrLinksController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppController.h"
#import "PeopleViewController.h"
#import "ExifViewController.h"
#import "AppDelegate.h"

#define MAX_VALUE 100.0

static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation AppController

@synthesize flickrPhoto;

- (id)init
	{
	if((self = [super init]))
		{
		photoHistory = [NSMutableArray new];
		photoHistoryPosition = 0;
		isPeopleDrawerOpen = NO;
		isEXIFDrawerOpen = NO;
		}
	return self;
	}

- (void)dealloc
	{
	[photoHistory release];
	[flickrPhoto release];
	[super dealloc];
	}

- (void)awakeFromNib
	{
	[flickrPhotoLoadingIndicator setMaxValue:MAX_VALUE];
	[backButton setEnabled:NO];
	[forwardButton setEnabled:NO];
	[[flickrPhotoID window] makeFirstResponder:flickrPhotoID];
	[(AppDelegate*)[NSApp delegate] bind:@"currentPhoto" toObject:self withKeyPath:@"flickrPhoto" options:nil];
	}

- (IBAction) goBack:(id)sender
	{
	photoHistoryPosition--;
	flickrPhoto = [photoHistory objectAtIndex:photoHistoryPosition];
	}
	
- (IBAction) goForward:(id)sender
	{
	photoHistoryPosition++;
	flickrPhoto = [photoHistory objectAtIndex:photoHistoryPosition];
	}

#pragma mark - Drawer Toggeling

- (IBAction) togglePeopleDrawer:(id)sender
	{
	if(!peopleDrawer)
		{
		peopleDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(300.0, 550.0) preferredEdge:NSMaxXEdge];
		PeopleViewController* viewController = [[PeopleViewController alloc] initWithNibName:@"PeopleListView" bundle:[NSBundle mainBundle]];
		[peopleDrawer setContentView:viewController.view];
		[peopleDrawer setParentWindow:[NSApp mainWindow]];
		[viewController release];
		}
		
	if(!isPeopleDrawerOpen)
		{
		[peopleDrawer open];
		isPeopleDrawerOpen = YES;
		}
	else
		{
		[peopleDrawer close];
		isPeopleDrawerOpen = NO;
		}
	}

- (IBAction) toggleEXIFDrawer:(id)sender
	{
	[flickrPhoto fetchEXIFInformation];
		
	if(!exifDrawer)
		{
		exifDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(500, 150) preferredEdge:NSMinYEdge];
		ExifViewController* viewController = [[ExifViewController alloc] initWithNibName:@"ExifView" bundle:[NSBundle mainBundle]];
		[exifDrawer setContentView:viewController.view];
		[exifDrawer setParentWindow:[NSApp mainWindow]];
		[viewController release];
		}
		
	if(!isEXIFDrawerOpen)
		{
		[exifDrawer open];
		isEXIFDrawerOpen = YES;
		}
	else
		{
		[exifDrawer close];
		isEXIFDrawerOpen = NO;
		}
	}

- (IBAction) fetch:(id)sender
	{
	if([[flickrPhotoID stringValue] isEqualToString:@""] || isFetching)
		return;
	
	NSString* photoID = [flickrPhotoID stringValue];
	self.flickrPhoto = [FlickrPhoto photoWithID:photoID];
	[flickrPhoto fetchInformation:kFlickrPhotoInformationAll];
	[flickrPhoto fetchImageOfSize:kFlickrImageSizeMedium];
	}

@end
