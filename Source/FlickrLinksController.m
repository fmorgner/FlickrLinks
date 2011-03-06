//
//  FlickrLinksController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrLinksController.h"

#define MAX_VALUE 100.0

static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation FlickrLinksController

@synthesize flickrPhoto;

- (id)init
	{
	if((self = [super init]))
		{
		photoHistory = [NSMutableArray new];
		photoHistoryPosition = 0;
		fetchedData = [[NSMutableData alloc] init];
		}
	return self;
	}

- (void)awakeFromNib
	{
	[flickrPhotoLoadingIndicator setMaxValue:MAX_VALUE];
	[backButton setEnabled:NO];
	[forwardButton setEnabled:NO];
	[[flickrPhotoID window] makeFirstResponder:flickrPhotoID];
	}

- (void)updateUI
	{
	([photoHistory count] && photoHistoryPosition) ? [backButton setEnabled:YES] : [backButton setEnabled:NO];	
	([photoHistory count] && photoHistoryPosition + 1 < [photoHistory count]) ? [forwardButton setEnabled:YES] : [forwardButton setEnabled:NO];	


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


- (IBAction) fetch:(id)sender
	{
	if([[flickrPhotoID stringValue] isEqualToString:@""] || isFetching)
		return;
	
	isFetching = YES;
	
	NSString* photoID = [flickrPhotoID stringValue];
	flickrPhoto = [FlickrPhoto new];
	[flickrPhotoLoadingIndicator setDoubleValue:0.0];
	
	flickrPhoto.ID = photoID;
	
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

#pragma mark - NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
	{
	NSInteger rowCount = 0;
	
	if([aTableView isEqualTo:flickrTagsView])
		{
		rowCount = [flickrPhoto.tags count];
		}
	else if([aTableView isEqualTo:flickrSetsView])
		{
		rowCount = [flickrPhoto.sets count];
		}
	else if([aTableView isEqualTo:flickrPoolsView])
		{
		rowCount = [flickrPhoto.pools count];
		}
	else if([aTableView isEqualTo:flickrGalleriesView])
		{
		rowCount = [flickrPhoto.galleries count];
		}
	else if([aTableView isEqualTo:flickrCommentsView])
		{
		rowCount = [flickrPhoto.comments count];
		}
	
	return rowCount;
	}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
	{
	NSString* objectValue = nil;
	
	if([aTableView isEqualTo:flickrTagsView])
		{
		objectValue = [flickrPhoto.tags objectAtIndex:rowIndex];
		}
	else if([aTableView isEqualTo:flickrSetsView])
		{
		objectValue = [flickrPhoto.sets objectAtIndex:rowIndex];
		}
	else if([aTableView isEqualTo:flickrPoolsView])
		{
		objectValue = [flickrPhoto.pools objectAtIndex:rowIndex];
		}
	else if([aTableView isEqualTo:flickrGalleriesView])
		{
		objectValue = [flickrPhoto.galleries objectAtIndex:rowIndex];
		}
	else if([aTableView isEqualTo:flickrCommentsView])
		{
		objectValue = [flickrPhoto.comments objectAtIndex:rowIndex];
		}
	
	return objectValue;	
	}

#pragma mark - NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[fetchedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	NSError* error;
	
	if(activeRequest == infoRequest)
		{
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
		
		if([[xmlDocument nodesForXPath:@"rsp/err" error:&error] count] && [[[[[xmlDocument nodesForXPath:@"rsp/err" error:&error] objectAtIndex:0] attributeForName:@"code"] stringValue] intValue] == 1)
			{
			isFetching = NO;
			[fetchedData setLength:0];
			[self updateUI];
			[flickrPhotoView setImage:[NSImage imageNamed:@"notfound"]];
			return;
			}
		
		[flickrPhoto setTitle:[[[xmlDocument nodesForXPath:@"rsp/photo/title" error:&error] objectAtIndex:0] stringValue]];
		[flickrPhoto setCommentCount:[[[[xmlDocument nodesForXPath:@"rsp/photo/comments" error:&error] objectAtIndex:0] stringValue] intValue]];

		NSMutableArray* tagArray = [NSMutableArray array];
		for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/photo/tags/tag" error:&error])
			{
			[tagArray addObject:[element stringValue]];
			}
		[flickrPhoto setTags:tagArray];
		[xmlDocument release];
		[flickrTagsView reloadData];
		[fetchedData setLength:0];
		[flickrPhotoTitle setStringValue:[NSString stringWithFormat:@"%@ (%@)", flickrPhoto.title, flickrPhoto.ID]];
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
		[flickrSetsView reloadData];
		[flickrPoolsView reloadData];
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
		photoRequest = [[NSURLRequest alloc] initWithURL:photoImageURL];
		[flickrPhotoLoadingIndicator incrementBy:8.3];
		[fetchedData setLength:0];
		activeRequest = photoRequest;
		[NSURLConnection connectionWithRequest:photoRequest delegate:self];
		[xmlDocument release];
		}
	else if(activeRequest == photoRequest)
		{
		[flickrPhoto setImage:[[[NSImage alloc] initWithData:fetchedData ] autorelease]];
		[flickrPhotoView setImage:flickrPhoto.image];
		[flickrPhotoLoadingIndicator setDoubleValue:[flickrPhotoLoadingIndicator maxValue]];
		[fetchedData setLength:0];
		[photoHistory addObject:flickrPhoto];
		[flickrPhoto release];
		photoHistoryPosition = [photoHistory count] - 1;
		([photoHistory count] && photoHistoryPosition) ? [backButton setEnabled:YES] : [backButton setEnabled:NO];	
		([photoHistory count] && photoHistoryPosition + 1 < [photoHistory count]) ? [forwardButton setEnabled:YES] : [forwardButton setEnabled:NO];	
		isFetching = NO;
	  }
  }
	
# pragma mark - Textfield delegate methods

@end
