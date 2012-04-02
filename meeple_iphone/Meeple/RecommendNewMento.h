//
//  RecommendNewMento.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MeepleProfileButton.h"

@interface RecommendNewMento : UIViewController
{
    
    //UIButton *userPic;
    MeepleProfileButton *userPic;
    UIButton *button;
    UILabel *userIdLabel;
    UILabel *nameLabel;
    UILabel *schoolLabel;
    UILabel *majorLabel;
    UIImageView *leftView;
    UIView *rightTopView;
    UIImageView *rightBottomImageView;
    UIView *rightBottomView;
    UIButton *buttonInsideLeft;
    UIButton *buttonInsideRight;
    User *user;
    NSInteger isFold;
    NSInteger userIndex;
    
    //MeepleImageView *userImageView;
    
}
//@property (nonatomic, retain) IBOutlet UIButton *userPic;
@property (nonatomic, retain) IBOutlet MeepleProfileButton *userPic;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *userIdLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *schoolLabel;
@property (nonatomic, retain) IBOutlet UILabel *majorLabel;
@property (nonatomic, retain) IBOutlet UIImageView *leftView;
@property (nonatomic, retain) IBOutlet UIView *rightBottomView;
@property (nonatomic, retain) IBOutlet UIView *rightTopView;
@property (nonatomic, retain) IBOutlet UIImageView *rightBottomImageView;
@property (nonatomic, retain) IBOutlet UIButton *buttonInsideLeft;
@property (nonatomic, retain) IBOutlet UIButton *buttonInsideRight;
//@property (nonatomic, retain) IBOutlet MeepleImageView *userImageView;

@property (nonatomic, retain) User *user;
@property (nonatomic, assign) NSInteger userIndex;
@end
