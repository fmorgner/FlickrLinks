//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FlickrKit/FlickrKit.h>
#import "FlickrLinksAppDelegate.h"

@interface AppController : NSObject <NSTableViewDataSource,NSTextFieldDelegate>
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
	}

- (IBAction) fetch:(id)sender;
- (IBAction) goBack:(id)sender;
- (IBAction) goForward:(id)sender;
- (IBAction) openPeopleList:(id)sender;
- (void)updateUI;


@property(nonatomic,retain) FlickrPhoto* flickrPhoto;

@end
