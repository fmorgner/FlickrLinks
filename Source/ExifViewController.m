//
//  ExifViewController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "ExifViewController.h"
#import "AppController.h"

@implementation ExifViewController

- (void)awakeFromNib
	{
	NSArrayController* exifArrayController = [[NSArrayController alloc] init];
	[exifArrayController bind:@"contentArray" toObject:[NSApp delegate] withKeyPath:@"currentPhoto.exifTags" options:nil];
	
	NSTableColumn* labelColumn = [exifTable tableColumnWithIdentifier:@"label"];
	NSTableColumn* valueColumn = [exifTable tableColumnWithIdentifier:@"value"];
	
	[labelColumn bind:@"value" toObject:exifArrayController withKeyPath:@"arrangedObjects.label" options:nil];
	[valueColumn bind:@"value" toObject:exifArrayController withKeyPath:@"arrangedObjects.value" options:nil];
	}


@end
