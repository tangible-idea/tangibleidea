//
//  RecommendNewMentee.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "RecommendNewMentee.h"
#import "PopUpViewController.h"

@implementation RecommendNewMentee
@synthesize userPic,button,userIdLabel,nameLabel,schoolLabel,leftView,rightTopView,rightBottomImageView,rightBottomView,buttonInsideLeft,buttonInsideRight,user,isFirst,userIndex;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    id controller = self.parentViewController;
    
    isFold = 0; // 0 이면 펼쳐짐 1 이면 접혀있음
    
    [userPic setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
    userPic.userId = user.userId;
    [userPic setImageFromServer];
    [[userPic layer] setCornerRadius:4.0f];
    [[userPic layer] setMasksToBounds:YES];
    
    [button addTarget:self action:@selector(foldOrUnfold) forControlEvents:UIControlEventTouchUpInside];
    if(isFirst == 0) { // first 가 아닐 때
        
        [leftView setFrame:CGRectMake(leftView.frame.origin.x, leftView.frame.origin.y + 25, leftView.frame.size.width, leftView.frame.size.height-25)];
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 25.0f,self.view.frame.size.width,self.view.frame.size.height)];
        
        for(UIView *subview in [self.view subviews])
        {
            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y - 25.0f, subview.frame.size.width, subview.frame.size.height)];
        }
        
        if(user.flag == 0 || user.flag == 5) { // 추천 상태
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgNoTitle"]];
            [rightBottomImageView setImage:[UIImage imageNamed:@"01_RecommendMenteeRightBottomBg"]];
            [userPic addTarget:controller action:@selector(popUpForWaitMeeple:) forControlEvents:UIControlEventTouchUpInside];
            /*
             button 역할정의
             */ 
            [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            [buttonInsideLeft addTarget:self.parentViewController action:@selector(chatAccept:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonInsideRight setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            
            [buttonInsideRight addTarget:self.parentViewController action:@selector(chatReject:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(user.flag == 1 || user.flag == 6) { //대기상태
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgWaitNoTitle"]];
            [rightBottomImageView setImage:[UIImage imageNamed:@"01_WaitMenteeRightBottomBg"]];
            buttonInsideLeft.hidden = YES;
            buttonInsideRight.hidden = YES;
            
            [userPic addTarget:controller action:@selector(popUpForWaitMeeple:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(user.flag == 2 || user.flag == 7) { // 채팅상태
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgNoTitle"]];
            buttonInsideRight.hidden = YES;
            [buttonInsideLeft setFrame:CGRectMake(80.0f,63.0f,61,29)];
            [buttonInsideLeft setImage:[UIImage imageNamed:@"01_TalkButton"] forState:UIControlStateNormal];
            [userPic addTarget:controller action:@selector(popUpForChatMeeple:) forControlEvents:UIControlEventTouchUpInside];
            
            /*
             button 역할정의 (chat)
             */
            [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            
            [buttonInsideLeft addTarget:self.parentViewController action:@selector(goChat:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    else { // first 일 때,
        
        if(user.flag == 0 || user.flag == 5) {
            UIImageView *notice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"01_NewMeepleNotice"]];
            [notice setFrame:CGRectMake(110.0f ,1.0f, 176.0f, 20.0f)];
            [self.view addSubview:notice];
            [notice release];
            
            [userPic addTarget:controller action:@selector(popUpForWaitMeeple:) forControlEvents:UIControlEventTouchUpInside];
            
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgRecommendMentee"]];
            [rightBottomImageView setImage:[UIImage imageNamed:@"01_RecommendMenteeRightBottomBg"]];
            /*
             button 역할정의
             */ 
            [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            [buttonInsideLeft addTarget:self.parentViewController action:@selector(chatAccept:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonInsideRight setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            
            [buttonInsideRight addTarget:self.parentViewController action:@selector(chatReject:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(user.flag == 1 || user.flag == 6) {
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgWaitMentee"]];
            [rightBottomImageView setImage:[UIImage imageNamed:@"01_WaitMenteeRightBottomBg"]];
            buttonInsideLeft.hidden = YES;
            buttonInsideRight.hidden = YES;
            [userPic addTarget:controller action:@selector(popUpForWaitMeeple:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if(user.flag == 2 || user.flag == 7) {
            [leftView setImage:[UIImage imageNamed:@"01_ProfileBgMyMentee"]];
            [userPic addTarget:controller action:@selector(popUpForChatMeeple:) forControlEvents:UIControlEventTouchUpInside];
            
            buttonInsideRight.hidden = YES;
            [buttonInsideLeft setFrame:CGRectMake(80.0f,63.0f,61,29)];
            [buttonInsideLeft setImage:[UIImage imageNamed:@"01_TalkButton"] forState:UIControlStateNormal];
            /*
             button 역할정의 (chat)
             */ 
            [buttonInsideLeft setTitle:[NSString stringWithFormat:@"%d",userIndex] forState:UIControlStateNormal];
            
            [buttonInsideLeft addTarget:self.parentViewController action:@selector(goChat:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    userIdLabel.text = user.userId;
    nameLabel.text = user.name;
    schoolLabel.text = [NSString stringWithFormat:@"%@ %d학년",user.school,user.grade];
    
    /*
     
     user의 현 상태에 따라서 
     버튼의 유무 , 버튼의 타이틀을 바꾸고, 
     
     버튼의 역할을 바꾼다 (?);
     
     */
    
}

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
    
    [super viewDidUnload];
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
                         }];
        
        
        isFold = 0;
    }
    
} 


@end
