//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlickrKit/FlickrKit.h>

@interface AppController : NSObject <NSTableViewDelegate>
	{
	IBOutlet NSImageView* flickrPhotoView;
	IBOutlet NSTextField* flickrPhotoID;
	IBOutlet NSTextField* flickrPhotoTitle;
	IBOutlet NSProgressIndicator* flickrPhotoLoadingIndicator;

	IBOutlet NSTableView* flickrTagsView;
	IBOutlet NSTableView* flickrSetsView;
	IBOutlet NSTableView* flickrPoolsView;
	IBOutlet NSTableView* flickrGalleriesView;
	IBOutlet NSTableView* flickrCommentsView;

	IBOutlet NSButton* backButton;
	IBOutlet NSButton* forwardButton;

	NSDrawer* peopleDrawer;
	NSDrawer* exifDrawer;
	
	FlickrPhoto* flickrPhoto;
	FlickrPhoto* nextPhoto;
	FlickrPhoto* previousPhoto;
	NSMutableArray* photoHistory;
	NSInteger photoHistoryPosition;
	
	BOOL isFetching;
	BOOL isPeopleDrawerOpen;
	BOOL isEXIFDrawerOpen;
	}

- (IBAction)fetch:(id)sender;
- (IBAction)stepThroughHistory:(id)sender;
- (IBAction)togglePeopleDrawer:(id)sender;
- (IBAction)toggleEXIFDrawer:(id)sender;
- (IBAction)openPreferences:(id)sender;

- (void)addPhotoToHistory:(NSNotification*)aNotification;

@property(retain) FlickrPhoto* flickrPhoto;	
@property(assign) FlickrPhoto* nextPhoto;	
@property(assign) FlickrPhoto* previousPhoto;

@end
