//
//  SettingNav.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingNav : UINavigationBar
{
    NSInteger type;
}

- (void)changeBgForIntro;
- (void)changeBgForSetting;
- (void)changeBgForTips;

@end
