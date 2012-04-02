//
//  MeepleImage.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleImage.h"
#import "ASIDownloadCache.h"

@implementation MeepleImage
@synthesize userId,isUsed;

- (void)dealloc {
    [request setDelegate:nil];
    [request cancel];
    [request release];
    self.userId = nil;
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    if (req.responseStatusCode != 200)
    {
        return;
    }
    else
    {
        [self initWithData:req.responseData];
        isUsed = 1;
        CGSize itemSize = CGSizeMake(50, 50);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[self drawInRect:imageRect];
		UIGraphicsEndImageContext();
    }
}

- (void)setImageFromServerCache
{
    [request setDelegate:nil];
    [request cancel];
    [request release];
    
    request = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",kMeepleImage,userId]]] retain];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)setImageFromServer
{
    [request setDelegate:nil];
    [request cancel];
    [request release];
    
    request = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",kMeepleImage,userId]]] retain];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDelegate:self];
    [request startAsynchronous];
}

@end
