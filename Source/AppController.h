//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlickrKit/FlickrKit.h>

@interface AppController : NSObject
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
	NSMutableArray* photoHistory;
	NSInteger photoHistoryPosition;
	
	BOOL isFetching;
	BOOL isPeopleDrawerOpen;
	BOOL isEXIFDrawerOpen;
	}

- (IBAction) fetch:(id)sender;
- (IBAction) goBack:(id)sender;
- (IBAction) goForward:(id)sender;
- (IBAction) togglePeopleDrawer:(id)sender;
- (IBAction) toggleEXIFDrawer:(id)sender;

@property(nonatomic,retain) FlickrPhoto* flickrPhoto;

@end
