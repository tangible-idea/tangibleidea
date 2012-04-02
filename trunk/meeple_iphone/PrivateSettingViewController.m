//
//  PrivateSettingViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 30..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "PrivateSettingViewController.h"
#import "PersonalSettingDetail.h"
#import "ASIFormDataRequest.h"

@implementation PrivateSettingViewController
@synthesize tbl;

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
    userId = nil;
    userName = nil;
    userPassword = nil;
    todayTalk = nil;
    userSchool = nil;
    subjectOrGrade = nil;
    mentoGrade = nil;
    [sectionList release];
    sectionList = nil;
    [settingDict release];
    settingDict = nil;
    userEmail = nil;
    self.tbl = nil;
    [userPic release];
    userPic = nil;
    [super dealloc];
}
- (void)viewDidUnload
{
    userId = nil;
    userName = nil;
    userPassword = nil;
    todayTalk = nil;
    userSchool = nil;
    subjectOrGrade = nil;
    mentoGrade = nil;
    [sectionList release];
    sectionList = nil;
    [settingDict release];
    settingDict = nil;
    userEmail = nil;
    self.tbl = nil;
    [userPic release];
    userPic = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //[userDefaults setObject:[NSNumber numberWithInt:0] forKey:kUserTypeKey];
    mType = [(NSNumber *)[userDefaults objectForKey:kUserTypeKey] intValue];
    
    //[userDefaults setObject:@"bsr117" forKey:kUserIdKey];
    userId = [userDefaults objectForKey:kUserIdKey];
    //[userDefaults setObject:@"빠렬" forKey:kUserNameKey];
    userName = [userDefaults objectForKey:kUserNameKey];
    userPassword = @"123123";
    
    //[userDefaults setObject:@"날씨 참 좋다 그지? 참 이상하게도 날씨가 참 좋아" forKey:kUserTalkKey];
    todayTalk = [userDefaults objectForKey:kUserTalkKey];
    //[userDefaults setObject:@"서울대학교" forKey:kUserSchoolKey];
    userSchool = [userDefaults objectForKey:kUserSchoolKey];
    //[userDefaults setObject:@"컴퓨터공학부" forKey:kUserMajorKey];
    if(mType == 0)
    {
        subjectOrGrade = [userDefaults objectForKey:kUserMajorKey];
    }
    else
    {
        subjectOrGrade = [userDefaults objectForKey:kUserGradeKey];
    }
    
    
    //[userDefaults setObject:@"2008" forKey:kUserGradeKey];
    mentoGrade = [userDefaults objectForKey:kUserGradeKey];
    
    //[userDefaults setObject:@"bsr117@yahoo.co.kr" forKey:kUserEmailKey];
    userEmail = [userDefaults objectForKey:kUserEmailKey];
    
    [tbl reloadData];
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
    tbl.backgroundColor = [UIColor clearColor];
    
    /* navigation setting */
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200.0f,28.0f)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:59/255 green:66.0f/255 blue:90.0f/255 alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:21.0];
    titleLabel.text = @"내 프로필";
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"BackButton"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
    
    /* navigation setting End*/
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //[userDefaults setObject:[NSNumber numberWithInt:0] forKey:kUserTypeKey];
    mType = [(NSNumber *)[userDefaults objectForKey:kUserTypeKey] intValue];
    
    //[userDefaults setObject:@"bsr117" forKey:kUserIdKey];
    userId = [userDefaults objectForKey:kUserIdKey];
    //[userDefaults setObject:@"빠렬" forKey:kUserNameKey];
    userName = [userDefaults objectForKey:kUserNameKey];
    userPassword = @"123123";
    
    //[userDefaults setObject:@"날씨 참 좋다 그지? 참 이상하게도 날씨가 참 좋아" forKey:kUserTalkKey];
    todayTalk = [userDefaults objectForKey:kUserTalkKey];
    //[userDefaults setObject:@"서울대학교" forKey:kUserSchoolKey];
    userSchool = [userDefaults objectForKey:kUserSchoolKey];
    //[userDefaults setObject:@"컴퓨터공학부" forKey:kUserMajorKey];
    subjectOrGrade = [userDefaults objectForKey:kUserMajorKey];
    
    //[userDefaults setObject:@"2008" forKey:kUserGradeKey];
    mentoGrade = [userDefaults objectForKey:kUserGradeKey];
    
    //[userDefaults setObject:@"bsr117@yahoo.co.kr" forKey:kUserEmailKey];
    userEmail = [userDefaults objectForKey:kUserEmailKey];
    
    /* header View 만들기 */
    
    CGRect loginInfoViewFrame = CGRectMake(0, 0, 320, 110);
    loginInfoView = [[UIView alloc] initWithFrame:loginInfoViewFrame];
    loginInfoView.backgroundColor = [UIColor clearColor];
    UILabel *labelForIdTitle = [[UILabel alloc] initWithFrame:CGRectMake(90,14,60,30)];
    labelForIdTitle.font = [UIFont systemFontOfSize:15];
    labelForIdTitle.text = @"아이디 :";
    labelForIdTitle.backgroundColor = [UIColor clearColor];
    [loginInfoView addSubview:labelForIdTitle];
    [labelForIdTitle release];
    
    NSString *userType;
    if(mType == 0)
    {
        userType = @"멘토";
    }
    else
    {
        userType = @"멘티";
    }
    UILabel *labelForId = [[UILabel alloc] initWithFrame:CGRectMake(150, 14, 150, 30)];
    labelForId.text = [NSString stringWithFormat:@"%@ (%@)",userId,userType];
    labelForId.font = [UIFont boldSystemFontOfSize:16];
    labelForId.textColor = [UIColor darkGrayColor];
    labelForId.backgroundColor = [UIColor clearColor];
    [loginInfoView addSubview:labelForId];
    [labelForId release];
    
    if(mType == 0) // mento
    {
        UILabel *labelForSchoolTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 38, 60, 30)];
        labelForSchoolTitle.font = [UIFont systemFontOfSize:15];
        labelForSchoolTitle.text = @"대학교 :";
        labelForSchoolTitle.backgroundColor = [UIColor clearColor];
        [loginInfoView addSubview:labelForSchoolTitle];
        [labelForSchoolTitle release];
        
        UILabel *labelForSchool = [[UILabel alloc] initWithFrame:CGRectMake(150, 38, 150, 30)];
        labelForSchool.font = [UIFont systemFontOfSize:15];
        labelForSchool.textColor = [UIColor darkGrayColor];
        labelForSchool.backgroundColor = [UIColor clearColor];
        labelForSchool.text = userSchool;
        [loginInfoView addSubview:labelForSchool];
        [labelForSchool release];
        
        UILabel *labelForEmailTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 61, 60, 30)];
        labelForEmailTitle.font = [UIFont systemFontOfSize:15];
        labelForEmailTitle.text = @"이메일 :";
        labelForEmailTitle.backgroundColor = [UIColor clearColor];
        [loginInfoView addSubview:labelForEmailTitle];
        [labelForEmailTitle release];
        
        UILabel *labelForEmail = [[UILabel alloc] initWithFrame:CGRectMake(150, 61, 150, 30)];
        labelForEmail.font = [UIFont systemFontOfSize:16];
        labelForEmail.textColor = [UIColor darkGrayColor];
        labelForEmail.backgroundColor = [UIColor clearColor];
        labelForEmail.text = userEmail;
        [loginInfoView addSubview:labelForEmail];
        [labelForEmail release];
    }
    else // mentee
    {
        UILabel *labelForEmailTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 43, 60, 30)];
        labelForEmailTitle.font = [UIFont systemFontOfSize:15];
        labelForEmailTitle.text = @"이메일 :";
        labelForEmailTitle.backgroundColor = [UIColor clearColor];
        [loginInfoView addSubview:labelForEmailTitle];
        [labelForEmailTitle release];
        
        UILabel *labelForEmail = [[UILabel alloc] initWithFrame:CGRectMake(150, 43, 150, 30)];
        labelForEmail.font = [UIFont systemFontOfSize:16];
        labelForEmail.textColor = [UIColor darkGrayColor];
        labelForEmail.backgroundColor = [UIColor clearColor];
        labelForEmail.text = userEmail;
        [loginInfoView addSubview:labelForEmail];
        [labelForEmail release];
    }
    
    userPic = [[UIButton alloc] initWithFrame:CGRectMake(15,20,63,63)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagefilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[userDefaults objectForKey:kUserIdKey]]];
    UIImage *userImage;
    if([[NSFileManager defaultManager] fileExistsAtPath:imagefilePath])
    {
        userImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagefilePath]];
    }
    else
    {
        userImage = [UIImage imageNamed:@"NoProfileImage"];
    }
    
    [userPic addTarget:self action:@selector(imageButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    //[userPic.imageView setContentMode:UIViewContentModeScaleAspectFill];
    //userPic.adjustsImageWhenHighlighted = NO;
    
    [userPic setBackgroundColor:[UIColor blackColor]];
    [userPic setImage:userImage forState:UIControlStateNormal];
    [loginInfoView addSubview:userPic];
    [[userPic layer] setCornerRadius:4.0f];
    [[userPic layer] setMasksToBounds:YES];
    /*
     UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [logoutButton setFrame:CGRectMake(210,50,80,30)];
     [logoutButton setTitle:@"로그아웃" forState:UIControlStateNormal];
     [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
     
     
     [loginInfoView addSubview:logoutButton];
     
     UIButton *changePasswd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [changePasswd setFrame:CGRectMake(100,50,105,30)];
     [changePasswd setTitle:@"비밀번호 변경" forState:UIControlStateNormal];
     [changePasswd addTarget:self action:@selector(changePw) forControlEvents:UIControlEventTouchUpInside];
     [loginInfoView addSubview:changePasswd];
     
     */
    [tbl setTableHeaderView:loginInfoView];
    
    sectionList = [[NSArray alloc] initWithObjects:@"기본정보",@"간단한 한마디",nil];
    NSArray *basicInfo;
    if(mType == 0) {
        basicInfo = [[NSArray alloc] initWithObjects:@"이름",@"전공",@"학번", nil];
    }
    else {
        // mentee
        basicInfo = [[NSArray alloc] initWithObjects:@"이름",@"학교명",@"학년", nil];
    }
    
    NSArray *talk = [[NSArray alloc] initWithObjects:@"한마디",nil];
    NSArray *infoList = [[NSArray alloc] initWithObjects:basicInfo,talk, nil];
    [basicInfo release];
    [talk release];
    settingDict = [[NSDictionary alloc] initWithObjects:infoList forKeys:sectionList];
    [infoList release];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[settingDict objectForKey:[sectionList objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,8,49,25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = 1;
        label.font = [UIFont boldSystemFontOfSize:15];
        [cell.contentView addSubview:label];
        [label release];
        
        
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(62,8,226,25)];
        textField.tag = 2;
        textField.numberOfLines = 0;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = [UIColor grayColor];
        textField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [cell.contentView addSubview:textField];
        [textField release];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UILabel *textField = (UILabel *)[cell viewWithTag:2];
    
    
    label.text = [[settingDict objectForKey:[sectionList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    textField.text = userName;
                    break;
                case 1:
                    if(mType == 0) 
                    {
                        textField.text = subjectOrGrade;
                    }
                    else 
                    {
                        textField.text = userSchool;
                    }
                    break;
                case 2:
                    if(mType == 0)
                    {
                        textField.text = mentoGrade;
                        
                    }
                    else
                    {
                        textField.text = subjectOrGrade;
                        
                    }
                    break;
                default:
                    break;
            } 
            break;
        case 1:
            {
                CGSize size = [todayTalk sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(226, 100) lineBreakMode:UILineBreakModeTailTruncation];
                
                float height = ( size.height > 25.0f ) ? size.height : 25.0f;
                textField.font = [UIFont systemFontOfSize:13];
                [textField setFrame:CGRectMake(62,8,226,height)];
                
                textField.text = todayTalk;
                
            }
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    PersonalSettingDetail *detailView = [[PersonalSettingDetail alloc] init];
    switch ([indexPath section]) {
        case 0:
            detailView.changeType = indexPath.row;
            break;
        case 1:
            detailView.changeType = 3;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 0) {
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,19.0f)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(18.0f,2,62.0f,16.0f)];
        [headerImage setImage:[UIImage imageNamed:@"04_1_BasicProfile"]];
        [headerView addSubview:headerImage];
        [headerImage release];
        return headerView;
    }
    else if(section == 1) {
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,19.0f)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(18.0f,2,98.0f,16.0f)];
        [headerImage setImage:[UIImage imageNamed:@"04_1_TodayTalk"]];
        [headerView addSubview:headerImage];
        [headerImage release];
        return headerView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
	return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
    {
        return 44.0f;
    }
    else
    {
        CGSize size = [todayTalk sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(226, 85) lineBreakMode:UILineBreakModeTailTruncation];
        float height = size.height > 25.0f ? size.height : 25.0f;
        if(height + 20.0f > 44.0f)
        {
            return height + 20.0f;
        }
        else
        {
            return 44.0f;
        }
    }
}

- (void)logout {
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"로그아웃";
    alert.message = @"정말 로그아웃 하시겠습니까?";
    [alert addButtonWithTitle:@"아니오"];
    [alert addButtonWithTitle:@"예"];
    alert.cancelButtonIndex = 0;
    [alert show];
    [alert release];
}

- (void)textFieldDone:(id)sender {
    [sender resignFirstResponder];
}


- (void)imageButtonPushed {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *cameraSelect = [[UIActionSheet alloc] initWithTitle:@"선택하기"
                                                                  delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"기존 항목 선택", nil];
        
        [cameraSelect showFromTabBar:self.tabBarController.tabBar];
        [cameraSelect release];
    }
    else 
    {
        UIActionSheet *cameraSelect = [[UIActionSheet alloc] initWithTitle:@"선택하기"
                                                                  delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"기존 항목 선택",@"사진 찍기", nil];
        
        [cameraSelect showFromTabBar:self.tabBarController.tabBar];
        [cameraSelect release];

    }
    
}

#pragma mark - action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = (buttonIndex ==0) ? YES : NO;
        UIImagePickerControllerSourceType sourceType = (buttonIndex != 0) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
}

#pragma mark -
#pragma picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    __block ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: 
                                           [NSURL URLWithString:
                                            [[NSString stringWithFormat:@"%@SaveImage?account=%@&session=%@"
                                              ,kMeepleUrl
                                              ,[userDefaults objectForKey:kUserIdKey]
                                              ,[userDefaults objectForKey:kSessionIdKey]
                                              ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]; 
    
    NSData *jpegImageData = UIImageJPEGRepresentation(image, 0.0);
    
    [request setTimeOutSeconds:20];
    [request setData:jpegImageData forKey:@"file"];
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        if([response boolValue])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[userDefaults objectForKey:kUserIdKey]]];
            [fileManager createFileAtPath:fullPath contents:jpegImageData attributes:nil];
            UIImage *userImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:fullPath]];
            [userPic setImage:userImage forState:UIControlStateNormal];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"수정 실패"
                                                            message:@"3G/WIFI 상태를 확인하세요."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }];
    
    [request setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"수정 실패"
														message:@"3G/WIFI 상태를 확인하세요."
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
        [alert release];
    }];
    
    [request startAsynchronous];
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - navigation Item pushed

-(void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
