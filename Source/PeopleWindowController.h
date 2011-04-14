//
//  FlickrPeopleListWindowController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 25.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <FlickrKit/FlickrKit.h>


@interface PeopleWindowController : NSWindowController
	{
	NSArray* peopleArray;
	IBOutlet NSTableView* tableView;
	}

@property(nonatomic, retain) NSArray* peopleArray;

@end
