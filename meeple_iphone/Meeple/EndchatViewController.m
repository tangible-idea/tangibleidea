//
//  EndchatViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "EndchatViewController.h"
#import "Chat.h"
#import "PopUpViewController.h"
#import "MessageWriteViewController.h"
#import "pictureViewController.h"

@implementation EndchatViewController
@synthesize chatRoom,user,beforeViewIndex,refreshSpinner, refreshHeaderView;

#define SPINNER_SIZE 13
#define FAIL_BUTTON_SIZE 23
#define KEYBOARDBAR_HEIGHT 38
#define OFFSET_HEIGHT 10

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
    [tbl release];
    tbl = nil;
    [messages release];
    messages = nil;
    self.chatRoom = nil;
    self.user = nil;
    [mainView release];
    mainView = nil;
    [activityIndicator release];
    activityIndicator = nil;
    self.refreshHeaderView = nil;
    self.refreshSpinner = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [tbl release];
    tbl = nil;
    [messages release];
    messages = nil;
    self.chatRoom = nil;
    self.user = nil;
    [mainView release];
    mainView = nil;
    [activityIndicator release];
    activityIndicator = nil;
    
    self.refreshHeaderView = nil;
    self.refreshSpinner = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(isFirst && [messages count]!=0) {
        [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] 
                   atScrollPosition:UITableViewScrollPositionTop
                           animated:NO];
        isFirst = NO;
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    /* 변수 초기화 */
    appDelegate = [[UIApplication sharedApplication] delegate];
    lastLocalNo = [appDelegate getChatCount:chatRoom.roomId];
    startLocalNo = lastLocalNo;
    lastDate = @"";
    firstDate = @"";
    isFirst = YES;
    
    /* navigation Setting */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150.0f,28.0f)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:1/255 green:143.0f/255 blue:225.0f/255 alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:22.0];
    titleLabel.text = user.name;
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIImage *backButtonImage;
    if(beforeViewIndex == 0)
    {
        backButtonImage = [UIImage imageNamed:@"BackButton"];
    }
    else
    {
        backButtonImage = [UIImage imageNamed:@"02_1_BackButton"];
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
    
    /* navigation Setting End */
    
    /* activity Indicator */
    activityIndicator = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
    activityIndicator.delegate = self;
    /* activity Indicator */
    
    CGRect selfFrame = self.view.frame;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selfFrame.size.width, selfFrame.size.height)];
    [bgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [bgView setImage:[UIImage imageNamed:@"03_Bg"]];
    [self.view addSubview:bgView];
    [bgView release];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0,selfFrame.size.width,selfFrame.size.height)];
    [mainView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:mainView];
    
    //table의 경우 navigationBar 에 의해 사이즈 자동 조절
    CGRect tblFrame = CGRectMake(0,10.0f,selfFrame.size.width,selfFrame.size.height-10.0f);
    
    
    //table//
    
    tbl = [[UITableView alloc] initWithFrame:tblFrame];
    tbl.delegate = self;
    tbl.dataSource = self;
    [mainView addSubview:tbl];
    
    
    messages = [[NSMutableArray alloc] init];
    
    tbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tbl setBackgroundColor:[UIColor clearColor]];
    
    startLocalNo = [appDelegate getFirstChatList:messages roomId:chatRoom.roomId lastLocalNo:lastLocalNo];
    
    if([messages count] != 0)
    {
        lastDate = ((Chat *)[messages lastObject]).date;
        firstDate = ((Chat *)[messages objectAtIndex:0]).text;
    }
    
    
    if([messages count]!=0 && (startLocalNo != 1))
    {
        [self addPullToRefreshHeader];
    }
    
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - pull to refresh

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - 30.0f, 320, 30.0f)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(30 - 20) / 2), floorf((30 - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    [refreshHeaderView addSubview:refreshSpinner];
    [tbl addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([messages count]==0 || (startLocalNo == 1)) return;
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([messages count]==0 || (startLocalNo == 1)) return;
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            tbl.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -30.0f)
            tbl.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([messages count]==0 || (startLocalNo == 1)) return;
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -30.0f) {
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    tbl.contentInset = UIEdgeInsetsMake(30.0f, 0, 0, 0);
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    [self getUnloadChat];
}

- (void)stopLoading {
    isLoading = NO;
    
    [tbl reloadData];
    [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-beforecount inSection:0] 
               atScrollPosition:UITableViewScrollPositionBottom
                       animated:NO];
    
    [refreshSpinner stopAnimating];
    //tbl.contentInset = UIEdgeInsetsZero;
}

- (void)getUnloadChat {
    /*
     * 예전 데이터 가져오기
     */
    id delegate = [[UIApplication sharedApplication] delegate];
    
    beforecount = [messages count];
    startLocalNo = [delegate getUnloadChatList:messages roomId:chatRoom.roomId firstDate:firstDate from:startLocalNo];
    firstDate = ((Chat *)[messages objectAtIndex:0]).text;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.01];
}


#pragma mark -
#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    UITableViewCell *cell;
        Chat *chat = [messages objectAtIndex:indexPath.row];
        
        if(chat.chatType ==0) // text
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            if([chat.interlocutor isEqualToString:[userDefaults objectForKey:kUserIdKey]]) {
                CellIdentifier = @"MyChatTextCell";
                UIImageView *balloonView;
                UILabel *label;
                UILabel *date;
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
                    balloonView.tag = 1;
                    
                    label = [[UILabel alloc] initWithFrame:CGRectZero];
                    label.backgroundColor = [UIColor clearColor];
                    label.tag = 2;
                    label.numberOfLines = 0;
                    label.lineBreakMode = UILineBreakModeCharacterWrap;
                    label.font = [UIFont systemFontOfSize:14.0];
                    
                    date = [[UILabel alloc] initWithFrame:CGRectZero];
                    date.backgroundColor = [UIColor clearColor];
                    date.tag = 3;
                    date.font = [UIFont systemFontOfSize:9.0];
                    
                    UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
                    message.tag = 0;
                    message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [message addSubview:balloonView];
                    [message addSubview:label];
                    [message addSubview:date];
                    [cell.contentView addSubview:message];
                    
                    [balloonView release];
                    [label release];
                    [date release];
                    [message release];
                }
                else
                {
                    balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
                    label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
                    date = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:3];
                }
                NSString *text;
                
                text = chat.text;
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0f, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                
                balloonView.frame = CGRectMake(cell.contentView.frame.size.width - (size.width + 15.0f+5.0f), 2.0f, size.width + 15.0f, size.height + 12.0f);
                balloonView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
                UIImage *balloon = [[UIImage imageNamed:@"02_RightChatBubble.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:19.0f];
                label.frame = CGRectMake(cell.contentView.frame.size.width - (size.width+5.0f+10.0f), 6.0f, size.width, size.height+1);
                label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleTopMargin;
                date.frame = CGRectMake(balloonView.frame.origin.x - (80.0f + 4.0f), size.height, 80.0f, 15.0f);
                date.textAlignment = UITextAlignmentRight;
                date.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleTopMargin;
                
                balloonView.image = balloon;
                label.text = text;
                date.text = @"오후 10:32";
                
            }
            else {
                CellIdentifier = @"YourChatTextCell";
                MeepleProfileButton *userPicButton;
                UIImageView *balloonView;
                UILabel *userName;
                UILabel *label;
                UILabel *date;
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
                    balloonView.tag = 1;
                    
                    label = [[UILabel alloc] initWithFrame:CGRectZero];
                    label.tag = 2;
                    label.numberOfLines = 0;
                    label.lineBreakMode = UILineBreakModeCharacterWrap;
                    label.font = [UIFont systemFontOfSize:14.0];
                    
                    userName = [[UILabel alloc] initWithFrame:CGRectZero];
                    userName.backgroundColor = [UIColor clearColor];
                    userName.tag = 5;
                    userName.font = [UIFont boldSystemFontOfSize:16.0];
                    
                    date = [[UILabel alloc] initWithFrame:CGRectZero];
                    date.backgroundColor = [UIColor clearColor];
                    date.tag = 3;
                    date.font = [UIFont systemFontOfSize:9.0];
                    
                    userPicButton = [MeepleProfileButton buttonWithType:UIButtonTypeCustom];
                    [userPicButton addTarget:self action:@selector(popUp) forControlEvents:UIControlEventTouchUpInside];
                    [userPicButton setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
                    
                    userPicButton.userId = user.userId;
                    [userPicButton setImageFromServerCache];
                    userPicButton.tag = 4;
                    
                    UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
                    message.tag = 0;
                    message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [message addSubview:balloonView];
                    [message addSubview:userPicButton];
                    [message addSubview:label];
                    [message addSubview:userName];
                    [message addSubview:date];
                    [cell.contentView addSubview:message];
                    
                    [balloonView release];
                    [label release];
                    [userName release];
                    [date release];
                    [message release];
                }
                else
                {
                    balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
                    label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
                    date = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:3];
                    userPicButton = (MeepleProfileButton *)[[cell.contentView viewWithTag:0] viewWithTag:4];
                    userName = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:5];
                }
                NSString *text;
                
                text = chat.text;
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0f, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                
                UIImage *balloon;
                
                userName.frame = CGRectMake(46.0f, 0.0f, 200.0f, 18.0f);
                userPicButton.frame = CGRectMake(4.0, 2.0, 35.0f , 35.0f);
                balloonView.frame = CGRectMake(41.0f, 18.0f + 2.0, size.width + 17, size.height + 12);
                balloonView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                balloon = [[UIImage imageNamed:@"02_LeftChatBubble.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:19];
                label.frame = CGRectMake(12.0f + 41.0f, 18.0f + 6.0f, size.width, size.height+1);
                label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                
                date.frame = CGRectMake(41.0f + size.width+ 20.0f, 18.0f+size.height, 80.0f, 15.0f);
                date.textAlignment = UITextAlignmentLeft;
                date.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;     
                
                userName.text = user.name;
                balloonView.image = balloon;
                label.text = text;
                date.text = @"오후 10:32";
            }
        }
        else {
            CellIdentifier = @"DateTextCell";
            UIImageView *dateView;
            UILabel *date;
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                dateView = [[UIImageView alloc] initWithFrame:CGRectZero];
                dateView.tag = 1;
                dateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                [dateView setFrame:CGRectMake(cell.frame.size.width/2 - 90.0f, 13.0f, 180.0f, 18.0f)];
                [dateView setImage:[UIImage imageNamed:@"02_1_DateBg"]];
                
                
                date = [[UILabel alloc] initWithFrame:cell.frame];
                date.backgroundColor = [UIColor clearColor];
                date.tag = 2;
                date.font = [UIFont systemFontOfSize:11.0];
                date.textColor = [UIColor whiteColor];
                date.textAlignment = UITextAlignmentCenter;
                date.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                
                UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
                message.tag = 0;
                message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [message addSubview:dateView];
                [message addSubview:date];
                [cell.contentView addSubview:message];
                
                [dateView release];
                [date release];
                [message release];
            }
            else
            {
                date = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
            }
            
            date.text = chat.text;
        }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *body;
    CGSize size;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    Chat *chat = [messages objectAtIndex:indexPath.row];
    if(chat.chatType == 0) {
        body = chat.text;
        size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0, 480.0) lineBreakMode:UILineBreakModeCharacterWrap];
        if([chat.interlocutor isEqualToString:[userDefaults objectForKey:kUserIdKey]]) 
        {
            
            return size.height + 20.0f;  
        } 
        else {
            return size.height + 42.0f;
        }
    }
    else if(chat.chatType == 3){ // 날짜
        return 42.0f;
    }
    else {
        return 0;
    }
    
}

#pragma mark - button

-(void)backButtonPushed 
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma - popup
-(void)popUp 
{
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
    userinfoView.tabNo = 1;
    
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

#pragma mark - pictureViewController userPic

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


-(void)popUpButtonPushed:(id)sender
{   
    NSString *buttonType = ((UIButton *)sender).titleLabel.text;
    id delegate = [[UIApplication sharedApplication] delegate];
    [[self.view viewWithTag:300] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
    if([buttonType isEqualToString:@"fav"]) 
    {
        [activityIndicator setLabelText:@"추가 중..."];
        [activityIndicator show:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@AddRelation?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],user.userId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setDelegate:self];
        [request setTimeOutSeconds:20];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            NSInteger status = [request responseStatusCode];
            if(status == 200)
            {
                if([response boolValue])
                {
                    user.flag = user.flag + 5;
                    [delegate updateUser:user];
                    
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
        messageWriteView.userNickStr = user.name;
        messageWriteView.userId = user.userId;
        [self.navigationController pushViewController:messageWriteView animated:YES];
        [messageWriteView release];
        
    }
    
}

@end
