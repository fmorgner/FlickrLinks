//
//  FlickrPeopleListWindowController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 25.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <FlickrKit/FlickrKit.h>


@interface PeopleViewController : NSViewController
	{
	FlickrPersonManager* personManager;
	IBOutlet NSTableView* tableView;
	}

@property(nonatomic, assign) FlickrPersonManager* personManager;

@end
