//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlickrKit/FlickrKit.h>
#import "AppDelegate.h"

#ifdef __MAC_10_7
@interface AppController : NSObject <NSTableViewDataSource,NSTextFieldDelegate,NSURLConnectionDelegate>
#else
@interface AppController : NSObject <NSTableViewDataSource,NSTextFieldDelegate>
#endif
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
	
	IBOutlet NSImageView *firstLicenseView;
	IBOutlet NSImageView *secondLicenseView;
	IBOutlet NSImageView *thirdLicenseView;
	IBOutlet NSImageView *fourthLicenseView;

	IBOutlet NSButton* backButton;
	IBOutlet NSButton* forwardButton;

	NSDrawer* peopleDrawer;
	NSDrawer* exifDrawer;
	
	NSURLRequest* infoRequest;
	NSURLRequest* contextsRequest;
	NSURLRequest* commentsRequest;
	NSURLRequest* favoritesRequest;
	NSURLRequest* galleriesRequest;
	NSURLRequest* photoRequest;
	NSURLRequest* activeRequest;
	NSURLRequest* sizesRequest;

	NSMutableData* fetchedData;
	NSXMLDocument* xmlDocument;	

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
- (void)updateUI;


@property(nonatomic,retain) FlickrPhoto* flickrPhoto;

@end
