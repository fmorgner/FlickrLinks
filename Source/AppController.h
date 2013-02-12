//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlickrKit/FlickrKit.h>

@class PeopleViewController;
@class ExifViewController;

@interface AppController : NSObject <NSTableViewDelegate>
	{
	IBOutlet NSImageView* flickrPhotoView;

	IBOutlet NSTextField* flickrPhotoID;
	IBOutlet NSTextField* flickrPhotoTitle;

	IBOutlet NSProgressIndicator* statusIndicator;

	IBOutlet NSTableView* flickrTagsView;
	IBOutlet NSTableView* flickrSetsView;
	IBOutlet NSTableView* flickrPoolsView;
	IBOutlet NSTableView* flickrGalleriesView;
	IBOutlet NSTableView* flickrCommentsView;

	IBOutlet NSButton* backButton;
	IBOutlet NSButton* forwardButton;
	}

- (IBAction)fetch:(id)sender;
- (IBAction)stepThroughHistory:(id)sender;
- (IBAction)togglePeopleDrawer:(id)sender;
- (IBAction)toggleEXIFDrawer:(id)sender;
- (IBAction)openPreferences:(id)sender;

@property(strong) FKPhoto* flickrPhoto;
@property(strong) FKPhoto* nextPhoto;
@property(strong) FKPhoto* previousPhoto;

@property(strong) NSDrawer* peopleDrawer;
@property(strong) NSDrawer* exifDrawer;

@property(strong)	NSMutableArray* photoHistory;

@property(assign)	NSInteger photoHistoryPosition;

@property(assign) BOOL isFetching;
@property(assign) BOOL isPeopleDrawerOpen;
@property(assign) BOOL isEXIFDrawerOpen;

@property(strong) PeopleViewController* peopleViewController;
@property(strong) ExifViewController* exifViewController;
@end
