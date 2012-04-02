//
//  MeepleImageView.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 11. 18..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleImageView.h"
#import "ASIDownloadCache.h"

@implementation MeepleImageView
@synthesize userId;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [request setDelegate:nil];
    [request cancel];
    [request release];
    
    request = [[ASIHTTPRequest requestWithURL:url] retain];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    if (placeholder)
        self.image = placeholder;
    
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
    [self setImage:[UIImage imageWithData:req.responseData]];

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
