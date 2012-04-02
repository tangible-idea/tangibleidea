//
//  RecommendNavBar.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "RecommendNavBar.h"

@implementation RecommendNavBar

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIImage *image = (self.frame.size.width > 320.0f) ? [UIImage imageNamed: @"01_NavBarBgLandscape"] : [UIImage imageNamed:@"01_NavBarBg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
