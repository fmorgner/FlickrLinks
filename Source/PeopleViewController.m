//
//  FlickrPeopleListWindowController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 25.03.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "PeopleViewController.h"

@implementation PeopleViewController

@synthesize peopleArray;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		
		}
	return self;
	}

- (void)awakeFromNib
	{
	NSArrayController* arrayController = [NSArrayController new];
	[arrayController bind:@"contentArray" toObject:[FlickrPersonManager sharedManager] withKeyPath:@"people" options:nil];

	NSDictionary* bindingOptions = [NSDictionary dictionaryWithObject:@"N/A" forKey:NSNullPlaceholderBindingOption];

	NSTableColumn* tableColumn = nil;
	tableColumn = [tableView tableColumnWithIdentifier:@"id"];
	[tableColumn bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.ID" options:bindingOptions];	
	tableColumn = [tableView tableColumnWithIdentifier:@"fullname"];
	[tableColumn bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.name" options:bindingOptions];	
	[arrayController release];
	}

- (void)dealloc
	{
	[super dealloc];
	}

@end
