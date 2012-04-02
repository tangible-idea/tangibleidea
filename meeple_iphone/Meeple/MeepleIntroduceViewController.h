//
//  MeepleIntroduceViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeepleIntroduceViewController : UIViewController
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

-(IBAction)changePage;
@end
