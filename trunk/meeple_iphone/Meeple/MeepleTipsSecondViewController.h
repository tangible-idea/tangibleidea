//
//  MeepleTipsSecondViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeepleTipsSecondViewController : UIViewController
{
    NSInteger m_type;
    UIImageView *imageView;
}

@property (nonatomic, assign) NSInteger m_type;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end
