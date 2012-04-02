//
//  SettingViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "ReportViewController.h"
#import "PrivateSettingViewController.h"
#import "MeepleIntroduceViewController.h"
#import "SettingNav.h"
#import "MeepleTipsFirstViewController.h"


@implementation SettingViewController
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
    [sectionList release];
    sectionList = nil;
    [settingData release];
    settingData = nil;
    self.tbl = nil;
    [super dealloc];
}

- (void)viewDidUnload
{   [sectionList release];
    sectionList = nil;
    [settingData release];
    settingData = nil;
    self.tbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    sectionList = [[NSArray alloc] initWithObjects:@"내 프로필",@"소개",@"신고",nil];
    NSArray *data1 = [[NSArray alloc] initWithObjects:@"내 프로필",nil];
    
    NSArray *data2 = [[NSArray alloc] initWithObjects:@"tips",@"회사 소개",nil];
    NSArray *data3 = [[NSArray alloc] initWithObjects:@"신고하기",nil];
    NSArray *data4 = [[NSArray alloc] initWithObjects:data1,data2,data3,nil];
    [data1 release];
    [data2 release];
    [data3 release];
    settingData = [[NSDictionary alloc] initWithObjects:data4 forKeys:sectionList];
    [data4 release];
    tbl.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[settingData objectForKey:[sectionList objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellLabel";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *text;
        if(cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            text = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 10.0f, 100, 25)];
            text.tag = 2;
            text.highlightedTextColor = [UIColor whiteColor];
            [cell.contentView addSubview:text];
            [text release];
        }
        text = (UILabel *)[cell.contentView viewWithTag:2];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        text.text = [userDefaults objectForKey:kUserIdKey];
        
    }
    else if(indexPath.section == 1 && indexPath.row == 1) {
        static NSString *CellIdentifier = @"CellTextText";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            UIImageView *textImg;
            UIImageView *textImg2;
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            textImg = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f,15.0f,65.0f,15.0f)];
            textImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(178.0f,15.0f,86.0f,15.0f)];
            [textImg setImage:[UIImage imageNamed:@"04_AboutCompany"]];
            [textImg2 setImage:[UIImage imageNamed:@"04_CompanyName"]];
            [cell.contentView addSubview:textImg];
            [cell.contentView addSubview:textImg2];
            [textImg release];
            [textImg2 release];
        }
    }
    else {
        static NSString *CellIdentifier = @"CellImage";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIImageView *textImg;
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            textImg = [[UIImageView alloc] initWithFrame:CGRectZero];
            textImg.tag = 1;
            [cell.contentView addSubview:textImg];
            [textImg release];
        }
        textImg = (UIImageView *)[cell.contentView viewWithTag:1];
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                if(indexPath.row == 0) {
                    [textImg setImage:[UIImage imageNamed:@"04_MeepleTips"]];
                    [textImg setFrame:CGRectMake(12.0f,16.0f,65.0f,15.0f)];
                }
                break;
            case 2:
                [textImg setImage:[UIImage imageNamed:@"04_Report"]];
                [textImg setFrame:CGRectMake(12.0f,16.0f,65.0f,15.0f)];
                break;
            default:
                break;
        }
    }
    
    
    //cell.textLabel.text = [[settingData objectForKey:[sectionList objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    switch(section) {
        case 0:{
            /*
            PersonalSettingViewController *personal = [[[PersonalSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            */
            PrivateSettingViewController *personal = [[[PrivateSettingViewController alloc] init] autorelease];
            [self.navigationController pushViewController:personal animated:YES];
            break;
        }
        case 1:{
            if(indexPath.row == 0)
            {
                [(SettingNav *)self.navigationController.navigationBar changeBgForTips];
                MeepleTipsFirstViewController *tips =
                [[MeepleTipsFirstViewController alloc] init];
                tips.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tips animated:YES];
                [tips release];
            }
            else
            {
                [(SettingNav *)self.navigationController.navigationBar changeBgForIntro];
                MeepleIntroduceViewController *intro = [[MeepleIntroduceViewController alloc] init];
                intro.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:intro animated:YES];
                [intro release];
            }
            break;
        }
        case 2:{
            ReportViewController *report = [[[ReportViewController alloc] init] autorelease];
            [self.navigationController pushViewController:report animated:YES];
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section == 0) {
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,23.0f)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(18.0f,2,65.0f,16.0f)];
        [headerImage setImage:[UIImage imageNamed:@"04_Profile"]];
        [headerView addSubview:headerImage];
        [headerImage release];
        return headerView;
    }
    else if(section == 1) {
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,23.0f)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *headerImage = [[UIImageView alloc] init];
        [headerImage setFrame:CGRectMake(18.0f,2,64.0f,16.0f)];
        [headerImage setImage:[UIImage imageNamed:@"04_About"]];
        [headerView addSubview:headerImage];
        [headerImage release];
        return headerView;
    }
    else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 23.0f;
}

@end
