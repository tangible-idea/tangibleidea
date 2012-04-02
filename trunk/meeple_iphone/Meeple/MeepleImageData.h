//
//  MeepleImageData.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface MeepleImageData : NSData
{
    NSInteger isUsed;
    NSString *userId;
    ASIHTTPRequest *request;
}

@property (nonatomic, assign) NSInteger isUsed;
@property (nonatomic, copy) NSString *userId;

- (void)setImageFromServer;
- (void)setImageFromServerCache;

@end
