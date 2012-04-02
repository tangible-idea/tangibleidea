//
//  MeepleProfileButton.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 11. 18..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface MeepleProfileButton : UIButton
{    
    ASIHTTPRequest *request;
    NSString *userId;
}
@property (nonatomic, copy) NSString *userId;

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageFromServer;
- (void)setImageFromServerCache;
@end

