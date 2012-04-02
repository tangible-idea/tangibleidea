//
//  MeepleProfileButton.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 11. 18..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleProfileButton.h"
#import "ASIDownloadCache.h"

@implementation MeepleProfileButton
@synthesize userId;

- (void)setImageWithURL:(NSURL *)url {
    [request setDelegate:nil];
    [request cancel];
    [request release];
    request = [[ASIHTTPRequest requestWithURL:url] retain];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setDelegate:self];
    [request startAsynchronous];
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
    [self setImage:[UIImage imageWithData:req.responseData] forState:UIControlStateNormal];

}

@end
