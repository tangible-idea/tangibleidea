//
//  RecommendViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendNewMento.h"
#import "RecommendNewMentee.h"
//#import "PopUpViewController.h"
#import "ChatViewController_.h"
#import "MessageWriteViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "pictureViewController.h"

#define kPopUpType_Wait 0
#define kPopUpType_Chat 1

@implementation RecommendViewController
@synthesize scrollView,controllersWait, controllersChat,usersChat, usersWait, mType,adView;

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
    self.scrollView = nil;
    self.controllersChat = nil;
    self.controllersWait = nil;
    self.usersChat = nil;
    self.usersWait = nil;
    self.adView = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.controllersChat = nil;
    self.controllersWait = nil;
    self.usersChat = nil;
    self.usersWait = nil;
    self.adView = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeRecommend" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 로그인 검사 //
    [appDelegate checkLogin];
    
    // Notification Center //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRecommendStatus) name:@"changeRecommend" object:nil];
   
    
    if(activityIndicator == nil)
    {
        activityIndicator = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
        activityIndicator.delegate = self;
        
    }
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    mType = [(NSNumber *)[info objectForKey:kUserTypeKey] intValue];
    if(mType == 1) 
    {
        if(self.navigationItem.rightBarButtonItem == nil)
        {
            UIImage *waitButtonImage = [UIImage imageNamed:@"01_WaitButton"];
            UIButton *waitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            waitButton.bounds = CGRectMake( 0, 0, waitButtonImage.size.width, waitButtonImage.size.height);
            [waitButton addTarget:self action:@selector(getWaitNumber) forControlEvents:UIControlEventTouchUpInside];
            [waitButton setImage:waitButtonImage forState:UIControlStateNormal];
            
            UIBarButtonItem *waitBarButton = [[UIBarButtonItem alloc] initWithCustomView:waitButton];
            self.navigationItem.rightBarButtonItem=waitBarButton;
            [waitBarButton release];
        }
    }
    else
    {
        if(self.navigationItem.rightBarButtonItem !=nil)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    for(UIView *subview in [scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    [self checkRecommendStatus];
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        CGRect frame = adView.frame;
        frame.size.height = 33.0f;
        frame.origin.y = 186.0f;
        
        CGRect scrollViewFrame = scrollView.frame;
        scrollViewFrame.size.height = 206.0f;
        
        [adView setFrame:frame];
        [adView setImage:[UIImage imageNamed:@"01_ModuLandscape"] forState:UIControlStateNormal];
        
        [scrollView setFrame:scrollViewFrame];
    }
    

    [usersWait removeAllObjects];
    [usersChat removeAllObjects];
    [appDelegate getWaitRecommendList:usersWait];
    [appDelegate getChatRecommendList:usersChat];
    
    [controllersWait removeAllObjects];
    [controllersChat removeAllObjects];
    
    if(mType == 0) 
    {
        CGFloat y = 26.0f;
        CGFloat height;
        for (int i = 0; i < [usersChat count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            
            User *user = [usersChat objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMenteeBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + 124.0f;
            
        }
        
        y = y+ 25.0f;
        
        for (int i=0; i < [usersWait count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            
            User *user = [usersWait objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersWait addObject:detail];
            [scrollView addSubview:detail.view];
            
            [detail release];
            y = y + height;
        }
        
        if([usersWait count]==0) {
            
            UIImageView *noWait = [[UIImageView alloc] init];
            noWait.image = [UIImage imageNamed:@"01_NoRecommendMenteeBg"];
            [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noWait];
            [noWait release];
            
            y = y + 124.0f;
        }
        y = y + 40.0f;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];    
        
    }
    else if(mType == 1)
    {
        CGFloat y = 25.0f;
        CGFloat height = 124.0f;
        if([usersChat count] != 0) {
            RecommendNewMento *detail = [[RecommendNewMento alloc] init];
            User *user = [usersChat objectAtIndex:0];
            detail.user = user;
            detail.userIndex = 0;
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMentoBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + height;
        }
        
        y = y+ 25.0f;
        
        if([usersChat count] == 0) {
            if([usersWait count] != 0) {
                RecommendNewMento *detail = [[RecommendNewMento alloc] init];
                
                User *user = [usersWait objectAtIndex:0];
                detail.user = user;
                detail.userIndex = 0;
                CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
                [detail.view setFrame:frame];
                [controllersWait addObject:detail];
                [scrollView addSubview:detail.view];
                [detail release];
                y = y + height;
            }
            else {
                UIImageView *noWait = [[UIImageView alloc] init];
                noWait.image = [UIImage imageNamed:@"01_NoRecommendMentoBg"];
                [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
                [scrollView addSubview:noWait];
                [noWait release];
                
                y = y + 124.0f;
            }
        }
        y = y + 40.0f;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];    
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    controllersWait = [[NSMutableArray alloc] init];
    controllersChat = [[NSMutableArray alloc] init];
    usersChat = [[NSMutableArray alloc] init];
    usersWait = [[NSMutableArray alloc] init];
    
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.alwaysBounceVertical=NO;             
    scrollView.alwaysBounceHorizontal=NO;         
    scrollView.delegate=self;
    scrollView.contentMode = UIViewContentModeTopRight;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    for(UIView *subview in [scrollView subviews])
    {
        [subview removeFromSuperview];
    }

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        CGRect frame = adView.frame;
        frame.size.height = 33.0f;
        frame.origin.y = 186.0f;
        
        CGRect scrollViewFrame = scrollView.frame;
        scrollViewFrame.size.height = 206.0f;
        
        [adView setFrame:frame];
        [adView setImage:[UIImage imageNamed:@"01_ModuLandscape"] forState:UIControlStateNormal];
        
        [scrollView setFrame:scrollViewFrame];
    }
    else
    {   
        CGRect frame = adView.frame;
        frame.size.height = 39.0f;
        frame.origin.y = 328.0f;
        
        CGRect scrollViewFrame = scrollView.frame;
        scrollViewFrame.size.height = 343.0f;

        [adView setFrame:frame];
        [adView setImage:[UIImage imageNamed:@"01_Modu"] forState:UIControlStateNormal];
        
        [scrollView setFrame:scrollViewFrame];
    }
    
    if(mType == 0) 
    {
        CGFloat y = 25.0f;
        CGFloat height;
        for (int i = 0; i < [usersChat count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            User *user = [usersChat objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMenteeBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + 124.0f;
            
        }
        
        y = y+ 25.0f;
        
        for (int i=0; i < [usersWait count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            User *user = [usersWait objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersWait addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersWait count]==0) {
            
            UIImageView *noWait = [[UIImageView alloc] init];
            noWait.image = [UIImage imageNamed:@"01_NoRecommendMenteeBg"];
            [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noWait];
            [noWait release];
            
            y = y + 124.0f;
        }
        y = y+ 40.0f;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];    
        
    }
    else if(mType == 1)
    {
        CGFloat y = 26.0f;
        CGFloat height = 124.0f;
        if([usersChat count] != 0) {
            RecommendNewMento *detail = [[RecommendNewMento alloc] init];
            User *user = [usersChat objectAtIndex:0];
            detail.user = user;
            detail.userIndex = 0;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMentoBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + height;
        }
        
        y = y+ 26.0f;
        
        if([usersChat count] == 0) {
            if([usersWait count] != 0) {
                RecommendNewMento *detail = [[RecommendNewMento alloc] init];
                
                User *user = [usersWait objectAtIndex:0];
                detail.user = user;
                detail.userIndex = 0;
                
                CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
                [detail.view setFrame:frame];
                [controllersWait addObject:detail];
                [scrollView addSubview:detail.view];
                [detail release];
                y = y + height;
            }
            else {
                UIImageView *noWait = [[UIImageView alloc] init];
                noWait.image = [UIImage imageNamed:@"01_NoRecommendMentoBg"];
                [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
                [scrollView addSubview:noWait];
                [noWait release];
                
                y = y + 124.0f;
            }
            y = y + 40.0f;
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
            [scrollView setContentOffset:CGPointMake(0,0) animated:YES];   
        }
    }

}
#pragma mark - button Pushed

-(void)getWaitNumber
{
    /* 통신 해서 대기번호 받아오자 */
    //NSInteger type = 0;
    NSInteger count = [usersChat count];
    if(count != 0)
    {
        NSString *title = [NSString stringWithFormat:@"%@",@"대기중이 아닙니다."];
        NSString *message = [NSString stringWithFormat:@"%@",@"나의미플 또는 추천받은 미플, 수락확인 중인 미플이 있습니다"];  
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"확인" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else 
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@GetWaitingLines?localAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setTimeOutSeconds:20];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            
            NSInteger number = [response intValue];
            NSString *title = [NSString stringWithFormat:@"%@ %d",@"현재 나의 대기번호:",number];
            NSString *message = [NSString stringWithFormat:@"%@",@"멘토 모두가 다른 멘티와 대화 중입니다. 순서를 기다리면 곧 멘토와 대화를 나눌 수 있습니다."];  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }];
        
        [request startAsynchronous];
        
    }
    
    
}
#pragma mark - popUp

-(void)popUpForWaitMeeple:(id)sender
{
    NSInteger userIndex = [((UIButton *)sender).titleLabel.text intValue];
    popUpIndex = userIndex;
    popUpType = kPopUpType_Wait;
    
    User *user = [usersWait objectAtIndex:userIndex];
    
    UIView *grayViewNav = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    grayViewNav.alpha = 0.6f;
    grayViewNav.backgroundColor = [UIColor blackColor];
    grayViewNav.tag = 100;
    grayViewNav.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar addSubview:grayViewNav];
    
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.6f;
    grayView.tag = 200;
    grayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:grayView];
    
    PopUpViewController *userinfoView = [[[PopUpViewController alloc] init] autorelease];
    
    userinfoView.user = user;
    userinfoView.tabNo = 0;
    
    userinfoView.view.tag = 300;
    userinfoView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [userinfoView.view setFrame:self.view.frame];
    [self.view addSubview:userinfoView.view];
    
    [grayView release];
    [grayViewNav release];
    
}

-(void)popUpForChatMeeple:(id)sender
{
    NSInteger userIndex = [((UIButton *)sender).titleLabel.text intValue];
    popUpIndex = userIndex;
    popUpType = kPopUpType_Chat;
    
    User *user = [usersChat objectAtIndex:userIndex];
    UIView *grayViewNav = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    grayViewNav.alpha = 0.7f;
    grayViewNav.backgroundColor = [UIColor blackColor];
    grayViewNav.tag = 100;
    grayViewNav.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar addSubview:grayViewNav];
    
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.7f;
    grayView.tag = 200;
    grayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:grayView];
    
    PopUpViewController *userinfoView = [[[PopUpViewController alloc] init] autorelease];
    
    userinfoView.user = user;
    userinfoView.tabNo = 0;
    
    userinfoView.view.tag = 300;
    userinfoView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [userinfoView.view setFrame:self.view.frame];
    [self.view addSubview:userinfoView.view];
    
    [grayView release];
    [grayViewNav release];
}

-(void)popUpOut 
{
    [[self.view viewWithTag:300] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
}

-(void)popUpButtonPushed:(id)sender 
{
    NSString *buttonType = ((UIButton *)sender).titleLabel.text;
    User *selectedUser;
    id delegate = [[UIApplication sharedApplication] delegate];
    if(popUpType == kPopUpType_Wait)
    {
        selectedUser = [usersWait objectAtIndex:popUpIndex];
    }
    else //kPopUPType_Chat
    {
        selectedUser = [usersChat objectAtIndex:popUpIndex];
    }
    
    if([buttonType isEqualToString:@"fav"]) 
    {
        [activityIndicator setLabelText:@"추가 중..."];
        [activityIndicator show:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@AddRelation?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],selectedUser.userId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setDelegate:self];
        [request setTimeOutSeconds:20];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            if([response boolValue])
            {
                selectedUser.flag = selectedUser.flag + 5;
                [delegate updateUser:selectedUser];
                
                [[self.view viewWithTag:300] removeFromSuperview];
                [[self.view viewWithTag:200] removeFromSuperview];
                [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"추가 실패"
                                                                message:@"서버 오류. 불편을 끼쳐드려서 죄송합니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [activityIndicator hide:YES];
            
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"추가 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            [activityIndicator hide:YES];
        
        }];
        [request startAsynchronous];
    }
    else if([buttonType isEqualToString:@"message"])
    {
        /*
         쪽지 보내기
        */
        MessageWriteViewController *messageWriteView = [[MessageWriteViewController alloc] init];
        messageWriteView.userNickStr = selectedUser.name;
        messageWriteView.userId = selectedUser.userId;
        [self.navigationController pushViewController:messageWriteView animated:YES];
        [messageWriteView release];
        
        [[self.view viewWithTag:300] removeFromSuperview];
        [[self.view viewWithTag:200] removeFromSuperview];
        [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
    }
    
}

#pragma mark - button

-(IBAction)openURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.modumagazine.com"]];
}

#pragma mark - RecommendNewMento , NewMentee Button
-(void)chatAccept:(id)sender
{
    UIButton *acceptButton = (UIButton *)sender;
    NSInteger userIndex = [acceptButton.titleLabel.text intValue];
    //id delegate = [[UIApplication sharedApplication] delegate];
    if(mType == 0) 
    {
        /* 
          멘토입장에서 채팅을 수락 (즉, 나의 미플로 수락의 경우) 대기를 타게 된다.
         따라서 서버에 전달을 한 뒤 유저 flag 를 현재 flag  + 1 ; 해주고 view 를 다시 리로드 하자!
         */
        activityIndicator.labelText = @"나의 미플로 수락 중...";
        [activityIndicator show:YES];
        NSString *oppoAccount = ((User *)[usersWait objectAtIndex:userIndex]).userId;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        __block ASIFormDataRequest *request = 
        [[ASIFormDataRequest alloc] initWithURL:
         [NSURL URLWithString:
          [[NSString stringWithFormat:@"%@RespondRecommendation?localAccount=%@&oppoAccount=%@&session=%@&accept=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],oppoAccount,[defaults objectForKey:kSessionIdKey],@"true"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
         ];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            if([response boolValue])
            {
                /*
                user.flag = user.flag + 1;
                [delegate updateUser:user];
                */
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"채팅 수락 실패"
                                                                message:@"3G/WIFI 상태를 확인하세요."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                
                [alert release];
            }
            [activityIndicator hide:YES];
            [self checkRecommendStatus];
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            [activityIndicator hide:YES];
        }];
        [request startAsynchronous];
    }
    else
    {
        /*
         멘티입장에서 채팅을 수락하게 되면 (즉 나의 미플로 수락할 경우) 바로 채팅이 가능하다
         따라서 서버에 전달을 한뒤 유저 flag 를 현재 flag + 2 ; 해주고 채팅방과 관련한 테이블을 
         만들고 view 를 다시 리로드 해주면 된다.
         */
        activityIndicator.labelText = @"나의 미플로 수락 중...";
        [activityIndicator show:YES];
        
        NSString *oppoAccount = ((User *)[usersWait objectAtIndex:userIndex]).userId;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        __block ASIFormDataRequest *request = 
        [[ASIFormDataRequest alloc] initWithURL:
         [NSURL URLWithString:
          [[NSString stringWithFormat:@"%@RespondRecommendation?localAccount=%@&oppoAccount=%@&session=%@&accept=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],oppoAccount,[defaults objectForKey:kSessionIdKey],@"true"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
         ];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            if([response boolValue])
            {
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"채팅 수락 실패"
                                                                message:@"3G/WIFI 상태를 확인하세요."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [activityIndicator hide:YES];
            [self checkRecommendStatus];
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            [activityIndicator hide:YES];
            
        }];
        [request startAsynchronous];
        
        [activityIndicator hide:YES];
    }
    //[self refresh];
}

-(void)chatReject:(id)sender
{
    UIButton *rejectButton = (UIButton *)sender;
    NSInteger userIndex = [rejectButton.titleLabel.text intValue];
    /*
     
     서버에 알리고 난 후에 적용하자!//
     */
    activityIndicator.labelText = @"거절 중...";
    [activityIndicator show:YES];
    
    NSString *oppoAccount = ((User *)[usersWait objectAtIndex:userIndex]).userId;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block ASIFormDataRequest *request = 
    [[ASIFormDataRequest alloc] initWithURL:
     [NSURL URLWithString:
      [[NSString stringWithFormat:@"%@RespondRecommendation?localAccount=%@&oppoAccount=%@&session=%@&accept=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],oppoAccount,[defaults objectForKey:kSessionIdKey],@"false"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
     ];
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        if([response boolValue])
        {
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"채팅 수락 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [activityIndicator hide:YES];
        [self checkRecommendStatus];
    }];
    [request setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                        message:@"3G/WIFI 상태를 확인하세요."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인!" 
                                              otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        [activityIndicator hide:YES];
    }];
    [request startAsynchronous];
    
}

-(void)goChat:(id)sender
{
    UIButton *chatButton = (UIButton *)sender;
    NSInteger userIndex = [chatButton.titleLabel.text intValue];
    User *selectedUser = [usersChat objectAtIndex:userIndex];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    ChatViewController_ *chat = [[ChatViewController_ alloc] init];
    chat.user = selectedUser;
    chat.chatRoom = [appDelegate getChatRoomByUserId:selectedUser.userId];
    chat.hidesBottomBarWhenPushed = YES;
    chat.beforeViewIndex = 0;
    
    [self.navigationController pushViewController:chat animated:YES];
    [chat release];
}

#pragma mark - refresh

-(void)refresh
{
    for(UIView *subview in [scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    [usersWait removeAllObjects];
    [usersChat removeAllObjects];
    [appDelegate getWaitRecommendList:usersWait];
    [appDelegate getChatRecommendList:usersChat];
    
    [controllersWait removeAllObjects];
    [controllersChat removeAllObjects];
    
    if(mType == 0) 
    {
        CGFloat y = 25.0f;
        CGFloat height;
        for (int i = 0; i < [usersChat count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            
            User *user = [usersChat objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMenteeBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + 124.0f;
            
        }
        
        y = y+ 26.0f;
        
        for (int i=0; i < [usersWait count]; i++) {
            RecommendNewMentee *detail = [[RecommendNewMentee alloc] init];
            if(i==0) {
                detail.isFirst = 1;
                height = 124.0f;
            }
            else {
                detail.isFirst = 0;
                height = 99.0f;
            }
            User *user = [usersWait objectAtIndex:i];
            detail.user = user;
            detail.userIndex = i;
            
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersWait addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersWait count]==0) {
            
            UIImageView *noWait = [[UIImageView alloc] init];
            noWait.image = [UIImage imageNamed:@"01_NoRecommendMenteeBg"];
            [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noWait];
            [noWait release];
            
            y = y + 124.0f;
        }
        y = y + 40.0f;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];    
        
    }
    else if(mType == 1)
    {
        CGFloat y = 25.0f;
        CGFloat height = 124.0f;
        if([usersChat count] != 0) {
            RecommendNewMento *detail = [[RecommendNewMento alloc] init];
            User *user = [usersChat objectAtIndex:0];
            detail.user = user;
            detail.userIndex = 0;
            CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
            [detail.view setFrame:frame];
            [controllersChat addObject:detail];
            [scrollView addSubview:detail.view];
            [detail release];
            y = y + height;
        }
        
        if([usersChat count] == 0) {
            UIImageView *noChat = [[UIImageView alloc] init];
            noChat.image = [UIImage imageNamed:@"01_NoMyMentoBg"];
            [noChat setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
            [scrollView addSubview:noChat];
            [noChat release];
            
            y = y + height;
        }
        
        y = y+ 25.0f;
        
        if([usersChat count] == 0) {
            if([usersWait count] != 0) {
                RecommendNewMento *detail = [[RecommendNewMento alloc] init];
                
                User *user = [usersWait objectAtIndex:0];
                detail.user = user;
                detail.userIndex = 0;
                CGRect frame = CGRectMake((scrollView.frame.size.width - detail.view.frame.size.width)/2, y, scrollView.frame.size.width, height);
                [detail.view setFrame:frame];
                [controllersWait addObject:detail];
                [scrollView addSubview:detail.view];
                [detail release];
                y = y + height;
            }
            else {
                UIImageView *noWait = [[UIImageView alloc] init];
                noWait.image = [UIImage imageNamed:@"01_NoRecommendMentoBg"];
                [noWait setFrame:CGRectMake(scrollView.frame.size.width/2 - 146.0f, y, 293.0f, 124.0f)];
                [scrollView addSubview:noWait];
                [noWait release];
                
                y = y + 124.0f;
            }
        }
        y = y + 40.0f;
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,y)];
        [scrollView setContentOffset:CGPointMake(0,0) animated:YES];    
        
    }
    
}

-(void)checkRecommendStatus
{
    activityIndicator.labelText = @"Loading";
    [activityIndicator show:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url;
    if([[defaults objectForKey:kUserTypeKey] intValue] == 0)
    {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@MenteeRecommendations?localAccount=%@&session=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@MentorRecommendations?localAccount=%@&session=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTimeOutSeconds:30];
    /*
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
        NSMutableDictionary *recommendInfo = [parser objectWithString:response];
        NSArray *keys = [recommendInfo allKeys];
        for(NSString *key in keys)
        {
            NSLog(@"key : %@",key);
        }
        
        NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
        if([[userDefautls objectForKey:kUserTypeKey] intValue] == 0)
        {
            NSMutableArray *pending_array = [[NSMutableArray alloc] init];
            NSMutableArray *waiting_array = [[NSMutableArray alloc] init];
            NSMutableArray *chatting_array = [[NSMutableArray alloc] init];
            NSMutableArray *pending = [recommendInfo objectForKey:[keys objectAtIndex:1]];
            NSMutableArray *waiting = [recommendInfo objectForKey:[keys objectAtIndex:0]];
            NSMutableArray *chatting = [recommendInfo objectForKey:[keys objectAtIndex:2]];
            
            for(NSMutableDictionary *info in pending)
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Grade"] intValue];
                user.school = [info objectForKey:@"School"];
                user.flag = 4;
                [pending_array addObject:user];
                [user release];
            }
            for(NSMutableDictionary *info in waiting)
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Grade"] intValue];
                user.school = [info objectForKey:@"School"];
                user.flag = 4;
                [waiting_array addObject:user];
                [user release];
            }
            for(NSMutableDictionary *info in chatting)
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Grade"] intValue];
                user.school = [info objectForKey:@"School"];
                user.flag = 4;
                [chatting_array addObject:user];
                [user release];
            }
            
            [appDelegate refreshRecommends:pending_array];
            [appDelegate refreshRecommendsWait:waiting_array];
            [appDelegate refreshRecommendsChat:chatting_array];
            [pending_array release];
            [waiting_array release];
            [chatting_array release];
            
        }
        else
        {
            NSMutableArray *pending_array = [[NSMutableArray alloc] init];
            NSMutableArray *chatting_array = [[NSMutableArray alloc] init];
            
            for(NSMutableDictionary *info in [recommendInfo objectForKey:@"PendingRecommendations"])
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Promo"] intValue];
                user.school = [info objectForKey:@"Univ"];
                user.major = [info objectForKey:@"Major"];
                user.flag = 4;
                [pending_array addObject:user];
                [user release];
            }
            
            for(NSMutableDictionary *info in [recommendInfo objectForKey:@"InProgressRecommendations"])
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Promo"] intValue];
                user.school = [info objectForKey:@"Univ"];
                user.major = [info objectForKey:@"Major"];
                user.flag = 4;
                [chatting_array addObject:user];
                [user release];
            }
            
            [appDelegate refreshRecommends:pending_array];
            [appDelegate refreshRecommendsChat:chatting_array];
            [pending_array release];
            [chatting_array release];
        }
        
        [parser release];
        
        UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
        
        UIViewController *viewController = [navigationController visibleViewController];
        if([viewController isKindOfClass:[RecommendViewController class]])
        {
            [self refresh];
        }
         
        [activityIndicator hide:YES];
    }];
    [request setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
														message:@"3G/WIFI 상태를 확인하세요."
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
        
		[alert release];
        [activityIndicator hide:YES];

    }];
     */
    [request setDidFailSelector:@selector(fail:)];
    [request setDidFinishSelector:@selector(success:)];
    [request startAsynchronous];

}
-(void)success:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
    NSMutableDictionary *recommendInfo = [parser objectWithString:response];
    NSArray *keys = [recommendInfo allKeys];
    
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    if([[userDefautls objectForKey:kUserTypeKey] intValue] == 0)
    {
        NSMutableArray *pending_array = [[NSMutableArray alloc] init];
        NSMutableArray *waiting_array = [[NSMutableArray alloc] init];
        NSMutableArray *chatting_array = [[NSMutableArray alloc] init];
        NSMutableArray *pending = [recommendInfo objectForKey:[keys objectAtIndex:1]];
        NSMutableArray *waiting = [recommendInfo objectForKey:[keys objectAtIndex:0]];
        NSMutableArray *chatting = [recommendInfo objectForKey:[keys objectAtIndex:2]];
        
        for(NSMutableDictionary *info in pending)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Grade"] intValue];
            user.school = [info objectForKey:@"School"];
            user.flag = 4;
            [pending_array addObject:user];
            [user release];
        }
        for(NSMutableDictionary *info in waiting)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Grade"] intValue];
            user.school = [info objectForKey:@"School"];
            user.flag = 4;
            [waiting_array addObject:user];
            [user release];
        }
        for(NSMutableDictionary *info in chatting)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Grade"] intValue];
            user.school = [info objectForKey:@"School"];
            user.flag = 4;
            [chatting_array addObject:user];
            [user release];
        }
        
        [appDelegate initRecommendation];
        [appDelegate refreshRecommends:pending_array];
        [appDelegate refreshRecommendsWait:waiting_array];
        [appDelegate initChatRoom];
        [appDelegate refreshRecommendsChat:chatting_array];
        [pending_array release];
        [waiting_array release];
        [chatting_array release];
        
    }
    else
    {
        NSMutableArray *pending = [recommendInfo objectForKey:[keys objectAtIndex:0]];
        NSMutableArray *chatting = [recommendInfo objectForKey:[keys objectAtIndex:1]];
        NSMutableArray *pending_array = [[NSMutableArray alloc] init];
        NSMutableArray *chatting_array = [[NSMutableArray alloc] init];
        
        for(NSMutableDictionary *info in pending)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Promo"] intValue];
            user.school = [info objectForKey:@"Univ"];
            user.major = [info objectForKey:@"Major"];
            
            [pending_array addObject:user];
            [user release];
        }
        
        for(NSMutableDictionary *info in chatting)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Promo"] intValue];
            user.school = [info objectForKey:@"Univ"];
            user.major = [info objectForKey:@"Major"];
            
            [chatting_array addObject:user];
            [user release];
        }
        [appDelegate initRecommendation];
        [appDelegate refreshRecommends:pending_array];
        [appDelegate initChatRoom];
        [appDelegate refreshRecommendsChat:chatting_array];
        [pending_array release];
        [chatting_array release];
    }
    
    [parser release];
    
    [self refresh];
    [activityIndicator hide:YES];
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];

}
-(void)fail:(ASIFormDataRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                    message:@"3G/WIFI 상태를 확인하세요."
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    
    [alert release];
    [activityIndicator hide:YES];
 
}

- (void)modalViewForImage:(id)sender
{
    MeepleProfileButton *b = sender;
    pictureViewController *pViewController= [[pictureViewController alloc] init];
    UIImage *i = b.imageView.image;
    pViewController.image = i;
    pViewController.userId = b.titleLabel.text;
    UINavigationController *loginViewNav = [[[UINavigationController alloc] initWithRootViewController:pViewController] autorelease];
    [pViewController release];
    [self presentModalViewController:loginViewNav animated:YES];
    
}

@end
