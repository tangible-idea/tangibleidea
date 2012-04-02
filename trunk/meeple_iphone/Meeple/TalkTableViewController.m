//
//  TalkTableViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "TalkTableViewController.h"
#import "ChatRoom.h"
#import "User.h"
#import "MyTalkTableViewCell.h"
#import "ChatViewController_.h"
#import "EndchatViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MeepleImageView.h"

@implementation TalkTableViewController
@synthesize tbl;

#define CELL_HEIGHT 75
#define HEADER_HEIGHT 23
#define TALK_NOW 0
#define TALK_FINISH 1


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
- (void)viewDidUnload
{
    [sectionList release];
    sectionList = nil;
    [dataSource release];
    dataSource = nil;
    self.tbl = nil;
    [dateFormatter release];
    dateFormatter = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
}

- (void)dealloc 
{
    
    [dataSource release];
    dataSource = nil;
    [sectionList release];
    sectionList = nil;
    self.tbl = nil;
    [dateFormatter release];
    dateFormatter = nil;
    [activityIndicator release];
    activityIndicator = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    activityIndicator.delegate = self;
    activityIndicator.labelText = @"서버와 통신 중...";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    /* 날짜 설정하기 */

    dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *krTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Seoul"];
    [dateFormatter setTimeZone:krTimeZone];
    NSLocale *pLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko-KR"];
    [dateFormatter setLocale:pLocale];
    [pLocale release];
    [dateFormatter setDateFormat:@"yyyy.MM.dd a H:mm"];
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    mType = [(NSNumber *)[info objectForKey:kUserTypeKey] intValue];
    
    self.navigationController.navigationBarHidden = NO;
    /* 
     
     구현이 필요한 부분 
     
     멘토 멘티 여부 확인 후 
     대화리스트 받아오기 (멘토 최대 3개 멘티 최대 1개)
     이미 클라이언트에 대화리스트가 있다면 대화리스트 그대로~
     서버와 통신하여 대화리스트 받아오기, 아마 서버와 통신하여 update 하는 것은 현재 채팅중인 방만 하면 될듯
     */
    
    /* edit Button */
    
    UIImage *editButtonImage = [UIImage imageNamed:@"EditButton"];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.bounds = CGRectMake( 0, 0, editButtonImage.size.width, editButtonImage.size.height);
    [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:editButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem=editBarButton;
    [editBarButton release];
    
    sectionList = [[NSArray alloc] initWithObjects:@"현재 대화 목록",@"지난 대화 목록",nil];
    NSMutableArray *now_talk = [[NSMutableArray alloc] init];
    NSMutableArray *before_talk = [[NSMutableArray alloc] init];
        NSMutableArray *talk_list = [[NSMutableArray alloc] init];
    [talk_list addObject:now_talk];
    [talk_list addObject:before_talk];
    [now_talk release];
    [before_talk release];
    
    dataSource = [[NSMutableDictionary alloc] initWithObjects:talk_list forKeys:sectionList];
    [talk_list release];
    
    self.tbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatRoom) name:@"newChat" object:nil];
    [self updateChatRoom];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newChat" object:nil];
    [super viewWillDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [(NSMutableArray *)[dataSource objectForKey:[sectionList objectAtIndex:section]] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
    static NSString *CellIdentifier = @"MyTalkTableCell";
    MyTalkTableViewCell *cell = (MyTalkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTalkTableViewCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[MyTalkTableViewCell class]])
                cell = (MyTalkTableViewCell *)oneObject;
        
    }
    
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    
    ChatRoom *chatRoom = (ChatRoom *)[[dataSource objectForKey:sectionName] objectAtIndex:indexPath.row];
    
    cell.userName.text = chatRoom.senderName;

    if(indexPath.section==0) // 현재 대화 중
    {
        cell.lastChat.textColor = [UIColor colorWithRed:25.0f/255 green:25.0f/255 blue:25.0f/255 alpha:1.0f];
        cell.userPic.userId = chatRoom.senderId;
        [cell.userPic setImageFromServer];
        cell.lastDate.textColor = [UIColor colorWithRed:80.0f/255 green:80.0f/255 blue:80.0f/255 alpha:1.0f];
    }
    else // 지난 대화
    {
        cell.userName.textColor = [UIColor colorWithRed:75.0f/255 green:75.0f/255 blue:75.0f/255 alpha:1.0f];
        cell.lastChat.textColor = [UIColor colorWithRed:98.0f/255 green:98.0f/255 blue:98.0f/255 alpha:1.0f];
        cell.userPic.userId = chatRoom.senderId;
        cell.lastDate.textColor = [UIColor grayColor];
        [cell.userPic setImageFromServerCache];
    }
    
    if(chatRoom.unreadCount == 0)
    {
        [cell.count setHidden:YES];
    }
    else
    {
        [cell.count setHidden:NO];
        cell.count.text = [NSString stringWithFormat:@"%d",chatRoom.unreadCount];
        
    }
    
    cell.lastChat.text = chatRoom.lastMessage;
    
    CGSize size = [chatRoom.lastMessage sizeWithFont:[UIFont systemFontOfSize:12] 
                                   constrainedToSize:CGSizeMake(220,27) 
                                       lineBreakMode:cell.lastChat.lineBreakMode];
    CGRect frame= CGRectMake(51, 41, 220, size.height);
    
    [cell.lastChat setFrame:frame];
    
    
    if(chatRoom.date != nil && ![chatRoom.date isEqualToString:@""])
    {
        if([[chatRoom.date substringToIndex:10] isEqualToString:[today substringToIndex:10]])
        {
            cell.lastDate.text = [chatRoom.date substringFromIndex:11];
        }
        else
        {
            cell.lastDate.text = [chatRoom.date substringToIndex:10];
        }
    }
    else
    {
        cell.lastDate.text=@"";
    }
    
    [[cell.userPic layer] setCornerRadius:4.0f];
    [[cell.userPic layer] setMasksToBounds:YES];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionList objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(UITableViewCellEditingStyleDelete == editingStyle) {
        ChatRoom *chatroom = [[dataSource objectForKey:[sectionList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        if(indexPath.section == TALK_NOW) // 대화 중
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제 오류"
                                                            message:@"삭제하기 위해서는 우선 대화를 끝내셔야 합니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [appDelegate deleteChatRoom:chatroom];
            [appDelegate deleteChatAndTempList:chatroom.roomId];
            
            [dataSource removeAllObjects];
            NSMutableArray *now_talk = [[NSMutableArray alloc] init];
            NSMutableArray *before_talk = [[NSMutableArray alloc] init];
            
            NSMutableArray *chatRoomList = [[NSMutableArray alloc] init];
            [appDelegate getChatRoomList:chatRoomList];
            for(int i=0;i<[chatRoomList count];i++) {
                ChatRoom *tempChatRoom = (ChatRoom *)[chatRoomList objectAtIndex:i];
                if(tempChatRoom.status == TALK_NOW) // 현재 대화 목록
                {
                    [now_talk addObject:tempChatRoom];
                }
                else 
                {
                    [before_talk addObject:tempChatRoom];
                }
            }
            
            [chatRoomList release];
            
            [dataSource setObject:now_talk forKey:[sectionList objectAtIndex:TALK_NOW]];
            [dataSource setObject:before_talk forKey:[sectionList objectAtIndex:TALK_FINISH]];
            [now_talk release];
            [before_talk release];
            
            [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRoom *chatRoom = [[dataSource objectForKey:[sectionList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    
    if(chatRoom.status == TALK_NOW) 
    {
        User *user = [[User alloc] init];
        [appDelegate getUser:user userId:chatRoom.senderId];
        ChatViewController_ *chat = [[ChatViewController_ alloc] init];
        chat.user = user;
        chat.chatRoom = chatRoom;
        chat.beforeViewIndex = 1;
        [user release];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
        [chat release];
    }
    else if(chatRoom.status == TALK_FINISH)
    {
        User *user = [[User alloc] init];
        [appDelegate getUser:user userId:chatRoom.senderId];
        EndchatViewController *chat = [[EndchatViewController alloc] init];
        chat.user = user;
        chat.chatRoom = chatRoom;
        chat.beforeViewIndex = 1;
        [user release];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
        [chat release];
    }
    else
    {
        
    }
    
    [tbl deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"지우기";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
	if (section == 0){
		UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,HEADER_HEIGHT)] autorelease];
        [headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(0,0,320.0f,23.0f)];
        [headerImage setImage:[[UIImage imageNamed:@"02_NowTalkSectionHeader_2"]stretchableImageWithLeftCapWidth:160.0f topCapHeight:16.0f]];
        [headerImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [headerView addSubview:headerImage];
        [headerImage release];
        [headerView setBackgroundColor:[UIColor clearColor]];
        return headerView;
	}
    else {
		UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,HEADER_HEIGHT)] autorelease];
        [headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(0,0,320.0f,23.0f)];
        [headerImage setImage:[[UIImage imageNamed:@"02_EndTalkSectionHeader_2"]stretchableImageWithLeftCapWidth:160.0f topCapHeight:16.0f]];
        [headerImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [headerView addSubview:headerImage];
        [headerImage release];
        [headerView setBackgroundColor:[UIColor clearColor]];
        return headerView;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (void)toggleEdit:(id)sender 
{
    [self.tbl setEditing:!self.tbl.editing animated:YES];
    
    if(self.tbl.editing)
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
    else 
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"EditButton"] forState:UIControlStateNormal];
}

#pragma mark - update with Server

- (void)updateChatRoom
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[
                                       [NSString stringWithFormat:@"%@GetRecentChatsNew?localAccount=%@&session=%@",
                                        kMeepleUrl,
                                        [userDefaults objectForKey:kUserIdKey],
                                        [userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //[request setPostValue:tempChat.text forKey:@"text"];
    [request setTimeOutSeconds:40];
    [request setFailedBlock:^{}];
    [request setCompletionBlock:^{
        NSInteger status = [request responseStatusCode];
        NSString *response = [request responseString];
        if(status == 200)
        {
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSMutableArray *chatroom_list = [parser objectWithString:response];
            NSMutableArray *updateChatRoom_list = [[NSMutableArray alloc] init];
            NSInteger totalCount = 0;
            for(NSDictionary *chatroom_info in chatroom_list)
            {
                ChatRoom *room = [[ChatRoom alloc] init];
                if([[chatroom_info objectForKey:@"senderAccount"] isEqualToString:[userDefaults objectForKey:kUserIdKey]])
                {
                    room.senderId = [chatroom_info objectForKey:@"receiverAccount"];
                }
                else
                {
                    room.senderId = [chatroom_info objectForKey:@"senderAccount"];
                }
                room.lastMessage = [chatroom_info objectForKey:@"chat"];
                room.date = [chatroom_info objectForKey:@"dateTime"];
                room.unreadCount = ((NSString *)[chatroom_info objectForKey:@"count"]).intValue;
                totalCount += room.unreadCount;
                room.lastChatId = ((NSString *)[chatroom_info objectForKey:@"chatId"]).intValue;
                [updateChatRoom_list addObject:room];
                [room release];
            }
            
            [appDelegate refreshChatRoomList:updateChatRoom_list];
            [updateChatRoom_list release];
            [parser release];
            if(totalCount != 0)
            {
                [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",totalCount]];
            }
            else
            {
                [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
            }
            [self refresh];
        }
    }];
    [request startAsynchronous];
}

-(void)refresh
{
    NSMutableArray *now_talk = [[NSMutableArray alloc] init];
    NSMutableArray *before_talk = [[NSMutableArray alloc] init];
    
    NSMutableArray *chatRoomList = [[NSMutableArray alloc] init];
    
    [appDelegate getChatRoomList:chatRoomList];
    for(int i=0;i<[chatRoomList count];i++) {
        ChatRoom *tempChatRoom = (ChatRoom *)[chatRoomList objectAtIndex:i];
        if(tempChatRoom.status == 0) // 현재 대화 목록
        {
            [now_talk addObject:tempChatRoom];
        }
        else 
        {
            [before_talk addObject:tempChatRoom];
        }
    }
    
    [chatRoomList release];
    
    [dataSource removeAllObjects];
    
    [dataSource setObject:now_talk forKey:[sectionList objectAtIndex:0]];
    [dataSource setObject:before_talk forKey:[sectionList objectAtIndex:1]];
    
    [now_talk release];
    [before_talk release];
    
    [tbl reloadData];
}

@end
