//
//  FlickrLinksController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrLinksController.h"

static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation FlickrLinksController

@synthesize flickrPhoto;

- (id)init
	{
	if((self = [super init]))
		{
		flickrPhoto = [FlickrPhoto new];
		}
	return self;
	}

- (IBAction) fetch:(id)sender
	{
	FlickrPhoto* photo = [FlickrPhoto new];
	NSString* photoID = [flickrPhotoID stringValue];
	
	/*TODO: fetch galeries, tags, favorites, sets, commments, title, pools*/
	
	NSURL* photoInformationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getInfo&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoAllContextsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getAllContexts&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoCommentsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.comments.getList&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* photoFavoritesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.photos.getFavorites&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	NSURL* galleriesListForPhotoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@flickr.galleries.getListForPhoto&api_key=%@&photo_id=%@", apiCall, apiKey, photoID]];
	
	NSData* fetchedData = nil;
	NSURLResponse* response = nil;
	NSError* error = nil;
	NSXMLDocument* xmlDocument = nil;

	{	
	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoInformationURL] returningResponse:&response error:&error];
	xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

	[photo setTitle:[[[xmlDocument nodesForXPath:@"rsp/photo/title" error:&error] objectAtIndex:0] stringValue]];
	[photo setCommentCount:[[[[xmlDocument nodesForXPath:@"rsp/photo/comments" error:&error] objectAtIndex:0] stringValue] intValue]];

	NSMutableArray* tagArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/photo/tags/tag" error:&error])
		{
		[tagArray addObject:[element stringValue]];
		}
	[photo setTags:tagArray];
	} // fetch title, commentCount and tags

	{
	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoAllContextsURL] returningResponse:&response error:&error];
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

	[photo setPools:poolArray];
	[photo setSets:setArray];
	} // fetch pools and sets
	
	{
	if([photo commentCount])
		{
		fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoCommentsURL] returningResponse:&response error:&error];
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
		NSMutableArray* commentsArray = [NSMutableArray array];
		
		[[xmlDocument nodesForXPath:@"rsp/comments/comment" error:&error] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[commentsArray addObject:[obj stringValue]];
		}];
		
		[photo setComments:commentsArray];
		}
	} // fetch comments
	
	{
	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoFavoritesURL] returningResponse:&response error:&error];
	xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

	NSMutableArray* favoritesArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/photo/person" error:&error])
		{
		[favoritesArray addObject:[[element attributeForName:@"username"] stringValue]];
		}
	
	[photo setFavorites:favoritesArray];
	} // fetch favorites

	{
	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:galleriesListForPhotoURL] returningResponse:&response error:&error];
	xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

	NSMutableArray* galleriesArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/galleries/gallery/title" error:&error])
		{
		[galleriesArray addObject:[element stringValue]];
		}
	
	[photo setGalleries:galleriesArray];
	} // fetch galleries
	
	flickrPhoto = photo;
	[flickrTagsView reloadData];
	}

@end
