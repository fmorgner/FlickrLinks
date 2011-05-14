//
//  AddAccountSheetController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "AddAccountSheetController.h"


@implementation AddAccountSheetController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)connectToFlickr:(id)sender
	{
	
	}

- (IBAction)cancel:(id)sender {
}
@end
