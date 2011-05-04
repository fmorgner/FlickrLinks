//
//  AccountPreferenceViewController.h
//  
//
//  Created by Felix Morgner on 04.05.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AccountPreferenceViewController : NSViewController
	{
	@private
  IBOutlet NSTextField* usernameField;
	IBOutlet NSTextField* photoCountField;
	IBOutlet NSTextField* photosetCountField;
	IBOutlet NSTextField* proStatusField;
	}

- (IBAction)viewInSafari:(id)sender;
- (IBAction)removeAccount:(id)sender;

@end
