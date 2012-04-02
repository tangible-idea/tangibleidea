//
//  MeepleImageData.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleImageData.h"
#import "ASIDownloadCache.h"

@implementation MeepleImageData
@synthesize isUsed,userId;

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
        return;
    [self initWithData:[req responseData]];
    isUsed = 1;

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
