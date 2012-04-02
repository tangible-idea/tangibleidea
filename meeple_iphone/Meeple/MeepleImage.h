//
//  MeepleImage.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface MeepleImage : UIImage
{
    NSString *userId;
    NSInteger isUsed;
    ASIHTTPRequest *request;
}

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger isUsed;
- (void)setImageFromServer;
- (void)setImageFromServerCache;

@end
