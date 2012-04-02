//
//  RecommendNewMento.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "RecommendNewMento.h"
#import "PopUpViewController.h"

@implementation RecommendNewMento
@synthesize userPic,button,userIdLabel,nameLabel,schoolLabel,leftView,rightTopView,rightBottomImageView,rightBottomView,buttonInsideLeft,buttonInsideRight,user,majorLabel,userIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc
{
    self.userPic = nil;
    self.button = nil;
    self.userIdLabel = nil;
    self.nameLabel = nil;
    self.schoolLabel = nil;
    self.leftView = nil;
    self.rightTopView = nil;
    self.rightBottomImageView = nil;
    self.rightBottomView = nil;
    self.buttonInsideLeft = nil;
    self.buttonInsideRight = nil;
    self.user = nil;
    self.majorLabel = nil;
    [super dealloc];
}
- (void)viewDidUnload
{
    self.userPic = nil;
    self.button = nil;
    self.userIdLabel = nil;
    self.nameLabel = nil;
    self.schoolLabel = nil;
    self.leftView = nil;
    self.rightTopView = nil;
    self.rightBottomImageView = nil;
    self.rightBottomView = nil;
    self.buttonInsideLeft = nil;
    self.buttonInsideRight = nil;
    self.user = nil;
    self.majorLabel = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userPic.userId = user.userId;
    [userPic setImageFromServer];
    [[userPic layer] setCornerRadius:4.0f];
    [[userPic layer] setMasksToBounds:YES];
    /* Navigation Item Setting */
    
    
    //[userPic addTarget:self action:@selector(userPicPushed:) forControlEvents:UIControlEventTouchUpInside];
    [userPic setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
    /* */
    isFold = 0; // 0 이면 펼쳐짐 1 이면 접혀있음
    
    [button addTarget:self action:@selector(foldOrUnfold) forControlEvents:UIControlEventTouchUpInside];
    
    if(user.flag == 0 || user.flag == 5) {
        UIImageView *notice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01_NewMeepleNotice"]];
        [notice setFrame:CGRectMake(110.0f ,1.0f, 176.0f, 20.0f)];
        [self.view addSubview:notice];
        [notice release];
        
        [leftView setImage:[UIImage imageNamed:@"01_ProfileBgRecommendMento"]];
        [rightBottomImageView setImage:[UIImage imageNamed:@"01_RecommendMentoRightBottomBg"]];
        
        [userPic addTarget:self.parentViewController action:@selector(popUpForWaitMeeple:) forControlEvents:UIControlEventTouchUpInside];
        /*
         button 역할정의 수락, 거절
         */
        [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
        [buttonInsideLeft addTarget:self.parentViewController action:@selector(chatAccept:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonInsideRight setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
        
        [buttonInsideRight addTarget:self.parentViewController action:@selector(chatReject:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(user.flag == 2 || user.flag == 7) {
        [leftView setImage:[UIImage imageNamed:@"01_ProfileBgMyMento"]];
        
        [userPic addTarget:self.parentViewController action:@selector(popUpForChatMeeple:) forControlEvents:UIControlEventTouchUpInside];
        buttonInsideRight.hidden = YES;
        [buttonInsideLeft setFrame:CGRectMake(80.0f,63.0f,61,29)];
        [buttonInsideLeft setImage:[UIImage imageNamed:@"01_TalkButton"] forState:UIControlStateNormal];
        /*
         button 역할정의
         */ 
        [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
        
        [buttonInsideLeft addTarget:self.parentViewController action:@selector(goChat:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    userIdLabel.text = user.userId;
    nameLabel.text = user.name;
    schoolLabel.text = [NSString stringWithFormat:@"%@ %@학번",user.school,[[NSString stringWithFormat:@"%d",user.grade] substringFromIndex:2]];
    majorLabel.text = user.major;
    /*
     
     user의 현 상태에 따라서 
     버튼의 유무 , 버튼의 타이틀을 바꾸고, 
     
     버튼의 역할을 바꾼다 (?);
     
     */
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)foldOrUnfold 
{
    
    if(isFold == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        [rightTopView setFrame:CGRectMake(rightTopView.frame.origin.x, rightTopView.frame.origin.y, rightTopView.frame.size.width - 150, rightTopView.frame.size.height)];
        nameLabel.hidden = YES;
        userIdLabel.hidden = YES;
        schoolLabel.hidden = YES;
        majorLabel.hidden = YES;
        
        [button setImage:[UIImage imageNamed:@"01_SlideButtonRight"] forState:UIControlStateNormal];
        
        [UIView commitAnimations];
        isFold = 1;
    }
    else if(isFold == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [rightTopView setFrame:CGRectMake(rightTopView.frame.origin.x, rightTopView.frame.origin.y, rightTopView.frame.size.width + 150, rightTopView.frame.size.height)];
            
            [button setImage:[UIImage imageNamed:@"01_SlideButtonLeft"] forState:UIControlStateNormal];
        }
                         completion:^(BOOL finished){
                             nameLabel.hidden = NO;
                             userIdLabel.hidden = NO;
                             schoolLabel.hidden = NO;
                             majorLabel.hidden = NO;
                         }];
        
        
        isFold = 0;
    }
    
} 


@end
