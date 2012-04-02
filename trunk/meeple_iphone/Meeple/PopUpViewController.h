//
//  PopUpViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//


/* 
  PopUpViewController 쓰는 법
 tabNo 은 말그대로 탭번호를 의미한다. 
 0->추천탭 1->대화탭 2->즐겨찾기탭
 
 필요한 메소드 (즉 이를 포함하는 부모뷰 컨트롤러에 필요한 내용들은)
 
 - popUpOut (팝업 종료)
 - popUpButtonPushed:(id)sender (버튼 눌렸을때)
  sender 는 버튼타입이며 
  타이틀로 용도를 구분하자 
  title: fav -> 즐겨찾기 추가
  title: message -> 쪽지 보내기
 
*/
#import <UIKit/UIKit.h>
#import "User.h"
#import "MeepleProfileButton.h"
@interface PopUpViewController : UIViewController
{
    User *user;
    NSInteger tabNo;
    IBOutlet UIImageView *bg;
    IBOutlet UIView *contentView;
    IBOutlet UIButton *button;
    IBOutlet UILabel *userIdLabel;
    IBOutlet UILabel *userNickLabel;
    IBOutlet UILabel *userSchoolLabel;
    IBOutlet UILabel *userSchoolLabel2;
    IBOutlet UIButton *closeButton;
    IBOutlet UILabel *popTitle;
    IBOutlet UILabel *talk;
    IBOutlet UIImageView *bubble;
    IBOutlet MeepleProfileButton *userPic;
}

@property (nonatomic,retain) User *user;
@property (nonatomic,retain) IBOutlet UIImageView *bg;
@property (nonatomic,retain) IBOutlet UIView *contentView;
@property (nonatomic,retain) IBOutlet UIButton *button;
@property (nonatomic,retain) IBOutlet UILabel *userIdLabel;
@property (nonatomic,retain) IBOutlet UILabel *popTitle;
@property (nonatomic,retain) IBOutlet UILabel *userNickLabel;
@property (nonatomic,retain) IBOutlet UILabel *userSchoolLabel;
@property (nonatomic,retain) IBOutlet UILabel *userSchoolLabel2;
@property (nonatomic,retain) IBOutlet UIButton *closeButton;
@property (nonatomic,retain) IBOutlet UILabel *talk;
@property (nonatomic,retain) IBOutlet UIImageView *bubble;
@property (nonatomic,retain) IBOutlet MeepleProfileButton *userPic;
@property (nonatomic,assign) NSInteger tabNo;

@end
