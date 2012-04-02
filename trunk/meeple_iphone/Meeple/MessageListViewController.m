//
//  MessageListViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 28..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MessageListViewController.h"
#import "Message.h"
#import "MessageListCell.h"
#import "PopUpViewController.h"
#import "MessageWriteViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "pictureViewController.h"
#import "MeepleImage.h"
#import "MeepleImageData.h"

#define CONTENTSMAXWIDTH_PORTRAIT 235
#define CONTENTSMAXWIDTH_LANDSCAPE 387

@implementation MessageListViewController
@synthesize tbl,messages,read,selectedUserName,selectedUserId;
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

- (void)dealloc 
{
    [tbl release];
    self.tbl = nil;
    self.messages = nil;//[read release];
    self.read = nil;
    self.selectedUserId = nil;
    self.selectedUserName = nil;
    [userPictures release];
    userPictures = nil;
    [super dealloc]; 
}

- (void)viewDidUnload
{
    self.tbl = nil;
    self.messages = nil;
    self.read = nil;
    self.selectedUserId = nil;
    self.selectedUserName = nil;
    
    [userPictures release];
    userPictures = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self getMessagesFromServer];
    /*
    메세지 체크하기 
    */
    /*
    [messages removeAllObjects];
    [appDelegate getMessageList:messages];
    [tbl reloadData];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessagesFromServer) name:@"newMessage" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newMessage" object:nil];
    [appDelegate setMessagesRead:read];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        maxWidth = CONTENTSMAXWIDTH_LANDSCAPE;
    }
    else
    {
        maxWidth = CONTENTSMAXWIDTH_PORTRAIT;        
    }
    
    
    tbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    messages = [[NSMutableArray alloc] init];
    read = [[NSMutableArray alloc] init];
    
    
    
    tbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage *editButtonImage = [UIImage imageNamed:@"EditButton"];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.bounds = CGRectMake( 0, 0, editButtonImage.size.width, editButtonImage.size.height);
    [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:editButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem=editBarButton;
    [editBarButton release];
    
    userPictures = [[NSMutableDictionary alloc] init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate getMessageList:messages];
    [tbl reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        maxWidth = CONTENTSMAXWIDTH_LANDSCAPE;
    }
    else
    {
        maxWidth = CONTENTSMAXWIDTH_PORTRAIT;        
    }
    
    [tbl reloadData];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

//SYBAE
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"messageListCell";
    MessageListCell *cell = (MessageListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageListCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[MessageListCell class]])
                cell = (MessageListCell *)oneObject;
    }
    
    Message *message = (Message *)[messages objectAtIndex:indexPath.row];
    NSString *contentsText= message.text;
    
    NSString *headerText = message.name;
    if([headerText isEqualToString:@""])
    {
        headerText = message.senderId;
    }
    
    CGSize sizeContents = [contentsText sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(maxWidth, 4800.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    UIImage *balloon;
    
    if(message.isRead == 0)
    {
        balloon = [[UIImage imageNamed:@"03_2_NewMessageBubble"] stretchableImageWithLeftCapWidth:24 topCapHeight:27];
        message.isRead = 1;
        NSNumber *temp_no = [[NSNumber alloc] initWithInt:message.no];
        [read addObject:temp_no];
        [temp_no release];
        
    }
    else {
        balloon = [[UIImage imageNamed:@"03_2_MessageBubble"] stretchableImageWithLeftCapWidth:24 topCapHeight:27];
    }
/*
    if([message.senderId isEqualToString:[userDefaults objectForKey:kUserIdKey]])
    {
        [cell.from setImage:[UIImage imageNamed:@"03_To"]];
        headerText = [NSString stringWithFormat:@"%@ (나)",message.senderId];
        if([userPictures objectForKey:message.receiverId] == nil)
        {
            if (self.tbl.dragging == NO && self.tbl.decelerating == NO)
            {
                MeepleImage *image = [[MeepleImage alloc] init];
                image.userId = message.receiverId;
                [image setImageFromServerCache];
                [userPictures setObject:image forKey:message.receiverId];
                [cell.userPic setImage:image forState:UIControlStateNormal];
                [image release];
            }
            
            [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
        }
        else
        {
            MeepleImage *image = [userPictures objectForKey:message.receiverId];
            [cell.userPic setImage:image forState:UIControlStateNormal];
            
        }
        [cell.userPic setTitle:message.receiverId forState:UIControlStateNormal];
        
    }
    else
    {
        if([userPictures objectForKey:message.senderId] == nil)
        {
            if (self.tbl.dragging == NO && self.tbl.decelerating == NO)
            {
                MeepleImage *image = [[MeepleImage alloc] init];
                image.userId = message.senderId;
                [image setImageFromServerCache];
                [userPictures setObject:image forKey:message.senderId];
                [cell.userPic setImage:image forState:UIControlStateNormal];
                [image release];
            }
            
            [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
            
            
        }
        else
        {
            
            MeepleImage *image = [userPictures objectForKey:message.senderId];
            [cell.userPic setImage:image forState:UIControlStateNormal];
            
        }
        
        [cell.from setImage:[UIImage imageNamed:@"03_2_From"]];
        [cell.userPic setTitle:message.senderId forState:UIControlStateNormal];
    }
*/
    if([message.senderId isEqualToString:[userDefaults objectForKey:kUserIdKey]])
    {
        [cell.from setImage:[UIImage imageNamed:@"03_To"]];
        headerText = [NSString stringWithFormat:@"%@ (나)",message.senderId];
        if([userPictures objectForKey:message.receiverId] == nil)
        {
            if (self.tbl.dragging == NO && self.tbl.decelerating == NO)
            {
                MeepleImage *image = [[MeepleImage alloc] init];
                image.userId = message.receiverId;
                [image setImageFromServerCache];
                [userPictures setObject:image forKey:message.receiverId];
                [image release];
            }
            
            [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
        }
        else
        {
            MeepleImage *image = [userPictures objectForKey:message.receiverId];
            if(image.isUsed == 1)
            {
                [cell.userPic setImage:image forState:UIControlStateNormal];
            }
            else
            {
                [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
            }
        }
        [cell.userPic setTitle:message.receiverId forState:UIControlStateNormal];
        
    }
    else
    {
        if([userPictures objectForKey:message.senderId] == nil)
        {
            if (self.tbl.dragging == NO && self.tbl.decelerating == NO)
            {
                MeepleImage *image = [[MeepleImage alloc] init];
                image.userId = message.senderId;
                [image setImageFromServerCache];
                [userPictures setObject:image forKey:message.senderId];
                [image release];
            }
            
            [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
            
        }
        else
        {
            
            MeepleImage *image = [userPictures objectForKey:message.senderId];
            if(image.isUsed == 1)
            {
                [cell.userPic setImage:image forState:UIControlStateNormal];
            }
            else
            {
                [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"] forState:UIControlStateNormal];
            }
            
        }
        
        [cell.from setImage:[UIImage imageNamed:@"03_2_From"]];
        [cell.userPic setTitle:message.senderId forState:UIControlStateNormal];
    }
    cell.balloonView.frame = CGRectMake(cell.balloonView.frame.origin.x, cell.balloonView.frame.origin.y, cell.balloonView.frame.size.width, 24.0f + 5.0f + sizeContents.height + 10.0f);
    cell.contents.frame = CGRectMake(cell.contents.frame.origin.x, cell.contents.frame.origin.y, cell.contents.frame.size.width, sizeContents.height);
    
    cell.balloonView.image = balloon;
    cell.contents.text = contentsText;
    cell.header.text = headerText;
    cell.date.text = message.date;
    
    [cell.userPic addTarget:self action:@selector(popUp:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *body;
    body = [[messages objectAtIndex:indexPath.row] text];
    CGSize sizeBody = [body sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(maxWidth, 4800.0) lineBreakMode:UILineBreakModeCharacterWrap];
    if(sizeBody.height + 5.0f + 24 + 10.0f + 8.0f > 60.0f) {
        return sizeBody.height + 5.0f + 24 + 10.0f + 8.0f;
    }
    else {
        return 60.0f;
    }	
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(UITableViewCellEditingStyleDelete == editingStyle) {
        /* 삭제 과정 구현 */    
        id delegate = [[UIApplication sharedApplication] delegate];
        Message *message = [messages objectAtIndex:indexPath.row];
        [delegate deleteMessage:message.no];
        [messages removeObjectAtIndex:indexPath.row];
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        tbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}

- (void)toggleEdit:(id)sender {
    [self.tbl setEditing:!self.tbl.editing animated:YES];
    
    if(self.tbl.editing)
    {
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
        tbl.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    else 
    {
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"EditButton"] forState:UIControlStateNormal];
        tbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

#pragma mark - popUp

-(void)popUp:(id)sender
{
    NSString *senderId = ((UIButton *)sender).titleLabel.text;
    User *selectedUser = [[User alloc] init];
    selectedUser.userId = senderId;
    selectedUser.name = [NSString stringWithFormat:@""];
    [appDelegate getUser:selectedUser userId:senderId];
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
    
    userinfoView.user = selectedUser;
    
    selectedUserId = selectedUser.userId;
    selectedUserName = selectedUser.name;
    [selectedUser release];
    userinfoView.tabNo = 1;
    
    
    
    [userinfoView.view setFrame:self.view.frame];
    [self.view addSubview:userinfoView.view];
    userinfoView.view.tag = 300;
    userinfoView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [grayView release];
    [grayViewNav release];
    
}

-(void)popUpOut 
{
    [[self.view viewWithTag:300] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
}

/* 메세지 리스트의 경우 모든 유저가 페이보릿이라고 가정해도 된다 */
-(void)popUpButtonPushed:(id)sender 
{
    NSString *buttonType = ((UIButton *)sender).titleLabel.text;
    if([buttonType isEqualToString:@"fav"]) 
    {
        [activityIndicator setLabelText:@"추가 중..."];
        [activityIndicator show:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        __block ASIFormDataRequest *request;
        if([selectedUserName isEqualToString:@" "]==0 || selectedUserName == nil)
        {
            if([[userDefaults objectForKey:kUserTypeKey] intValue] == 0)
            {
                request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@AddRelationAndGetMenteeInfo?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],selectedUserId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setDelegate:self];
                [request setTimeOutSeconds:20];
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSInteger status = [request responseStatusCode];
                    if(status == 200)
                    {
                        SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
                        NSMutableDictionary *info = [parser objectWithString:response];
                        User *user = [[User alloc] init];
                        user.userId = [info objectForKey:@"AccountId"];
                        user.talk = [info objectForKey:@"Comment"];
                        user.name = [info objectForKey:@"Name"];
                        user.grade = [[info objectForKey:@"Grade"] intValue];
                        user.school = [info objectForKey:@"School"];
                        
                        NSMutableArray *temp_array = [[NSMutableArray alloc] init];
                        [temp_array addObject:user];
                        [user release];
                        
                        [appDelegate AddFavoriteList:temp_array];
                        [temp_array release];
                        [[self.view viewWithTag:300] removeFromSuperview];
                        [[self.view viewWithTag:200] removeFromSuperview];
                        [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
                        [parser release];
                         
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
            }
            else
            {
                request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@AddRelationAndGetMentorInfo?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],selectedUserId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setDelegate:self];
                [request setTimeOutSeconds:20];
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSInteger status = [request responseStatusCode];
                    if(status == 200)
                    {
                        SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
                        NSMutableDictionary *info = [parser objectWithString:response];
                        User *user = [[User alloc] init];
                        user.userId = [info objectForKey:@"AccountId"];
                        user.talk = [info objectForKey:@"Comment"];
                        user.name = [info objectForKey:@"Name"];
                        user.grade = [[info objectForKey:@"Promo"] intValue];
                        user.school = [info objectForKey:@"Univ"];
                        user.major = [info objectForKey:@"Major"];
                        
                        NSMutableArray *temp_array = [[NSMutableArray alloc] init];
                        [temp_array addObject:user];
                        [user release];
                        
                        [appDelegate AddFavoriteList:temp_array];
                        [temp_array release];
                        
                        [[self.view viewWithTag:300] removeFromSuperview];
                        [[self.view viewWithTag:200] removeFromSuperview];
                        [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
                        [parser release];
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
            };
        }
        else
        {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@AddRelation?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],selectedUserId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [request setDelegate:self];
            [request setTimeOutSeconds:20];
            [request setCompletionBlock:^{
                NSString *response = [request responseString];
                NSInteger status = [request responseStatusCode];
                if(status == 200)
                {
                    if([response boolValue])
                    {
                        User *selectedUser = [[User alloc] init];
                        [appDelegate getUser:selectedUser userId:selectedUserId];
                        selectedUser.flag = selectedUser.flag + 5;
                        [appDelegate updateUser:selectedUser];
                        [selectedUser release];
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
        }
        
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
        messageWriteView.userNickStr = selectedUserName;
        messageWriteView.userId = selectedUserId;
        [self.navigationController pushViewController:messageWriteView animated:YES];
        [messageWriteView release];
        
        [[self.view viewWithTag:300] removeFromSuperview];
        [[self.view viewWithTag:200] removeFromSuperview];
        [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
    }
    
}

-(void)getMessagesFromServer
{
    totalCount = [appDelegate getMessagesCount];
    if(totalCount > 0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetMessages?localAccount=%@&session=%@&messageId=%d",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey],totalCount] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setCompletionBlock:^{
            
            NSString *responds = [request responseString];
            SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
            NSMutableArray *get_messagelist = [parser objectWithString:responds];
            NSMutableArray *temp_array = [[NSMutableArray alloc] init];
            for(NSMutableDictionary *info in get_messagelist)
            {
                Message *message = [[Message alloc] init];
                message.date = [info objectForKey:@"dateTime"];
                message.senderId = [info objectForKey:@"senderAccount"];
                message.receiverId = [info objectForKey:@"receiverAccount"];
                message.text = [info objectForKey:@"message"];
                if([message.senderId isEqualToString:[userDefaults objectForKey:kUserIdKey]])
                {
                    message.isRead = 1;
                }
                else
                {
                    message.isRead = 0;
                }
                
                [temp_array addObject:message];
                [message release];
            }
            
            [appDelegate insertMessages:temp_array];
            [temp_array release];
            temp_array = nil;
            [parser release];
            [[[[[appDelegate tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            
            UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
            
            UIViewController *viewController = [navigationController visibleViewController];
            if([viewController isKindOfClass:[MessageListViewController class]])
            {
                [(MessageListViewController *)viewController refresh];
                
            }
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
            
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }];
        
        [request startAsynchronous];
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetMessagesFirst?localAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setCompletionBlock:^{
            
            NSString *responds = [request responseString];
            SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
            NSMutableArray *get_messagelist = [parser objectWithString:responds];
            NSMutableArray *temp_array = [[NSMutableArray alloc] init];
            int i = 0;
            for(NSMutableDictionary *info in get_messagelist)
            {
                if(i==0)
                {
                    i = [[info objectForKey:@"localNo"] intValue]; 
                }
                Message *message = [[Message alloc] init];
                message.date = [info objectForKey:@"dateTime"];
                message.senderId = [info objectForKey:@"senderAccount"];
                message.receiverId = [info objectForKey:@"receiverAccount"];
                message.text = [info objectForKey:@"message"];
                if([message.senderId isEqualToString:[userDefaults objectForKey:kUserIdKey]])
                {
                    message.isRead = 1;
                }
                else
                {
                    message.isRead = 0;
                }
                
                [temp_array addObject:message];
                [message release];
            }
            [parser release];
            if(i > 0)
            {
                [appDelegate updateMessagesCount:i-1];
            }
            [appDelegate insertMessages:temp_array];
            [temp_array release];
            temp_array = nil;
            
            [[[[[appDelegate tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
            
            UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
            
            UIViewController *viewController = [navigationController visibleViewController];
            if([viewController isKindOfClass:[MessageListViewController class]])
            {
                [(MessageListViewController *)viewController refresh];
                
            }
            
            [[self.tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:nil];
            
        }];
        [request setFailedBlock:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"접속 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }];
        
        [request startAsynchronous];
    }
}

-(void)refresh
{
    [messages removeAllObjects];
    [appDelegate getMessageList:messages];
    [tbl reloadData];
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

#pragma mark - 

- (void)loadImagesForOnscreenRows
{
    if ([userPictures count] > 0)
    {
        NSArray *visiblePaths = [self.tbl indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MeepleProfileButton *button = ((MessageListCell *)[self.tbl cellForRowAtIndexPath:indexPath]).userPic;
            if ([userPictures objectForKey:button.userId]!=nil) // avoid the app icon download if the app already has an icon
            {
                MeepleImage *imageData = (MeepleImage *)[userPictures objectForKey:button.userId];
                if(imageData.isUsed ==1)
                    [button setImage:imageData forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
