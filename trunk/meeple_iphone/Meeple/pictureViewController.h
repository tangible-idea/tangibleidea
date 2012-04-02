//
//  pictureViewController.h
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 8. 20..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pictureViewController : UIViewController
{
    IBOutlet UIImageView *imageView;
    UIImage *image;
    NSString *userId;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *userId;

-(IBAction)hidesBar:(id)sender;
@end
