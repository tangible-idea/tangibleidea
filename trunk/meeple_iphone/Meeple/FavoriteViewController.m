//
//  FavoriteViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MessageWriteViewController.h"
#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "PopUpViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "pictureViewController.h"
#import "MeepleImage.h"

#define cell_height 47

@implementation FavoriteViewController
@synthesize tbl,favList;

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
    self.tbl = nil;
    self.favList = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [userPictures release];
    userPictures = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    userPictures = [[NSMutableDictionary alloc] init];
    tbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // data 로컬에서 불러오기 
    activityIndicator = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
    
    favList = [[NSMutableArray alloc] init];
    /*
    NSMutableArray *temp =  [[NSMutableArray alloc] init];
    User *one = [[User alloc] init];
    one.name = @"김나나";
    one.userId = @"santokiya";
    one.type = 1;
    one.grade = 3;
    one.school = @"서울고등학교";
    one.talk = @"하늘을 날다 !~";
    
    User *two = [[User alloc] init];
    two.name = @"박수진";
    two.userId = @"helloworld";
    two.type = 1;
    two.grade = 2;
    two.school = @"한서중학교";
    two.talk = @"가을 아침! ";
    
    [temp addObject:one];
    [one release];
    [temp addObject:two];
    [two release];
    self.favList = temp;
    [temp release];
    일이삼사오육칠팔구십일이삼사오육칠팔구십
     */
    
    //////////////////////
    
    /* edit Button custom */
    UIImage *editButtonImage = [UIImage imageNamed:@"EditButton"];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.bounds = CGRectMake( 0, 0, editButtonImage.size.width, editButtonImage.size.height);
    [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:editButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem=editBarButton;
    [editBarButton release];
    
    [appDelegate getFavoriteList:favList];
    
    [tbl reloadData];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.tbl = nil;
    self.favList = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [userPictures release];
    userPictures = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFavorite];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFavorite) name:@"getFavorite" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getFavorite" object:nil];
    [userPictures removeAllObjects];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [favList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*즐겨찾기 삭제 */
    return @"삭제하기";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"favoriteTableCell";
    FavoriteTableViewCell *cell = (FavoriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier]; 
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteTableViewCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[FavoriteTableViewCell class]])
                cell = (FavoriteTableViewCell *)oneObject;
    }
    
    
    [[cell.userPic layer] setCornerRadius:4.0f];
    [[cell.userPic layer] setMasksToBounds:YES];
    cell.userNick.adjustsFontSizeToFitWidth = NO;
    NSUInteger row = [indexPath row];
    User *fav = [favList objectAtIndex:row];
    
    cell.userNick.text = fav.name;
    cell.userSchool.layer.cornerRadius = 5.0f;
    if([fav.talk isEqualToString:@""]) 
    {
        [cell.bubble setHidden:YES];
        [cell.userSchool setHidden:YES];
    }
    else 
    {
        UIImage *bubbleImage = [[UIImage imageNamed:@"03_1_TodayMessage"] stretchableImageWithLeftCapWidth:20 topCapHeight:7];
        [cell.bubble setHidden:NO];
        [cell.userSchool setHidden:NO];
        cell.userSchool.text = fav.talk;
        CGSize size = [fav.talk sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(cell.bubble.frame.size.width - 15.0f,29.0f) lineBreakMode:UILineBreakModeTailTruncation];
        [cell.bubble setFrame:CGRectMake(cell.frame.size.width - (3.0f+size.width+15.0f),(cell_height -29.0f-8.0f)/2,size.width + 15.0f, 29.0f+8.0f)];
        [cell.bubble setImage:bubbleImage];
        [cell.userSchool setFrame:CGRectMake(cell.frame.size.width -(3.0f+size.width+5.0f),(cell_height - 29.0f)/2,size.width,29.0f)];
    }
    //cell.userPic.userId = fav.userId;
    //[cell.userPic setImageFromServer];
    
    if([userPictures objectForKey:fav.userId]==nil)
    {
        if (self.tbl.dragging == NO && self.tbl.decelerating == NO)
        {
            cell.userPic.userId = fav.userId;
            [cell.userPic setImageFromServer];
            MeepleImage *image = [[MeepleImage alloc] init];
            image.userId = fav.userId;
            [image setImageFromServer];
            [userPictures setObject:image forKey:fav.userId];
            [image release];
        }
        
        [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"]];
    }
    else
    {
        MeepleImage *image = [userPictures objectForKey:fav.userId];
        if(image.isUsed == 1)
        {
            [cell.userPic setImage:image];
        }
        else
        {
            [cell.userPic setImage:[UIImage imageNamed:@"NoProfileImage"]];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(UITableViewCellEditingStyleDelete == editingStyle) {
        /* 삭제 기능 구현 */
        activityIndicator.labelText = @"삭제 중 ...";
        [activityIndicator show:YES];
        
        User *deleteFav = [favList objectAtIndex:indexPath.row];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@DeleteRelation?localAccount=%@&oppoAccount=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],deleteFav.userId,[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setCompletionBlock:^{
            [activityIndicator hide:YES];
            
            NSInteger status = [request responseStatusCode];
            NSString *response = [request responseString];
            if(status == 200)
            {
                if([response boolValue])
                {
                    //[tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    /*
                    NSString *userId = deleteFav.userId;
                    [appDelegate deleteMessageByUserId:userId];
                    */
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFavorite" object:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"즐겨찾기 삭제 실패"
                                                                    message:@"3G/WIFI 상태를 확인하세요."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인!" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    [alert release];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"즐겨찾기 삭제 실패"
                                                            message:@"서버 오류입니다. 잠시후 다시 시도해주세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
                [alert show];
            
                [alert release];
            }
        }];
        [request setFailedBlock:^{
            [activityIndicator hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"즐겨찾기 삭제 오류"
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cell_height;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
    [tbl setEditing:editing animated:animated];
     
}


- (void)toggleEdit:(id)sender {
    [self.tbl setEditing:!self.tbl.editing animated:YES];
    
    if(self.tbl.editing)
    {
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의"
                                                        message:@"즐겨찾기(미플친구)에서 유저를 제거 할 경우, 해당 유저와 주고 받았던 쪽지는 모두 삭제됩니다."
                                                       delegate:nil
                                              cancelButtonTitle:@"확인" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        */
        
    }
    else 
    {
        [(UIButton *)self.navigationItem.leftBarButtonItem.customView setImage:[UIImage imageNamed:@"EditButton"] forState:UIControlStateNormal];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    touchedUserNick = ((User *)[favList objectAtIndex:indexPath.row]).name;
    touchedUsrId = ((User *)[favList objectAtIndex:indexPath.row]).userId;
    
    UIView *grayViewNav = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    grayViewNav.alpha = 0.7f;
    grayViewNav.backgroundColor = [UIColor blackColor];
    grayViewNav.tag = 100;
    grayViewNav.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar addSubview:grayViewNav];
    [grayViewNav release];
    
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.7f;
    grayView.tag = 200;
    grayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:grayView];
    [grayView release];
    
    User *fav = [favList objectAtIndex:indexPath.row];
    PopUpViewController *userinfoView = [[[PopUpViewController alloc] init] autorelease];
    
    userinfoView.user = fav;
    userinfoView.tabNo = 2;
    
    userinfoView.view.tag = 300;
    userinfoView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [userinfoView.view setFrame:self.view.frame];
    [self.view addSubview:userinfoView.view];
    
    
    [tbl deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    
    
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - popUp

-(void)popUpOut 
{
    [[self.view viewWithTag:300] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];
}

-(void)popUpButtonPushed:(id)sender 
{
    [[self.view viewWithTag:300] removeFromSuperview];
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];

    MessageWriteViewController *messageWriteView = [[MessageWriteViewController alloc] init];
    messageWriteView.userNickStr = touchedUserNick;
    messageWriteView.userId = touchedUsrId;
    [self.navigationController pushViewController:messageWriteView animated:YES];
    [messageWriteView release];
}

#pragma mark - favorite

-(void)getFavorite
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    __block ASIFormDataRequest *request;
    if([[d objectForKey:kUserTypeKey] intValue] == 0)
    {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetRelationsMentee?account=%@&session=%@",kMeepleUrl,[d objectForKey:kUserIdKey],[d objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    else
    {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetRelationsMentor?account=%@&session=%@",kMeepleUrl,[d objectForKey:kUserIdKey],[d objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    [request setTimeOutSeconds:10];
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
        NSMutableArray *get_favoriteList = [parser objectWithString:response];
        NSMutableArray *temp_array = [[NSMutableArray alloc] init];
        NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
        if([[userDefautls objectForKey:kUserTypeKey] intValue] == 0)
        {
            for(NSMutableDictionary *info in get_favoriteList)
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Grade"] intValue];
                user.school = [info objectForKey:@"School"];
                user.flag = 4;
                [temp_array addObject:user];
                [user release];
            }
        }
        else
        {
            for(NSMutableDictionary *info in get_favoriteList)
            {
                User *user = [[User alloc] init];
                user.userId = [info objectForKey:@"AccountId"];
                user.talk = [info objectForKey:@"Comment"];
                user.name = [info objectForKey:@"Name"];
                user.grade = [[info objectForKey:@"Promo"] intValue];
                user.school = [info objectForKey:@"Univ"];
                user.major = [info objectForKey:@"Major"];
                user.flag = 4;
                [temp_array addObject:user];
                [user release];
            }
        }
        
        [appDelegate AddFavoriteList:temp_array];
        [temp_array release];
        [parser release];
        UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
        
        UIViewController *viewController = [navigationController visibleViewController];
        if([viewController isKindOfClass:[FavoriteViewController class]])
        {
            [favList removeAllObjects];
            [appDelegate getFavoriteList:favList];
            [tbl reloadData];
        }
    }];
    
    [request setFailedBlock:^{
       
    }];
    
    [request startAsynchronous];
    
}
/*
-(void)sucess:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
    NSMutableArray *get_favoriteList = [parser objectWithString:response];
    NSMutableArray *temp_array = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    if([[userDefautls objectForKey:kUserTypeKey] intValue] == 0)
    {
        for(NSMutableDictionary *info in get_favoriteList)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Grade"] intValue];
            user.school = [info objectForKey:@"School"];
            user.flag = 4;
            [temp_array addObject:user];
            [user release];
        }
    }
    else
    {
        for(NSMutableDictionary *info in get_favoriteList)
        {
            User *user = [[User alloc] init];
            user.userId = [info objectForKey:@"AccountId"];
            user.talk = [info objectForKey:@"Comment"];
            user.name = [info objectForKey:@"Name"];
            user.grade = [[info objectForKey:@"Promo"] intValue];
            user.school = [info objectForKey:@"Univ"];
            user.major = [info objectForKey:@"Major"];
            user.flag = 4;
            [temp_array addObject:user];
            [user release];
        }
    }
    
    [appDelegate AddFavoriteList:temp_array];
    [temp_array release];
    [parser release];
    UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
    
    UIViewController *viewController = [navigationController visibleViewController];
    if([viewController isKindOfClass:[FavoriteViewController class]])
    {
        [favList removeAllObjects];
        [appDelegate getFavoriteList:favList];
        [tbl reloadData];
    }
}

-(void)fail:(ASIFormDataRequest *)request
{
    NSLog(@"%@",[request responseString]);
}

 */

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
            MeepleImageView *image = ((FavoriteTableViewCell *)[self.tbl cellForRowAtIndexPath:indexPath]).userPic;
            if ([userPictures objectForKey:image.userId]!=nil) // avoid the app icon download if the app already has an icon
            {
                MeepleImage *imageData = (MeepleImage *)[userPictures objectForKey:image.userId];
                if(imageData.isUsed ==1)
                    [image setImage:imageData];
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
