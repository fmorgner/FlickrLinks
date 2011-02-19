//
//  FlickrLinksController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrLinksController : NSObject
	{
	IBOutlet NSImageView* flickrPhotoView;
	IBOutlet NSTextField* flickrPhotoID;
	IBOutlet NSProgressIndicator* flickrPhotoLoadingIndicator;
	IBOutlet NSTableView* flickrPhotoInformationView;
	}

- (IBAction) fetch:(id)sender;

@end
