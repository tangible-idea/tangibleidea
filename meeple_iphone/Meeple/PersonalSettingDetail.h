//
//  PersonalSettingDetail.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSettingDetail : UIViewController <UITextFieldDelegate,UITextViewDelegate, MBProgressHUDDelegate>

{
    NSInteger mType;
    NSInteger changeType; //
    UITextField *changeField;
    UITextView *changeView;
    UIImageView *changeViewBg;
    UILabel *lengthLabel;
    UILabel *maxLengthLabel;
    NSInteger maxLength;
    
    MBProgressHUD *activityIndicator;
    //UIButton *doneButton;
}

@property (nonatomic, assign) NSInteger mType;
@property (nonatomic, assign) NSInteger changeType;
@property (nonatomic, retain) IBOutlet UITextView *changeView;
@property (nonatomic, retain) IBOutlet UITextField *changeField;
@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic, retain) IBOutlet UILabel *maxLengthLabel;
@property (nonatomic,retain) IBOutlet UIImageView *changeViewBg;
@end
