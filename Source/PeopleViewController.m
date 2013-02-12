//
//  FlickrPeopleListWindowController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 25.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "PeopleViewController.h"
#import "AppDelegate.h"

@implementation PeopleViewController

- (void)awakeFromNib
	{
	NSArrayController* peopleController = [NSArrayController new];
	[peopleController bind:@"contentArray" toObject:[FKPersonManager sharedManager] withKeyPath:@"people" options:nil];

	NSObjectController* ownerController = [[NSObjectController alloc] init];
	[ownerController bind:@"content" toObject:[NSApp delegate] withKeyPath:@"currentPhoto.owner" options:nil];

	[peopleController bind:@"selectedObjects" toObject:ownerController withKeyPath:@"selectedObjects" options:nil];

	NSTableColumn* tableColumn = nil;

	tableColumn = [_tableView tableColumnWithIdentifier:@"id"];
	[tableColumn bind:@"value" toObject:peopleController withKeyPath:@"arrangedObjects.ID" options:@{NSNullPlaceholderBindingOption : @"N/A"}];	
	tableColumn = [_tableView tableColumnWithIdentifier:@"fullname"];
	[tableColumn bind:@"value" toObject:peopleController withKeyPath:@"arrangedObjects.username" options:@{NSNullPlaceholderBindingOption : @"N/A"}];
	
	}

@end
