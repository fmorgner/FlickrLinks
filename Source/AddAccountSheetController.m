//
//  AddAccountSheetController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "AddAccountSheetController.h"
#import <FlickrKit/FlickrKit.h>

@implementation AddAccountSheetController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)presentSheet
	{
	NSWindow* prefWindow = [NSApp keyWindow];
	[NSApp beginSheet:self.window modalForWindow:prefWindow modalDelegate:self didEndSelector:@selector(sheetDidEnd: returnCode: contextInfo:) contextInfo:NULL];
	}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
	{
	if(!returnCode)
		{
		FlickrAuthorizationController* authController = [FlickrAuthorizationController new];
		[authController authorizeForPermission:@"read"];
		[authController addObserver:self forKeyPath:@"authorizationURL" options:0 context:(__bridge void *)(sheet)];
		}
	else
		{
		[sheet orderOut:self];
		}
	}

- (IBAction)connectToFlickr:(id)sender
	{
	[NSApp endSheet:[self window] returnCode:0];
	}

- (IBAction)cancel:(id)sender
	{
	[NSApp endSheet:[self window] returnCode:1];
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"authorizationURL"])
		{
		[(NSWindow*)CFBridgingRelease(context) orderOut:self];
		}
	}
@end
