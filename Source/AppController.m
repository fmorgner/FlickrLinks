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

@synthesize flickrPhoto, nextPhoto, previousPhoto;

- (id)init
	{
	if((self = [super init]))
		{
		photoHistory = [NSMutableArray new];
		photoHistoryPosition = 0;
		isPeopleDrawerOpen = NO;
		isEXIFDrawerOpen = NO;
		previousPhoto = nil;
		nextPhoto = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPhotoToHistory:) name:FlickrPhotoDidFinishLoadingNotification object:nil];
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
	[[flickrPhotoID window] makeFirstResponder:flickrPhotoID];
	[(AppDelegate*)[NSApp delegate] bind:@"currentPhoto" toObject:self withKeyPath:@"flickrPhoto" options:nil];
	}
#pragma mark - History browsing

- (IBAction)stepThroughHistory:(id)sender
	{
	if([(NSButton*)sender tag] == 1)
		{
		self.flickrPhoto = previousPhoto;
		}
	else if([(NSButton*)sender tag] == 2)
		{
		self.flickrPhoto = nextPhoto;
		}

	[flickrPhotoID setStringValue:flickrPhoto.ID];
	NSUInteger index = [photoHistory indexOfObject:flickrPhoto];
	self.previousPhoto = (index) ? [photoHistory objectAtIndex:(index - 1)] : 0;
	self.nextPhoto = (index < ([photoHistory count] - 1)) ? [photoHistory objectAtIndex:(index + 1 )] : nil;
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
//		[viewController release];
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
	
	NSPredicate* searchPredicate = [NSPredicate predicateWithFormat:@"ID like %@", [flickrPhotoID stringValue]];
	if([[photoHistory filteredArrayUsingPredicate:searchPredicate] count])
		return;
		
	NSString* photoID = [flickrPhotoID stringValue];
	self.flickrPhoto = [FlickrPhoto photoWithID:photoID];
	[flickrPhoto fetchInformation:kFlickrPhotoInformationAll];
	[flickrPhoto fetchImageOfSize:kFlickrImageSizeMedium];
	}

#pragma mark Notification Handling

- (void)addPhotoToHistory:(NSNotification*)aNotification
	{
	[photoHistory addObject:[aNotification object]];
	self.previousPhoto = ((NSInteger)[photoHistory count] - 2 < 0) ? nil : [photoHistory objectAtIndex:[photoHistory indexOfObject:[aNotification object]] - 1];
	}

#pragma mark - TableView stuff

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
	{
	CGFloat width = [[[tableView tableColumns] objectAtIndex:0] width];
	NSString* string = [[flickrPhoto.comments objectAtIndex:row] rawText];
	
	NSCell* dataCell = [[[NSCell alloc] initTextCell:string] autorelease];
	[dataCell setWraps:YES];
	[dataCell setFont:[[[[tableView tableColumns] objectAtIndex:0] dataCell] font]];
	
	return [dataCell cellSizeForBounds:NSMakeRect(0, 0, width, FLT_MAX)].height;
	}

@end
