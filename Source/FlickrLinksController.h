//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPhoto.h"
#import "apiKey.h"

@interface FlickrLinksController : NSObject <NSTableViewDataSource>
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

	FlickrPhoto* flickrPhoto;
	}

- (IBAction) fetch:(id)sender;

@property(nonatomic,retain) FlickrPhoto* flickrPhoto;

@end
