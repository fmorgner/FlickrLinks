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

@synthesize personManager;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		personManager = [FlickrPersonManager sharedManager];
		}
	return self;
	}

- (void)awakeFromNib
	{
	AppDelegate* delegate = [NSApp delegate];
	[delegate addObserver:self forKeyPath:@"currentPhoto" options:(NSKeyValueObservingOptionOld) context:NULL];
	
	NSArrayController* arrayController = [NSArrayController new];
	[arrayController bind:@"contentArray" toObject:personManager withKeyPath:@"people" options:nil];

	NSDictionary* bindingOptions = [NSDictionary dictionaryWithObject:@"N/A" forKey:NSNullPlaceholderBindingOption];

	NSTableColumn* tableColumn = nil;
	tableColumn = [tableView tableColumnWithIdentifier:@"id"];
	[tableColumn bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.ID" options:bindingOptions];	
	tableColumn = [tableView tableColumnWithIdentifier:@"fullname"];
	[tableColumn bind:@"value" toObject:arrayController withKeyPath:@"arrangedObjects.username" options:bindingOptions];	
	[arrayController release];
	}

- (void)dealloc
	{
	[super dealloc];
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"currentPhoto"])
		{
		FlickrPhoto* currentPhoto = [(AppDelegate*)[NSApp delegate] currentPhoto];
		if([[change objectForKey:NSKeyValueChangeOldKey] isKindOfClass:[FlickrPhoto class]])
			{
			FlickrPhoto* oldPhoto = [change objectForKey:NSKeyValueChangeOldKey];
		
			if(oldPhoto)
				{
				id info = [oldPhoto observationInfo];
				NSArray* observances = [info valueForKey:@"observances"];
				for(id observance in observances)
					{
					if([observance valueForKey:@"observer"] == self)
						[oldPhoto removeObserver:self forKeyPath:@"owner"];
					}
				}
			}	
		[currentPhoto addObserver:self forKeyPath:@"owner" options:NSKeyValueObservingOptionNew context:NULL];
		}
	else if([keyPath isEqualToString:@"owner"])
		{
		FlickrPhoto* currentPhoto = [(AppDelegate*)[NSApp delegate] currentPhoto];
		FlickrPerson* owner = [currentPhoto owner];
		NSUInteger index = [[personManager people] indexOfObject:owner];
		NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:index];
		[tableView selectRowIndexes:indexSet byExtendingSelection:NO];
		}
	}
@end
