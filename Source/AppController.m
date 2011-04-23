//
//  FlickrLinksController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppController.h"
#import "PeopleViewController.h"
#import "ExifViewController.h"

#define MAX_VALUE 100.0

static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation AppController

@synthesize flickrPhoto;

- (id)init
	{
	if((self = [super init]))
		{
		photoHistory = [NSMutableArray new];
		photoHistoryPosition = 0;
		fetchedData = [[NSMutableData alloc] init];
		isPeopleDrawerOpen = NO;
		isEXIFDrawerOpen = NO;
		}
	return self;
	}

- (void)awakeFromNib
	{
	[flickrPhotoLoadingIndicator setMaxValue:MAX_VALUE];
	[backButton setEnabled:NO];
	[forwardButton setEnabled:NO];
	[[flickrPhotoID window] makeFirstResponder:flickrPhotoID];
	
	//---- Bindings
	
	// This is the object controller for the flickrPhoto ivar
	NSObjectController* photoController = [NSObjectController new];
	[photoController bind:@"content" toObject:self withKeyPath:@"flickrPhoto" options:nil];

	// Here we're binding the value of only column of the tags tableview to the name property of each
	// of the tags of the current photo.
	NSArrayController* tagsController = [NSArrayController new];
	[tagsController bind:@"contentArray" toObject:photoController withKeyPath:@"selection.tags" options:nil];
	[[[flickrTagsView tableColumns] lastObject] bind:@"value" toObject:tagsController withKeyPath:@"arrangedObjects.name" options:nil];
	[tagsController release];

	// Here we're binding the value of only column of the sets tableview to the description property of each
	// of the sets of the current photo.
	NSArrayController* setsController = [NSArrayController new];
	[setsController bind:@"contentArray" toObject:photoController withKeyPath:@"selection.sets" options:nil];
	[[[flickrSetsView tableColumns] lastObject] bind:@"value" toObject:setsController withKeyPath:@"arrangedObjects.description" options:nil];
	[setsController release];
	
	// Here we're binding the value of only column of the pools tableview to the description property of each
	// of the pools of the current photo.
	NSArrayController* poolsController = [NSArrayController new];
	[poolsController bind:@"contentArray" toObject:photoController withKeyPath:@"selection.pools" options:nil];
	[[[flickrSetsView tableColumns] lastObject] bind:@"value" toObject:poolsController withKeyPath:@"arrangedObjects.description" options:nil];
	[poolsController release];
	
	// Here we're binding the value of only column of the galleries tableview to the description property of each
	// of the galleries of the current photo.
	NSArrayController* galleriesController = [NSArrayController new];
	[galleriesController bind:@"contentArray" toObject:photoController withKeyPath:@"selection.galleries" options:nil];
	[[[flickrSetsView tableColumns] lastObject] bind:@"value" toObject:galleriesController withKeyPath:@"arrangedObjects.description" options:nil];
	[galleriesController release];
	
	}

- (void)updateUI
	{
	([photoHistory count] && photoHistoryPosition) ? [backButton setEnabled:YES] : [backButton setEnabled:NO];	
	([photoHistory count] && photoHistoryPosition + 1 < [photoHistory count]) ? [forwardButton setEnabled:YES] : [forwardButton setEnabled:NO];	

	NSArray* licenseImages = [[FlickrKitResourceManager sharedManager] imagesForLicense:flickrPhoto.license];
	
	switch([licenseImages count])
		{
		case 1:
			[secondLicenseView setImage:nil];
			[thirdLicenseView setImage:nil];
			[fourthLicenseView setImage:nil];
			[firstLicenseView setImage:[licenseImages objectAtIndex:0]];
			break;
		case 2:
			[thirdLicenseView setImage:nil];
			[fourthLicenseView setImage:nil];
			[firstLicenseView setImage:[licenseImages objectAtIndex:1]];
			[secondLicenseView setImage:[licenseImages objectAtIndex:0]];
			break;
		case 3:
			[fourthLicenseView setImage:nil];
			[firstLicenseView setImage:[licenseImages objectAtIndex:2]];
			[secondLicenseView setImage:[licenseImages objectAtIndex:1]];
			[thirdLicenseView setImage:[licenseImages objectAtIndex:0]];
			break;
		case 4:
			[firstLicenseView setImage:[licenseImages objectAtIndex:3]];
			[secondLicenseView setImage:[licenseImages objectAtIndex:2]];
			[thirdLicenseView setImage:[licenseImages objectAtIndex:1]];
			[fourthLicenseView setImage:[licenseImages objectAtIndex:0]];
			break;
		default:
			break;
		}

	[flickrPhotoTitle setStringValue:[NSString stringWithFormat:@"%@ (%@)", flickrPhoto.title, flickrPhoto.ID]];
	[flickrTagsView reloadData];
	[flickrSetsView reloadData];
	[flickrPoolsView reloadData];
	[flickrGalleriesView reloadData];
	[flickrCommentsView reloadData];
	[flickrPhotoView setImage:[flickrPhoto image]];
	[flickrPhotoID setStringValue:flickrPhoto.ID];
	}

- (IBAction) goBack:(id)sender
	{
	photoHistoryPosition--;
	flickrPhoto = [photoHistory objectAtIndex:photoHistoryPosition];
	[self updateUI];
	}
	
- (IBAction) goForward:(id)sender
	{
	photoHistoryPosition++;
	flickrPhoto = [photoHistory objectAtIndex:photoHistoryPosition];
	[self updateUI];
	}

#pragma mark - Drawer Toggeling

- (IBAction) togglePeopleDrawer:(id)sender
	{
	if(!peopleDrawer)
		{
		peopleDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(200.0, 550.0) preferredEdge:NSMaxXEdge];
		PeopleViewController* viewController = [[PeopleViewController alloc] initWithNibName:@"PeopleListView" bundle:[NSBundle mainBundle]];
		[peopleDrawer setContentView:viewController.view];
		[peopleDrawer setParentWindow:[NSApp mainWindow]];
		}
		
	if(!isPeopleDrawerOpen)
		{
		[peopleDrawer open];
		isPeopleDrawerOpen = YES;
		}
	else
		{
		[peopleDrawer close];
		isPeopleDrawerOpen = NO;
		}
	}

- (IBAction) toggleEXIFDrawer:(id)sender
	{
	[flickrPhoto fetchEXIFInformation];
		
	if(!exifDrawer)
		{
		exifDrawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(500, 150) preferredEdge:NSMinYEdge];
		ExifViewController* viewController = [[ExifViewController alloc] initWithNibName:@"ExifView" bundle:[NSBundle mainBundle]];
		[exifDrawer setContentView:viewController.view];
		[exifDrawer setParentWindow:[NSApp mainWindow]];
		}
		
	if(!isEXIFDrawerOpen)
		{
		[exifDrawer open];
		isEXIFDrawerOpen = YES;
		}
	else
		{
		[exifDrawer close];
		isEXIFDrawerOpen = NO;
		}
	}


- (IBAction) fetch:(id)sender
	{
	if([[flickrPhotoID stringValue] isEqualToString:@""] || isFetching)
		return;
	
	isFetching = YES;
	
	NSString* photoID = [flickrPhotoID stringValue];
	[flickrPhotoLoadingIndicator setDoubleValue:0.0];
	
	NSURL* photoInformationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getInfo&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoAllContextsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getAllContexts&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoCommentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.comments.getList&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoFavoritesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getFavorites&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoSizesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getSizes&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* galleriesListForPhotoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.galleries.getListForPhoto&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];

	infoRequest = [[NSURLRequest alloc] initWithURL:photoInformationURL];
	contextsRequest = [[NSURLRequest alloc] initWithURL:photoAllContextsURL];
	commentsRequest = [[NSURLRequest alloc] initWithURL:photoCommentsURL];
	favoritesRequest = [[NSURLRequest alloc] initWithURL:photoFavoritesURL];
	galleriesRequest = [[NSURLRequest alloc] initWithURL:galleriesListForPhotoURL];
	sizesRequest = [[NSURLRequest alloc] initWithURL:photoSizesURL];
	
	[NSURLConnection connectionWithRequest:infoRequest delegate:self];
	activeRequest = infoRequest;
	[flickrPhotoLoadingIndicator startAnimation:self];
	}

#pragma mark - NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[fetchedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	NSError* error;

	FlickrAPIResponse* response = [[FlickrAPIResponse alloc] initWithData:fetchedData];
			
	if([response.status isEqualToString:@"fail"] && [response.error code] == 1)
		{
		isFetching = NO;
		[fetchedData setLength:0];
		[self updateUI];
		[flickrPhotoView setImage:[NSImage imageNamed:@"notfound"]];
		[response release];
		return;
		}
	
	if(activeRequest == infoRequest)
		{
		[self setFlickrPhoto:[FlickrPhoto photoWithAPIResponse:response error:nil]];
		[(NSObject*)[NSApp delegate] setValue:flickrPhoto forKey:@"currentPhoto"];
		
		NSArray* licenseImages = [[FlickrKitResourceManager sharedManager] imagesForLicense:flickrPhoto.license];
		
		switch([licenseImages count])
			{
			case 1:
				[secondLicenseView setImage:nil];
				[thirdLicenseView setImage:nil];
				[fourthLicenseView setImage:nil];
				[firstLicenseView setImage:[licenseImages objectAtIndex:0]];
				break;
			case 2:
				[thirdLicenseView setImage:nil];
				[fourthLicenseView setImage:nil];
				[firstLicenseView setImage:[licenseImages objectAtIndex:1]];
				[secondLicenseView setImage:[licenseImages objectAtIndex:0]];
				break;
			case 3:
				[fourthLicenseView setImage:nil];
				[firstLicenseView setImage:[licenseImages objectAtIndex:2]];
				[secondLicenseView setImage:[licenseImages objectAtIndex:1]];
				[thirdLicenseView setImage:[licenseImages objectAtIndex:0]];
				break;
			case 4:
				[firstLicenseView setImage:[licenseImages objectAtIndex:3]];
				[secondLicenseView setImage:[licenseImages objectAtIndex:2]];
				[thirdLicenseView setImage:[licenseImages objectAtIndex:1]];
				[fourthLicenseView setImage:[licenseImages objectAtIndex:0]];
				break;
			default:
				break;
			}
		
		[fetchedData setLength:0];
		[flickrPhotoLoadingIndicator incrementBy:16.6];
		activeRequest = contextsRequest;
		[NSURLConnection connectionWithRequest:contextsRequest delegate:self];
		}
	else if(activeRequest == contextsRequest)
		{
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
	
		NSMutableArray* poolArray = [NSMutableArray array];
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/pool" error:&error])
			{
			[poolArray addObject:[[element attributeForName:@"title"] stringValue]];
			}	

		NSMutableArray* setArray = [NSMutableArray array];
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/set" error:&error])
			{
			[setArray addObject:[[element attributeForName:@"title"] stringValue]];
			}	

		[flickrPhoto setPools:poolArray];
		[flickrPhoto setSets:setArray];
		[xmlDocument release];
		[fetchedData setLength:0];
		[flickrPhotoLoadingIndicator incrementBy:16.6];
		activeRequest = commentsRequest;
		[NSURLConnection connectionWithRequest:commentsRequest delegate:self];
		}
	else if(activeRequest == commentsRequest)
		{
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
		NSMutableArray* commentsArray = [NSMutableArray array];
		
		[[xmlDocument nodesForXPath:@"rsp/comments/comment" error:&error] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[commentsArray addObject:[obj stringValue]];
		}];
		
		[flickrPhoto setComments:commentsArray];
		[xmlDocument release];
		[flickrCommentsView reloadData];
		[fetchedData setLength:0];
		[flickrPhotoLoadingIndicator incrementBy:16.6];
		activeRequest = favoritesRequest;
		[NSURLConnection connectionWithRequest:favoritesRequest delegate:self];
		}
	else if(activeRequest == favoritesRequest)
		{
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

		NSMutableArray* favoritesArray = [NSMutableArray array];
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/photo/person" error:&error])
			{
			[favoritesArray addObject:[[element attributeForName:@"username"] stringValue]];
			}
		
		[flickrPhoto setFavorites:favoritesArray];
		[xmlDocument release];
		[fetchedData setLength:0];
		[flickrPhotoLoadingIndicator incrementBy:16.6];
		activeRequest = galleriesRequest;
		[NSURLConnection connectionWithRequest:galleriesRequest delegate:self];
		}
	else if(activeRequest == galleriesRequest)
		{
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

		NSMutableArray* galleriesArray = [NSMutableArray array];
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/galleries/gallery/title" error:&error])
			{
			[galleriesArray addObject:[element stringValue]];
			}

		[flickrPhoto setGalleries:galleriesArray];
		[xmlDocument release];
		[flickrGalleriesView reloadData];
		[fetchedData setLength:0];
		[flickrPhotoLoadingIndicator incrementBy:16.6];
		activeRequest = sizesRequest;
		[NSURLConnection connectionWithRequest:sizesRequest delegate:self];
		}
	else if(activeRequest == sizesRequest)
		{
		NSURL* photoImageURL = nil;
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
		
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/sizes/size" error:&error])
			{
			if([[[element attributeForName:@"label"] stringValue] isEqualToString:@"Medium"])
				{
				photoImageURL = [NSURL URLWithString:[[element attributeForName:@"source"] stringValue]];
				}
			}
		photoRequest = [NSURLRequest requestWithURL:photoImageURL];
		[flickrPhotoLoadingIndicator incrementBy:8.3];
		[fetchedData setLength:0];
		[flickrPhoto fetchImageOfSize:FlickrImageSizeMedium640];
		[xmlDocument release];
		}
	[response release];
  }

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
	{
	isFetching = NO;
	NSAlert* alert = [NSAlert alertWithError:error];
	[alert runModal];
	}

# pragma mark - Textfield delegate methods

@end
