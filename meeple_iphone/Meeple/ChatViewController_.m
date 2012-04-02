//
//  ChatViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController_.h"
#import "Chat.h"
#import "PopUpViewController.h"
#import "MessageWriteViewController.h"
#import "SendingChatRequest.h"
#import "SBJson.h"
#import "MeepleProfileButton.h"
#import "pictureViewController.h"

@implementation ChatViewController_
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
    [tempMessages release];
    tempMessages = nil;
    [keyboardBar release];
    keyboardBar = nil;
    [keyboard release];
    keyboard = nil;
    self.chatRoom = nil;
    self.user = nil;
    [mainView release];
    mainView = nil;
    
    self.refreshHeaderView = nil;
    self.refreshSpinner = nil;
    
    [activityIndicator release];
    activityIndicator = nil;
    
    [senderImageButton release];
    senderImageButton = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [tbl release];
    tbl = nil;
    [keyboardBar release];
    keyboardBar = nil;
    [messages release];
    messages = nil;
    [tempMessages release];
    tempMessages = nil;
    [keyboardBar release];
    keyboardBar = nil;
    [keyboard release];
    keyboard = nil;
    self.chatRoom = nil;
    self.user = nil;
    [mainView release];
    mainView = nil;
    
    self.refreshHeaderView = nil;
    self.refreshSpinner = nil;
    
    [activityIndicator release];
    activityIndicator = nil;
    
    [senderImageButton release];
    senderImageButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(isFirst && [messages count]!=0) {
        [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tempMessages count]+[messages count]-1 inSection:0] 
                   atScrollPosition:UITableViewScrollPositionTop
                           animated:NO];
        isFirst = NO;
    }
    
    /*
     통신하는 쪽 // 
     */
    /*
    id appdelegate = [[UIApplication sharedApplication] delegate];
    
    lastLocalNo = [appdelegate getNewChatList:messages roomId:chatRoom.roomId lastLocalNo:lastLocalNo lastDate:lastDate];
    */
    /*
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
                                           [NSURl URLWithString:[NSString stringWithFormat:@"%@GetChats?localAccount=%@&session%@&chatId=%@",
    */
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisaapear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewChat) name:@"newChat" object:nil];
    [self getNewChat];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newChat" object:nil];

    if([messages count]!=0) {
        Chat *chat = [messages objectAtIndex:[messages count]-1];
        chatRoom.date = [NSString stringWithFormat:@"%@ %@", chat.date, chat.time];
        //chatRoom.date = [NSString stringWithFormat:@"%@", chat.date];
        chatRoom.lastMessage = chat.text;
        //chatRoom.unreadCount = 0;
    }
    [appDelegate updateChatRoom:chatRoom];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    senderImageButton = [MeepleProfileButton buttonWithType:UIButtonTypeCustom];
    senderImageButton.userId = user.userId;
    [senderImageButton setImageFromServerCache];
    [senderImageButton setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
    [senderImageButton addTarget:self action:@selector(popUp) forControlEvents:UIControlEventTouchUpInside];
    [senderImageButton retain];
    
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
    
    UIImage *endButtonImage = [UIImage imageNamed:@"02_1_EndButton"];
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    endButton.bounds = CGRectMake( 0, 0, endButtonImage.size.width, endButtonImage.size.height);
    
    [endButton addTarget:self action:@selector(endButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    [endButton setImage:endButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *endBarButton = [[UIBarButtonItem alloc] initWithCustomView:endButton];
    self.navigationItem.rightBarButtonItem=endBarButton;
    [endBarButton release];
    /* navigation Setting End */
    
    /* activity Indicator */
    activityIndicator = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
    activityIndicator.delegate = self;
    /* activity Indicator */
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
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
    CGRect tblFrame = CGRectMake(0,10.0f,selfFrame.size.width,selfFrame.size.height-KEYBOARDBAR_HEIGHT-OFFSET_HEIGHT);
    // UIView 의 경우 tableView의 height이 navigationBar Frame에 의해 조절되므로 그 점을 고려하여 origin.y 을 생각해야함
    CGRect keyboardBarFrame = CGRectMake(0, -navFrame.size.height + tblFrame.size.height + OFFSET_HEIGHT,selfFrame.size.width,38.0f);
    CGRect keyboardFrame = CGRectMake(10.0f,6.0f,240.0f,26.0f);
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        keyboardBarFrame = CGRectMake(0,tblFrame.size.width-KEYBOARDBAR_HEIGHT-navFrame.size.height,selfFrame.size.height, KEYBOARDBAR_HEIGHT);
        keyboardFrame = CGRectMake(keyboardFrame.origin.x, keyboardFrame.origin.y, 400.0f, 26.0f);
    }
    
    
    //table//
    
    tbl = [[UITableView alloc] initWithFrame:tblFrame];
    tbl.delegate = self;
    tbl.dataSource = self;
    [mainView addSubview:tbl];
    
    //keyboardBar //
    
    
    keyboardBar = [[UIView alloc] initWithFrame:keyboardBarFrame] ;
    UIImageView *keyboardBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,keyboardBar.frame.size.width,keyboardBar.frame.size.height)];
    
    [keyboardBarBg setImage:[UIImage imageNamed:@"02_1_KeyboardBarBg"]];
    [keyboardBarBg setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [keyboardBar addSubview:keyboardBarBg];
    [keyboardBarBg release];
    [mainView addSubview:keyboardBar];
    
    //keyboard //
    keyboard = [[UIExpandingTextView alloc] initWithFrame:keyboardFrame] ;
    [keyboard setMinimumNumberOfLines:1];
    [keyboard setMaximumNumberOfLines:3];
    keyboard.delegate = self;
    keyboard.backgroundColor = [UIColor clearColor];
    keyboard.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [keyboardBar addSubview:keyboard];
    
    //send Button
    UIImage *sendButtonImage = [UIImage imageNamed:@"02_1_SendButton"];
    send = [UIButton buttonWithType:UIButtonTypeCustom];
    [send setImage:sendButtonImage forState:UIControlStateNormal];
    [send setImage:[UIImage imageNamed:@"02_1_SendButtonHighlight"] forState:UIControlStateHighlighted];
    [send setImage:[UIImage imageNamed:@"02_1_NoSendButton"] forState:UIControlStateDisabled];
    send.enabled = NO;
    send.frame = CGRectMake(keyboardFrame.size.width + keyboardFrame.origin.x + 6.0f,7.0f,sendButtonImage.size.width,sendButtonImage.size.height);
    [send addTarget:self action:@selector(sendButtonDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardBar addSubview:send];
    
    messages = [[NSMutableArray alloc] init];
    tempMessages = [[NSMutableArray alloc] init];
    
    // 제스쳐 추가하기 (바탕화면 탭하면 키보드가 내려가게)
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [tbl addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    tbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tbl setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // SYBAE
    
    [tbl setBackgroundColor:[UIColor clearColor]];
    
    
    // 25개의 채팅 중 , 처음 채팅의 인덱스 (즉 스크롤 상단에 위치한) startLocalNo
    startLocalNo = [appDelegate getFirstChatList:messages roomId:chatRoom.roomId lastLocalNo:lastLocalNo];
    
    [appDelegate getTempChatList:tempMessages roomId:chatRoom.roomId];
    
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect selfFrame = mainView.frame;
    CGRect tblFrame = tbl.frame;
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [keyboardBar setFrame:CGRectMake(0, tblFrame.size.height + OFFSET_HEIGHT ,selfFrame.size.width,KEYBOARDBAR_HEIGHT)];
            [keyboard setFrame:CGRectMake(10.0f,6.0f,240.0f,35.0f)];
            [send setFrame:CGRectMake(keyboard.frame.size.width + keyboard.frame.origin.x + 6.0f,7.0f,55.0f,26.0f)];
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [keyboardBar setFrame:CGRectMake(0,tblFrame.size.height + OFFSET_HEIGHT ,selfFrame.size.width, KEYBOARDBAR_HEIGHT)];
            [keyboard setFrame:CGRectMake(10.0f, 6.0f, 400.0f, 35.0f)];
            [send setFrame:CGRectMake(keyboard.frame.size.width + keyboard.frame.origin.x + 6.0f,7.0f,55.0f,26.0f)];
            break;
        default:
            break;
    }
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
               atScrollPosition:UITableViewScrollPositionTop
                       animated:NO];
   
    [refreshSpinner stopAnimating];
    tbl.contentInset = UIEdgeInsetsZero;
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
    return [messages count] + [tempMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if([messages count] == 0 || indexPath.row >= [messages count]) // get TempMessages
    {   
        TempChat *chat = [tempMessages objectAtIndex:indexPath.row-[messages count]];
        if(chat.chatType == 0) 
        {
            if(chat.isFail == 0) {
                CellIdentifier = @"CellTextIndicator";
                UIImageView *balloonView;
                UILabel *label;
                UIActivityIndicatorView *spinner;
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
                    
                    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    spinner.tag = 3;
                    spinner.hidesWhenStopped = TRUE;
                    
                    UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
                    message.tag = 0;
                    message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [message addSubview:balloonView];
                    [message addSubview:label];
                    [message addSubview:spinner];
                    [cell.contentView addSubview:message];
                    
                    [balloonView release];
                    [label release];
                    [spinner release];
                    [message release];
                }
                else
                {
                    balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
                    label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
                    spinner = (UIActivityIndicatorView *)[[cell.contentView viewWithTag:0] viewWithTag:3];
                }
                NSString *text= chat.text;
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0f, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                
                UIImage *balloon;
                balloonView.frame = CGRectMake(cell.contentView.frame.size.width - (size.width + 15.0f+5.0f), 2.0f, size.width + 15.0f, size.height + 12.0f);
                balloonView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
                balloon = [[UIImage imageNamed:@"02_RightChatBubble.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:19.0f];
                label.frame = CGRectMake(cell.contentView.frame.size.width - (size.width+5.0f+10.0f), 6.0f, size.width, size.height+1);
                label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleTopMargin;
                
                [spinner setFrame:CGRectMake(cell.contentView.frame.size.width - (size.width+28.0f) - (SPINNER_SIZE), size.height-2, SPINNER_SIZE, SPINNER_SIZE)];
                
                spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [spinner startAnimating];
                balloonView.image = balloon;
                label.text = text;
            }
            else { // Fail ! 
                CellIdentifier = @"CellTextFail";
                UIImageView *balloonView;
                UILabel *label;
                UIButton *failButton;
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
                    
                    failButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    failButton.tag = 3;
                    
                    [failButton setImage:[UIImage imageNamed:@"02_1_FailButton"] forState:UIControlStateNormal];
                    [failButton addTarget:self action:@selector(failButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
                    message.tag = 0;
                    message.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [message addSubview:balloonView];
                    [message addSubview:label];
                    [message addSubview:failButton];
                    [cell.contentView addSubview:message];
                    
                    [balloonView release];
                    [label release];
                    [message release];
                }
                else
                {
                    balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
                    label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
                    failButton = (UIButton *)[[cell.contentView viewWithTag:0] viewWithTag:3];
                }
                NSString *text= chat.text;
                
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0f, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                
                UIImage *balloon;
                balloonView.frame = CGRectMake(cell.contentView.frame.size.width - (size.width + 15.0f+5.0f), 2.0f, size.width + 15.0f, size.height + 12.0f);
                balloonView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
                balloon = [[UIImage imageNamed:@"02_RightChatBubble.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:19.0f];
                label.frame = CGRectMake(cell.contentView.frame.size.width - (size.width+5.0f+10.0f), 6.0f, size.width, size.height+1);
                label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleTopMargin;
                [failButton setFrame:CGRectMake(cell.contentView.frame.size.width - (size.width + 28.0f + FAIL_BUTTON_SIZE), size.height - 10, FAIL_BUTTON_SIZE, FAIL_BUTTON_SIZE)];
                
                failButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                failButton.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row-[messages count]];
                balloonView.image = balloon;
                label.text = text;
            }
        }
    }
    else {
    
    Chat *chat = [messages objectAtIndex:indexPath.row];
    
    if(chat.chatType ==0) // text
    {
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
                date.textColor = [UIColor colorWithRed:70.0f/255 green:70.0f/255 blue:70.0f/255 alpha:1.0f];
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
            date.text = chat.time;
            
        }
        else {
            CellIdentifier = @"YourChatTextCell";
            UIButton *userPicButton;
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
                date.textColor = [UIColor colorWithRed:70.0f/255 green:70.0f/255 blue:70.0f/255 alpha:1.0f];
                
                userPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [userPicButton addTarget:self action:@selector(popUp) forControlEvents:UIControlEventTouchUpInside];
                userPicButton.tag = 4;
                [userPicButton setImage:senderImageButton.imageView.image forState:UIControlStateNormal];
                
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
            //[[userPicButton layer] setCornerRadius:4.0f];
            //[[userPicButton layer] setMasksToBounds:YES];
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
            date.text = chat.time;
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
}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *body;
    CGSize size;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(indexPath.row < [messages count]) {
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
    else {
        TempChat *tempChat = [tempMessages objectAtIndex:indexPath.row-[messages count]];
        if(tempChat.chatType == 0) {
            body = tempChat.text;
            size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0, 480.0) lineBreakMode:UILineBreakModeCharacterWrap];
        }
        return (size.height + 20.0f);
    }
    
    /*
    //else {
       //SendingNetwork *sendingObject = [temp_messages objectAtIndex:indexPath.row - [messages count]];
       //if(sendingObject.temp.chatType == 0) {
        NSInteger isFail = 0;
        if(isFail == 0) {
        Chat *chat = [messages objectAtIndex:indexPath.row];
        //body = sendingObject.temp.text;
            body = chat.text;
            size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                return size.height + 20.0f;
        }
        else {
            Chat *chat = [messages objectAtIndex:indexPath.row];
            body = chat.text;
            size = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(190.0, 1200.0f) lineBreakMode:UILineBreakModeCharacterWrap];
                return size.height + 20.0f;
        }
    //}
    */
}

#pragma mark - for keyboard

- (IBAction)keyboardAppear:(NSNotification*)sender 
{
    [self scrollViewForKeyboard:sender up:YES]; 
}

-(IBAction)keyboardDisaapear:(NSNotification*)sender 
{
    [self scrollViewForKeyboard:sender up:NO];
}

- (void) scrollViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        keyboardFrame = CGRectMake(keyboardFrame.origin.x, keyboardFrame.origin.y, keyboardFrame.size.height, keyboardFrame.size.width);
    }
    if(up == YES) {
        [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y - (keyboardFrame.size.height), mainView.frame.size.width, mainView.frame.size.height)];
        [tbl setContentInset:UIEdgeInsetsMake(tbl.contentInset.top + keyboardFrame.size.height,0,0,0)];
        [tbl setScrollIndicatorInsets:UIEdgeInsetsMake(tbl.scrollIndicatorInsets.top + keyboardFrame.size.height, 0, 0, 0)];
    }
    else {
        [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y + keyboardFrame.size.height, mainView.frame.size.width, mainView.frame.size.height)];
        [tbl setContentInset:UIEdgeInsetsMake(tbl.contentInset.top - keyboardFrame.size.height,0,0,0)];
        [tbl setScrollIndicatorInsets:UIEdgeInsetsMake(tbl.scrollIndicatorInsets.top - keyboardFrame.size.height,0,0,0)];
        
    }
    
    [UIView commitAnimations];
}
- (void)backgroundTap:(UIGestureRecognizer *)gesture {
    // tap 하면 keyboard hide
    [keyboard resignFirstResponder];
}

#pragma mark - UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (keyboard.frame.size.height - height);
    //[self.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + diff ,self.view.frame.size.width,self.view.frame.size.height)];
    [mainView setFrame:CGRectMake(mainView.frame.origin.x,mainView.frame.origin.y + diff ,mainView.frame.size.width,mainView.frame.size.height)];
    [tbl setContentInset:UIEdgeInsetsMake(tbl.contentInset.top - diff, 0, 0, 0)];
    [tbl setScrollIndicatorInsets:UIEdgeInsetsMake(tbl.scrollIndicatorInsets.top - diff, 0, 0, 0)];
    [keyboardBar setFrame:CGRectMake(keyboardBar.frame.origin.x,keyboardBar.frame.origin.y,keyboardBar.frame.size.width,keyboardBar.frame.size.height - diff)];
    
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0) {
        send.enabled = YES;
    }
    else {
        send.enabled = NO;
    }
    
}

#pragma mark - button
// ASIformdata request
- (void)sendButtonDidPushed:(id)sender {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    TempChat *tempChat = [[TempChat alloc] init];
    tempChat.text = [keyboard text];
    tempChat.chatType = 0;
    tempChat.interlocutor = [userDefaults objectForKey:kUserIdKey];
    tempChat.isFail = 0;
    
    [keyboard resignFirstResponder];
    [keyboard setText:@""];
    [appDelegate insertTempChat:tempChat roomId:chatRoom.roomId];
    
    
    NSURL *url = [NSURL URLWithString:[
                                       [NSString stringWithFormat:@"%@SendChatNew?localAccount=%@&oppoAccount=%@&session=%@&chat=%@",
                                        kMeepleUrl,
                                        [userDefaults objectForKey:kUserIdKey],
                                        user.userId,
                                        [userDefaults objectForKey:kSessionIdKey],tempChat.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    __block SendingChatRequest *request = [SendingChatRequest requestWithURL:url];
    
    request.roomId = chatRoom.roomId;
    request.no = tempChat.no;
    //[request setPostValue:tempChat.text forKey:@"text"];
    [request setTimeOutSeconds:40];
    [tempChat release];
    [request setShouldAttemptPersistentConnection:NO];
    [request startAsynchronous];
    
    [tempMessages removeAllObjects];
    [appDelegate getTempChatList:tempMessages roomId:chatRoom.roomId];
    [tbl reloadData];
    if([tempMessages count] + [messages count] >= 1)
    {
        [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tempMessages count]+[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    //[self performSelector:@selector(getNewChat) withObject:nil afterDelay:0.1];
     
     //[tbl reloadData];
    /*
     SendingNetwork *sendingData = [[SendingNetwork alloc] init];
     sendingData.temp = temp;
     //sendingData.chat = chat;
     //sendingData.sendData = chatData;
     sendingData.delegate = self;
     UIProgressView *tempProgresView = [[UIProgressView alloc] init];
     sendingData.progressView = tempProgresView;
     [tempProgresView release];
     [temp release];
     //[chat release];
     [temp_messages addObject:sendingData];
     [tbl reloadData];
     [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[temp_messages count]+[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
     [sendingData sendText];
     [sendingData release];
     */

}
-(void)getNewChat
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[
                                       [NSString stringWithFormat:@"%@GetChatsNew?localAccount=%@&oppoAccount=%@&session=%@&chatId=%d",
                                        kMeepleUrl,
                                        [userDefaults objectForKey:kUserIdKey],
                                        user.userId,
                                        [userDefaults objectForKey:kSessionIdKey],
                                        lastLocalNo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setDelegate:self];
    [request setTimeOutSeconds:30];
    [request setFailedBlock:^{}];
    [request setCompletionBlock:^{
        NSInteger statusCode = [request responseStatusCode];
        if(statusCode == 200)
        {
            NSInteger roomNo = chatRoom.roomId;
            NSString *response = [request responseString];
            SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
            NSMutableArray *chat_list = [parser objectWithString:response];
            NSMutableArray *insert_list = [[NSMutableArray alloc] init];
            for(NSDictionary *user_info in chat_list)
            {
                Chat *chat = [[Chat alloc] init];
                chat.roomId = roomNo;
                chat.text = [user_info objectForKey:@"chat"];
                chat.localNo = ((NSString *)[user_info objectForKey:@"chatId"]).intValue;
                chat.interlocutor = [user_info objectForKey:@"senderAccount"];
                chat.text = [user_info objectForKey:@"chat"];
                NSString *date = [user_info objectForKey:@"dateTime"];
                chat.date = [date substringToIndex:10];
                chat.time = [date substringFromIndex:11];

                [insert_list addObject:chat];
                [chat release];
            }
            
            [appDelegate insertChatWithNo:insert_list roomId:roomNo];
            [insert_list release];
            [parser release];
            UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
            
            UIViewController *viewController = [navigationController visibleViewController];
            if([viewController isKindOfClass:[ChatViewController_ class]])
            {
                [(ChatViewController_ *)viewController refresh];
                ((ChatViewController_ *)viewController).chatRoom.unreadCount = 0;
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 오류"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    
    [request startAsynchronous];
    
}
-(void)backButtonPushed 
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)failButtonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tempMessageIndex = [button.titleLabel.text intValue];
    TempChat *chat = [tempMessages objectAtIndex:tempMessageIndex];
    selectedFailMessageNo = chat.no;
    selectedFailMessageIndex = tempMessageIndex;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"삭제하기",@"재전송", nil];
    [sheet showInView:self.view];
    [sheet release];
}

-(void)endButtonPushed:(id)sender {
    // user 가 임 즐겨찾기일 경우는 ? //
    UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:@"멘토-멘티 대화를 종료하시겠습니까?" message:@"종료 후 다시 대화할 수 없게됩니다. \n 즐겨찾기에 등록 한 경우에 한하여 \n쪽지를 주고 받을 수 있습니다. \n정말 종료하시겠습니까? " delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"종료", nil];
        
    [alert show];
    [alert release];
}

#pragma - alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex!=alertView.cancelButtonIndex) {
            // 종료
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@CloseChatting?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],user.userId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        activityIndicator.labelText = @"종료중입니다...";
        [activityIndicator show:YES];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setTimeOutSeconds:20];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"종료 오류"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            [activityIndicator hide:YES];
        }];
        [request setCompletionBlock:^{
            NSInteger status = [request responseStatusCode];
            NSString *response = [request responseString];
            if(status == 200)
            {
                if([response boolValue])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    chatRoom.status = 1;
                    [appDelegate updateChatRoom:chatRoom];
                    
                    user.flag = user.flag + 1;
                    [appDelegate updateUser:user];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"종료 오류"
                                                                    message:@"서버 에러입니다. 불편을 끼쳐드려서 죄송합니다."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인!" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"종료 오류"
                                                                message:@"3G/WIFI 상태를 확인하세요."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [activityIndicator hide:YES];
        }];
        [request startAsynchronous];
    }
}

#pragma - actionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex) 
    {
        if(buttonIndex == 0) // 삭제하기
        {
            [appDelegate deleteTempChat:selectedFailMessageNo roomId:chatRoom.roomId];
            [self refresh];
        }
        else if(buttonIndex == 1) // 재전송
        {
            TempChat *tempChat = [tempMessages objectAtIndex:selectedFailMessageIndex];
            tempChat.isFail = 0;
            [appDelegate setResendTempChatWithNo:tempChat.no roomId:chatRoom.roomId];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:[
                                               [NSString stringWithFormat:@"%@SendChatNew?localAccount=%@&oppoAccount=%@&session=%@&chat=%@",
                                                kMeepleUrl,
                                                [userDefaults objectForKey:kUserIdKey],
                                                user.userId,
                                                [userDefaults objectForKey:kSessionIdKey],tempChat.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            SendingChatRequest *request = [SendingChatRequest requestWithURL:url];
            request.roomId = chatRoom.roomId;
            request.no = tempChat.no;
            //[request setPostValue:tempChat.text forKey:@"text"];
            //[request setDelegate:request];
            [request startAsynchronous];
            [tbl reloadData];
            
        }
    }
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

#pragma mark - refresh

-(void)refresh
{
    [tempMessages removeAllObjects];
    [appDelegate getTempChatList:tempMessages roomId:chatRoom.roomId];
    [appDelegate getNewChatList:messages roomId:chatRoom.roomId lastLocalNo:lastLocalNo lastDate:lastDate];
    
    lastLocalNo = [appDelegate getChatCount:chatRoom.roomId];
    if([messages count]>=1)
    {
        lastDate = ((Chat *)[messages objectAtIndex:[messages count]-1]).date;
    }
    [tbl reloadData];
    if([tempMessages count] + [messages count] >= 1)
    {
        [tbl scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tempMessages count]+[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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
