//
//  MessageWriteViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MessageWriteViewController.h"
#import "ASIFormDataRequest.h"
#import "MessageListViewController.h"

@implementation MessageWriteViewController
@synthesize userNick,userPic,message,userNickStr,userId,textViewBg;

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
    appDelegate = [[UIApplication sharedApplication] delegate];
    /* navigation Setting */
    UIImage *backButtonImage;
    if([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[MessageListViewController class]])
    {
        backButtonImage = [UIImage imageNamed:@"03_BackButton"];

    }
    else
    {
        backButtonImage = [UIImage imageNamed:@"BackButton"];
    }

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
    
    UIImage *sendButtonImage = [UIImage imageNamed:@"NavSendMessage2"];
    UIButton *sendButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton2.bounds = CGRectMake( 0, 2.0f, sendButtonImage.size.width, sendButtonImage.size.height);
    [sendButton2 addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton2 setImage:sendButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *sendBarButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton2];
    self.navigationItem.rightBarButtonItem=sendBarButton;
    [sendBarButton release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150.0f,28.0f)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:59.0f/255 green:66.0f/255 blue:90.0f/255 alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:19.0];
    titleLabel.text = @"쪽지 보내기";
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    /* Navigation Setting END */
    
    userPic.userId = userId;
    [userPic setImageFromServerCache];
    [[userPic layer] setCornerRadius:4.0f];
    [[userPic layer] setMasksToBounds:YES];
    
    isSending = 0; 
    userNick.text = userNickStr;

    message.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
    [textViewBg setImage:[[UIImage imageNamed:@"04_4_TextViewBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    
    [message becomeFirstResponder];
    
    activityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    activityIndicator.delegate = self;
    activityIndicator.labelText = @"Loading";
    
    [self.view addSubview:activityIndicator];
    
    
}

- (void)viewDidUnload
{
    self.message = nil;
    self.userPic = nil;
    self.userNick = nil;
    self.userNickStr = nil;
    self.userId = nil;
    self.textViewBg = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc 
{
    self.message = nil;
    self.userPic = nil;
    self.userNick = nil;
    self.userNickStr = nil;
    self.userId = nil;
    self.textViewBg = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super dealloc];
}

#pragma mark
#pragma - sendMessage

- (IBAction)sendMessage:(id)sender {
    if(isSending != 1) {
        isSending = 1;
        [activityIndicator show:YES];
        NSString *text = [message text];
        [message resignFirstResponder];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:
                      [[NSString stringWithFormat:@"%@SendMessage?localAccount=%@&oppoAccount=%@&session=%@&message=%@"
                        , kMeepleUrl
                        , [userDefaults objectForKey:kUserIdKey]
                        , userId
                        ,[userDefaults objectForKey:kSessionIdKey]
                        ,text] 
                       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        //[request setPostValue:userId forKey:@"user_id"];
        //[request setPostValue:text forKey:@"text"];
        [request setTimeOutSeconds:30];
        [request setCompletionBlock:^{
            isSending = 0;
            [activityIndicator hide:YES];
            /*
              성공이냐 실패이냐 여부
             */
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"쪽지 전송!"
                                                            message:@"쪽지 전송을 완료하였습니다.!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
            UIViewController *viewController = [navigationController visibleViewController];
            if([viewController isKindOfClass:[MessageWriteViewController class]])
            {
                [navigationController popViewControllerAnimated:YES];
            }
            
        }];
        [request setFailedBlock:^{
            isSending = 0;
            [activityIndicator hide:YES];
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"쪽지 전송!"
                                                            message:@"쪽지 전송을 실패하였습니다. 네트워크 상태를 확인하세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }];

        [request setDidFinishSelector:@selector(sendMessageFinished:)];
        [request setDidFailSelector:@selector(sendMessageFailed:)]; 
        [request startAsynchronous];
    }
}

/*
- (void)sendMessageFailed:(ASIFormDataRequest *)request 
{
    isSending = 0;
    [activityIndicator hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"쪽지 전송!"
                                                    message:@"쪽지 전송을 실패하였습니다. 네트워크 상태를 확인하세요!"
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessageFinished:(ASIFormDataRequest *)request
{
    isSending = 0;
    [activityIndicator hide:YES];
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"쪽지 전송!"
                                                    message:@"쪽지 전송을 완료하였습니다.!"
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
*/


- (IBAction)backgroundTap {
	[message resignFirstResponder];
}

-(void)backButtonPushed {
    [message resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
