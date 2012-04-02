//
//  PrivateSettingViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateSettingViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *tbl;
    NSString *userId;
    NSString *userName;
    NSString *userPassword;
    NSString *todayTalk;
    NSString *userSchool;
    NSString *subjectOrGrade;
    NSInteger mType;
    NSString *userEmail;
    NSString *mentoGrade;
    NSArray *sectionList;
    NSDictionary *settingDict;
    UIView *loginInfoView;
    
    UIButton *userPic;
    
    NSUserDefaults *userDefaults;
}

@property (nonatomic,retain) IBOutlet UITableView *tbl;

@end
