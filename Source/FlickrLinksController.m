//
//  FlickrLinksController.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "FlickrLinksController.h"
#import "FlickrPhoto.h"

static NSString* apiKey = @""; // gets read from apiKey
static NSString* apiCall = @"http://api.flickr.com/services/rest/?method=";

@implementation FlickrLinksController

- (id)init
	{
	if((self = [super init]))
		{
		NSError* error;
		NSString* path = [[NSBundle mainBundle] pathForResource:@"apiKey" ofType:nil];
		apiKey = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
		if ([apiKey isEqualToString:@""])
			{
			exit(0);
			}
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
	
	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoInformationURL] returningResponse:&response error:&error];
	xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];

	[[photo information] setValue:[[[xmlDocument nodesForXPath:@"rsp/photo/title" error:&error] objectAtIndex:0] stringValue] forKey:@"title"];
	[[photo information] setValue:[[[xmlDocument nodesForXPath:@"rsp/photo/comments" error:&error] objectAtIndex:0] stringValue] forKey:@"commentCount"];

	NSMutableArray* tagArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/photo/tags/tag" error:&error])
		{
		[tagArray addObject:[element stringValue]];
		}
	[[photo information] setObject:(NSArray*)tagArray forKey:@"tags"];



	fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoAllContextsURL] returningResponse:&response error:&error];
	xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
	
	NSMutableArray* poolArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/pool" error:&error])
		{
		[poolArray addObject:[[element attributeForName:@"title"] stringValue]];
		}	
	[[photo information] setObject:poolArray forKey:@"pools"];


	NSMutableArray* setArray = [NSMutableArray array];
	for(NSXMLElement* element in 	[xmlDocument nodesForXPath:@"rsp/set" error:&error])
		{
		[setArray addObject:[[element attributeForName:@"title"] stringValue]];
		}	
	[[photo information] setObject:setArray forKey:@"sets"];
	
	if([[[photo information] valueForKey:@"commentCount"] intValue])
		{
		fetchedData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:photoCommentsURL] returningResponse:&response error:&error];
		xmlDocument = [[NSXMLDocument alloc] initWithData:fetchedData options:0 error:&error];
		NSMutableArray* commentsArray = [NSMutableArray array];
		
		[[xmlDocument nodesForXPath:@"rsp/comments/comment" error:&error] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[commentsArray addObject:[obj stringValue]];
		}];
		
		[[photo information] setObject:commentsArray forKey:@"comments"];
		}
	
	[photo release];
	}

@end
