//
//  MessageWriteViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MeepleImageView.h"

@interface MessageWriteViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *activityIndicator;
    MeepleImageView *userPic;
    UILabel *userNick;
    UITextView *message;
    NSString *userNickStr;
    NSString *userId;
    NSInteger isSending;
    UIImageView *textViewBg;
    id appDelegate;
}

@property (nonatomic, retain) IBOutlet MeepleImageView *userPic;
@property (nonatomic, retain) IBOutlet UILabel *userNick;
@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, copy) NSString *userNickStr;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, retain) IBOutlet UIImageView *textViewBg;

- (IBAction)backgroundTap;

@end