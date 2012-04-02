//
//  LoginViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AgreementViewController.h"
#import "MentoAuthenticationView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJson.h"
#import "BeforeLoginViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.3;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation LoginViewController
@synthesize idField,pwField,joinMento,joinMentee,loginButton;

#pragma mark - view life cycle

- (void)viewDidUnload {
    self.idField = nil;
	self.pwField = nil;
	self.loginButton = nil;
	self.joinMento = nil;
	self.joinMentee = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
	
}


- (void)dealloc {
	self.idField = nil;
	self.pwField = nil;
	self.loginButton = nil;
	self.joinMento = nil;
	self.joinMentee = nil;    
    [activityIndicator release];
    activityIndicator = nil;
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUserIdKey];
    [userDefaults removeObjectForKey:kUserTalkKey];
    [userDefaults removeObjectForKey:kUserNameKey];
    [userDefaults removeObjectForKey:kUserEmailKey];
    [userDefaults removeObjectForKey:kUserGradeKey];
    [userDefaults removeObjectForKey:kUserSchoolKey];
    [userDefaults removeObjectForKey:kUserSexKey];
    
    // MBProgressHUD 
    activityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    activityIndicator.delegate = self;
    activityIndicator.labelText = @"로그인 중...";
    
	[self.view addSubview:activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [idField resignFirstResponder];
    [pwField resignFirstResponder];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)loginDone:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenAsString = [defaults objectForKey:kDeviceTokenKey];
    NSString *pushAllow = [defaults objectForKey:kPushAllowKey];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@Login?account=%@&password=%@&isPush=%@&push=%@",kMeepleUrl,idField.text,[self md5:pwField.text],pushAllow,tokenAsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];     
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    /*
    NSURL *url = [NSURL URLWithString:@"http://61.106.83.65:9091/MeepleService/Login"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    
    [request setPostValue:idField.text forKey:@"id"];
    [request setPostValue:[(NSString *)[self md5:pwField.text] substringFromIndex:16] forKey:@"passwd"];
    
    [request setPostValue:pushAllow forKey:@"pushEnable"];
    
    [request setPostValue:tokenAsString forKey:@"pushID"];
    
    */
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loginFinished:)];
    [request setDidFailSelector:@selector(loginFailed:)];
    [request setTimeOutSeconds:20];
    
    [idField resignFirstResponder];
    [pwField resignFirstResponder];
    
    [request startAsynchronous];
    [activityIndicator show:YES];
 
}

- (void)loginFinished:(ASIFormDataRequest *)request
{
    NSString *responds = [request responseString];
    NSInteger status = [request responseStatusCode];
    if(status == 200)
    {        
        SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
        
        NSMutableDictionary *info = [parser objectWithString:responds];
        BOOL isSuccess = [[info valueForKey:@"success"] boolValue];
        if(isSuccess)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:idField.text forKey:kUserIdKey];
            [userDefaults setObject:[info valueForKey:@"session"] forKey:kSessionIdKey];
            [userDefaults setObject:[NSString stringWithFormat:@"%@.sqlite",idField.text] forKey:kDBFileNameKey];
            
            BOOL isMentor = [[info valueForKey:@"isMentor"] boolValue];
            if(isMentor)
            {
                NSMutableDictionary *mentorInfo = [info valueForKey:@"mentorInfo"];
                [userDefaults setObject:[NSNumber numberWithInt:0] forKey:kUserTypeKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"Comment"] forKey:kUserTalkKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"Email"] forKey:kUserEmailKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"Major"] forKey:kUserMajorKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"Name"] forKey:kUserNameKey];
                NSNumber *promo = [mentorInfo valueForKey:@"Promo"];
                [userDefaults setObject:[NSString stringWithFormat:@"%d",[promo intValue]] forKey:kUserGradeKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"Univ"] forKey:kUserSchoolKey];
                [userDefaults setObject:[mentorInfo valueForKey:@"AccountId"] forKey:kLocalNoKey];
                
            }
            else
            {
                NSMutableDictionary *menteeInfo = [info valueForKey:@"menteeInfo"];
                [userDefaults setObject:[NSNumber numberWithInt:1] forKey:kUserTypeKey];
                [userDefaults setObject:[menteeInfo valueForKey:@"Comment"] forKey:kUserTalkKey];
                [userDefaults setObject:[menteeInfo valueForKey:@"Email"] forKey:kUserEmailKey];
                [userDefaults setObject:[menteeInfo valueForKey:@"Name"] forKey:kUserNameKey];
                NSNumber *grade = [menteeInfo valueForKey:@"Grade"];
                [userDefaults setObject:[NSString stringWithFormat:@"%d",[grade intValue]] forKey:kUserGradeKey];
                [userDefaults setObject:[menteeInfo valueForKey:@"School"] forKey:kUserSchoolKey];
                [userDefaults setObject:[menteeInfo valueForKey:@"AccountId"] forKey:kLocalNoKey];
            }
            
            id appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate initDB:[userDefaults objectForKey:kDBFileNameKey]];
    
            /* Favorite 정보 가져오기 */
            
            activityIndicator.labelText = @"미플 친구 정보 가져오는 중..";
            __block ASIFormDataRequest *request2;
            if([[userDefaults objectForKey:kUserTypeKey] intValue] == 0)
            {
                request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetRelationsMentee?account=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            else
            {
                request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@GetRelationsMentor?account=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            
            [request2 setTimeOutSeconds:10];
            [request2 setCompletionBlock:^{
                NSString *response = [request2 responseString];
                NSInteger status = [request2 responseStatusCode];
                if(status == 200)
                {
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
                    [activityIndicator hide:YES];
                    
                    UINavigationController *navCon = (UINavigationController *)self.parentViewController;
                    UIViewController *viewController;
                    if([navCon respondsToSelector:@selector(presentingViewController)])
                    {
                        viewController = navCon.presentingViewController;
                    }
                    else
                    {
                        viewController = navCon.parentViewController;
                    }
                    
                    if([viewController isKindOfClass:[BeforeLoginViewController class]])
                    {
                        [appDelegate showTabBar];
                    }
                    else
                    {
                        [[appDelegate tabBarController] setSelectedIndex:0];
                    }
                    [self dismissModalViewControllerAnimated:YES];
                    
                    
                }
            }];
            
            [request2 setFailedBlock:^{
                [activityIndicator hide:YES];
                [self dismissModalViewControllerAnimated:YES];
                UINavigationController *navCon = (UINavigationController *)self.parentViewController;
                UIViewController *viewController;
                if([navCon respondsToSelector:@selector(presentingViewController)])
                {
                    viewController = navCon.presentingViewController;
                }
                else
                {
                    viewController = navCon.parentViewController;
                }

                if([viewController isKindOfClass:[BeforeLoginViewController class]])
                {
                    [appDelegate showTabBar];
                }
                else
                {
                    [[appDelegate tabBarController] setSelectedIndex:0];
                }
            }];
            
            [request2 startAsynchronous];
        }
        else
        {
            [activityIndicator hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패!"
                                                            message:@"아이디 또는 비밀번호를 확인하세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [parser release];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패!"
                                                        message:@"3G/WIFI 상태를 확인하세요!"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인!" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)loginFailed:(ASIFormDataRequest *)request
{
    [activityIndicator hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패!"
                                                    message:@"3G/WIFI 상태를 확인하세요!"
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)joinMentoDone:(id)sender {
	MentoAuthenticationView *authview = [[[MentoAuthenticationView alloc] init] autorelease];
	[self.navigationController pushViewController:authview animated:YES];
	
}

- (IBAction)joinMenteeDone:(id)sender {
	AgreementViewController *agreementview = [[[AgreementViewController alloc] init] autorelease];
	agreementview.mType = 1;
	agreementview.auth_id = @"";
	[self.navigationController pushViewController:agreementview animated:YES];
	
}

- (IBAction)textFieldDoneEditing:(id)sender; {
	[sender resignFirstResponder];
}



- (IBAction)textFieldEditingStart:(UITextField *)textField
{
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (void)textFieldEditingOver:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (IBAction)backgroundTap:(id)sender {
	[idField resignFirstResponder];
	[pwField resignFirstResponder];
}

-(NSString*) md5:(NSString*)srcStr
{
	const char *cStr = [srcStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
			result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}


@end
