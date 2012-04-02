//
//  PopUpViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "PopUpViewController.h"
#import "pictureViewController.h"

@implementation PopUpViewController
@synthesize user,tabNo,userIdLabel,userNickLabel,popTitle,userSchoolLabel,userSchoolLabel2,closeButton,button,contentView,talk,bubble,bg,userPic;

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
    
    self.user = nil;
    self.button = nil;
    self.closeButton = nil;
    self.userSchoolLabel = nil;
    self.userSchoolLabel2 = nil;
    self.userIdLabel = nil;
    self.popTitle = nil;
    self.userNickLabel = nil;
    self.contentView = nil;
    self.bg = nil;
    self.userPic = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    
    self.user = nil;
    self.button = nil;
    self.closeButton = nil;
    self.userSchoolLabel = nil;
    self.userSchoolLabel2 = nil;
    self.userIdLabel = nil;
    self.popTitle = nil;
    self.userNickLabel = nil;
    self.contentView = nil;
    self.bg = nil;
    self.userPic = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userPic.userId = user.userId;
    [userPic setImageFromServerCache];
    [[userPic layer] setCornerRadius:4.0f];
    [[userPic layer] setMasksToBounds:YES];
    [userPic setTitle:user.name forState:UIControlStateNormal];
    [userPic addTarget:self.parentViewController action:@selector(modalViewForImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [((UIControl *)self.view) addTarget:self.parentViewController action:@selector(popUpOut) forControlEvents:UIControlEventTouchDown];
    
    [bubble setImage:[[UIImage imageNamed:@"PopUpBubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    button.hidden = NO;
    
    if(tabNo == 0) // 추천탭
    {
        if(user.flag == 0 || user.flag == 1) // 추천만 받은 상태라면 ( 또는 대기 상태 ) 
        {
            [contentView setFrame:CGRectMake(contentView.frame.origin.x,contentView.frame.origin.y,211.0f,189.0f)];
            bg.frame = contentView.bounds;
            [bg setImage:[UIImage imageNamed:@"02_PopUpBg"]];
            button.hidden = YES;
            
        }
        else if(user.flag == 2) // 현재 대화 중인 상태 (즐겨찾기는 안함)
        {
            [button setImage:[UIImage imageNamed:@"AddFavorite"] forState:UIControlStateNormal];
            [button setTitle:@"fav" forState:UIControlStateNormal];
        }
        else // 나머지는 모두 즐겨찾기 중이므로 메세지 보내기
        {
            [button setImage:[UIImage imageNamed:@"SendMessage"] forState:UIControlStateNormal];
            [button setTitle:@"message" forState:UIControlStateNormal];
        }
    }
    else if(tabNo == 1) // 대화탭
    {
        if(user.flag >= 4)
        {
            [button setImage:[UIImage imageNamed:@"SendMessage"] forState:UIControlStateNormal];
            [button setTitle:@"message" forState:UIControlStateNormal];
        }
        else 
        {
            [button setImage:[UIImage imageNamed:@"AddFavorite"] forState:UIControlStateNormal];
            [button setTitle:@"fav" forState:UIControlStateNormal];
        }
    }
    else if(tabNo == 2) //메세지, 즐겨찾기
    {
        if(user.flag >= 4)
        {
            [button setImage:[UIImage imageNamed:@"SendMessage"] forState:UIControlStateNormal];
            [button setTitle:@"message" forState:UIControlStateNormal];
        }
        else 
        {
            [button setImage:[UIImage imageNamed:@"AddFavorite"] forState:UIControlStateNormal];
            [button setTitle:@"fav" forState:UIControlStateNormal];
        }
    }
    
    if(![user.name isEqualToString:@""])
    {
        popTitle.text = user.name;
        userNickLabel.text = user.name;
        userIdLabel.text = user.userId;
        if(user.type == 0) {
            userSchoolLabel.text = [NSString stringWithFormat:@"%@ %@ 학번",user.school,[[NSString stringWithFormat:@"%d",user.grade] substringFromIndex:2]];
            userSchoolLabel2.text = user.major;
        }
        else if(user.type == 1) {
            userSchoolLabel.text = user.school;
            userSchoolLabel2.text = [NSString stringWithFormat:@"%d 학년",user.grade];
        }
        
        /*
         if(user.flag >= 0 && user.flag <= 3) {
         //[button setTitle:@"즐겨찾기 추가" forState:UIControlStateNormal];
         [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width + 15.0f, button.frame.size.height)];
         }
         */
        
        talk.text = user.talk;
    }
    else
    {
        userIdLabel.text = user.userId;
        popTitle.text = user.userId;
        talk.text = @"즐겨찾기로 추가하시면 상세정보를 보실 수 있습니다.";
    }
    
    [button addTarget:self.parentViewController action:@selector(popUpButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton addTarget:self.parentViewController action:@selector(popUpOut) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




@end
