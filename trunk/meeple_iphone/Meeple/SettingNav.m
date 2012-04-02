//
//  SettingNav.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "SettingNav.h"

@implementation SettingNav

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}
- (void)changeBgForIntro
{
    type = 1;
    [self setNeedsDisplayInRect:self.bounds];
}
- (void)changeBgForSetting
{
    type = 0;
    [self setNeedsDisplayInRect:self.bounds];
}
- (void)changeBgForTips
{
    type = 2;
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(type == 1)
    {
        UIImage *image = [UIImage imageNamed:@"04_3_NavBarBg"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    else if(type == 0)
    {
        UIImage *image = (self.frame.size.width > 320.0f) ? [UIImage imageNamed: @"04_NavBarBgLandscape"] : [UIImage imageNamed:@"04_NavBarBg"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    else if(type == 2)
    {
        UIImage *image = [UIImage imageNamed:@"04_2_navBarBg"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
}



@end
