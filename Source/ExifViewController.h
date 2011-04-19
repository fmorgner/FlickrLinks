//
//  ExifViewController.h
//  FlickrLinks
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ExifViewController : NSViewController
	{
	IBOutlet NSTableView* exifTable;
	IBOutlet NSTableColumn* keyColumn;
	IBOutlet NSTableColumn* valueColumn;
	}

@end
