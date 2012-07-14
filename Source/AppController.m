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
#import "PreferencesController.h"
#import "AppDelegate.h"

#define MAX_VALUE 100.0

static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation AppController

- (id)init
	{
	if((self = [super init]))
		{
		_photoHistory = [NSMutableArray array];
		_photoHistoryPosition = 0;
		_isPeopleDrawerOpen = NO;
		_isEXIFDrawerOpen = NO;
		_previousPhoto = nil;
		_nextPhoto = nil;
		_exifViewController = [[ExifViewController alloc] initWithNibName:@"ExifView" bundle:[NSBundle mainBundle]];
		}
	return self;
	}

- (void)awakeFromNib
	{
	_exifDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(500.0, 150.0) preferredEdge:NSMinYEdge];
	[_exifDrawer setContentView:_exifViewController.view];

	_peopleDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(300.0, 550.0) preferredEdge:NSMaxXEdge];
	[_peopleDrawer setContentView:[[PeopleViewController alloc] initWithNibName:@"PeopleListView" bundle:[NSBundle mainBundle]].view];

	[statusIndicator setMaxValue:MAX_VALUE];
	[[flickrPhotoID window] makeFirstResponder:flickrPhotoID];
	[(AppDelegate*)[NSApp delegate] bind:@"currentPhoto" toObject:self withKeyPath:@"flickrPhoto" options:nil];
	}
#pragma mark - History browsing

- (IBAction)stepThroughHistory:(id)sender
	{
	if([(NSButton*)sender tag] == 1)
		{
		self.flickrPhoto = _previousPhoto;
		}
	else if([(NSButton*)sender tag] == 2)
		{
		self.flickrPhoto = _nextPhoto;
		}

	[flickrPhotoID setStringValue:_flickrPhoto.ID];
	NSUInteger index = [_photoHistory indexOfObject:_flickrPhoto];
	self.previousPhoto = (index) ? [_photoHistory objectAtIndex:(index - 1)] : 0;
	self.nextPhoto = (index < ([_photoHistory count] - 1)) ? [_photoHistory objectAtIndex:(index + 1 )] : nil;
	}

#pragma mark - Drawer Toggeling

- (IBAction) togglePeopleDrawer:(id)sender
	{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[_peopleDrawer setParentWindow:[NSApp mainWindow]];
	});
	
	[_peopleDrawer toggle:sender];
	}

- (IBAction) toggleEXIFDrawer:(id)sender
	{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[_exifDrawer setParentWindow:[NSApp mainWindow]];
	});
	
	[_exifDrawer toggle:sender];
	}

- (IBAction)openPreferences:(id)sender
	{
	PreferencesController* preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
	[[preferencesController window] makeKeyAndOrderFront:self];
	[preferencesController showPreference:@"user"];
	}

- (IBAction) fetch:(id)sender
	{
	if([[flickrPhotoID stringValue] isEqualToString:@""] || _isFetching)
		return;
	
	NSPredicate* searchPredicate = [NSPredicate predicateWithFormat:@"ID like %@", [flickrPhotoID stringValue]];
	if([[_photoHistory filteredArrayUsingPredicate:searchPredicate] count])
		return;
		
	_flickrPhoto = [FlickrPhoto photoWithID:[flickrPhotoID stringValue]];
	
	__weak AppController* appController = self;
	
	[[NSNotificationCenter defaultCenter] addObserverForName:FlickrPhotoDidChangeNotification object:_flickrPhoto queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		[_photoHistory addObject:[note object]];
		appController.flickrPhoto = [note object];
		appController.previousPhoto = ((NSInteger)[_photoHistory count] - 2 < 0) ? nil : [_photoHistory objectAtIndex:[_photoHistory indexOfObject:[note object]] - 1];
	}];

	[_flickrPhoto fetchInformation:kFlickrPhotoInformationAll];
	[_flickrPhoto fetchImageOfSize:kFlickrImageSizeMedium];
	}

#pragma mark - TableView stuff

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
	{
	CGFloat width = [(NSTableColumn*)[[tableView tableColumns] objectAtIndex:0] width];
	NSString* string = [[_flickrPhoto.comments objectAtIndex:row] rawText];
	
	NSCell* dataCell = [[NSCell alloc] initTextCell:string];
	[dataCell setWraps:YES];
	[dataCell setFont:[[[[tableView tableColumns] objectAtIndex:0] dataCell] font]];
	
	return [dataCell cellSizeForBounds:NSMakeRect(0, 0, width, FLT_MAX)].height;
	}

@end
