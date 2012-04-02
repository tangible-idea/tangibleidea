//
//  PersonalSettingDetail.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "PersonalSettingDetail.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@implementation PersonalSettingDetail
@synthesize changeType,changeField,mType,changeView,changeViewBg,maxLengthLabel,lengthLabel;


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
    self.changeField = nil;
    self.changeView = nil;
    self.changeViewBg = nil;
    self.maxLengthLabel = nil;
    self.lengthLabel = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.changeField = nil;
    self.changeView = nil;
    self.changeViewBg = nil;
    self.maxLengthLabel = nil;
    self.lengthLabel = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    activityIndicator.delegate = self;
    activityIndicator.labelText = @"정보 변경 중...";
    
    /* navigation setting */
    UIImage *backButtonImage = [UIImage imageNamed:@"BackButton"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
    
    
    UIImage *doneButtonImage = [UIImage imageNamed:@"DoneButton"];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.bounds = CGRectMake( 0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton addTarget:self action:@selector(doneButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setImage:doneButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem=doneBarButton;
    [doneBarButton release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150.0f,28.0f)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:59/255 green:66.0f/255 blue:90.0f/255 alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:21.0];
    
    
    /* navigation setting End*/

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mType = [[defaults objectForKey:kUserTypeKey] intValue]; 
    
    self.navigationItem.titleView = titleLabel;
    switch (changeType) {
        case 0:
            titleLabel.text = @"이름";
            changeView.hidden = YES;
            changeField.text = [defaults objectForKey:kUserNameKey];
            [changeField becomeFirstResponder];
            maxLength = 10;
            lengthLabel.text = [NSString stringWithFormat:@"%d",changeField.text.length];
            break;
        case 1:
            if(mType == 0) {
                titleLabel.text = @"전공";
                changeField.text = [defaults objectForKey:kUserMajorKey];
            }
            else {
                titleLabel.text = @"학교";
                changeField.text = [defaults objectForKey:kUserSchoolKey];
                
            }
            changeView.hidden = YES;
            
            maxLength = 20;
            lengthLabel.text = [NSString stringWithFormat:@"%d",changeField.text.length];
            [changeField becomeFirstResponder];
            break;
        case 2:
            if(mType == 0) {
                titleLabel.text = @"학번";
                changeField.keyboardType = UIKeyboardTypeNumberPad;
                maxLength = 4;
            }
            else {
                titleLabel.text = @"학년";
                changeField.keyboardType = UIKeyboardTypeNumberPad;
                maxLength = 1;
            }
            changeField.text = [defaults objectForKey:kUserGradeKey];
            changeView.hidden = YES;
            
            maxLengthLabel.hidden = YES;
            lengthLabel.hidden = YES;
            
            [changeField becomeFirstResponder];
            
            break;
        case 3:
            titleLabel.text = @"오늘의 한마디";
            changeField.hidden = YES;
            [doneButton setFrame:CGRectMake(doneButton.frame.origin.x,doneButton.frame.origin.y + 50.0f, doneButton.frame.size.width,doneButton.frame.size.height)];
            changeView.text = [defaults objectForKey:kUserTalkKey];
            [changeViewBg setImage:[[UIImage imageNamed:@"04_4_TextViewBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
            

            /* 위치 조절 */
            
            CGRect frame = doneButton.frame;
            frame.origin.y = frame.origin.y + 10.0f;
            [doneButton setFrame:frame];
            frame = maxLengthLabel.frame;
            frame.origin.y = 120;
            
            [maxLengthLabel setFrame:frame];
            frame = lengthLabel.frame;
            frame.origin.y = 120;
            [lengthLabel setFrame:frame];
            
            maxLength = 32;
            lengthLabel.text = [NSString stringWithFormat:@"%d",changeView.text.length];
            changeView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);
            changeView.scrollIndicatorInsets = UIEdgeInsetsMake(-4, -8, 0, 0);
            [changeView becomeFirstResponder];
            break;
        default:
            break;
    }
    maxLengthLabel.text = [NSString stringWithFormat:@"/ %d",maxLength];
    [titleLabel release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)backButtonPushed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonPushed
{
    /* 통신 */
    [activityIndicator show:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url;
    ASIFormDataRequest *request;
    
    switch (changeType) {
        case 0:
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangeName?account=%@&session=%@&name=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            request = [ASIFormDataRequest requestWithURL:url];
            //[request setPostValue:changeField.text forKey:@"value"];
            //[request setPostValue:@"name" forKey:@"type"];
            //[defaults setObject:changeField.text forKey:kUserNameKey];
            
            [request setCompletionBlock:^{
                NSString *response = [request responseString];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if([response boolValue])
                {
                    [defaults setObject:changeField.text forKey:kUserNameKey];
                    [self.navigationController popViewControllerAnimated:YES];
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
                };
                [activityIndicator hide:YES];
                
            }];
            break;
        case 1:
            if(mType == 0) 
            {
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangeMajor?account=%@&session=%@&major=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                request = [ASIFormDataRequest requestWithURL:url];
                //[request setPostValue:changeField.text forKey:@"value"];
                //[request setPostValue:@"major" forKey:@"type"];
                //[defaults setObject:changeField.text forKey:kUserMajorKey];
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([response boolValue])
                    {
                        [defaults setObject:changeField.text forKey:kUserMajorKey];
                        [self.navigationController popViewControllerAnimated:YES];
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
                    };
                    [activityIndicator hide:YES];
                    
                }];
            }
            else 
            {
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangeSchool?account=%@&session=%@&school=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                request = [ASIFormDataRequest requestWithURL:url];
                //[request setPostValue:changeField.text forKey:@"value"];
                //[request setPostValue:@"school" forKey:@"type"];
                //[defaults setObject:changeField.text forKey:kUserSchoolKey];
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([response boolValue])
                    {
                        [defaults setObject:changeField.text forKey:kUserSchoolKey];
                        [self.navigationController popViewControllerAnimated:YES];
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
                    };
                    [activityIndicator hide:YES];
                    
                }];
            }
            break;
        case 2:
            if(mType == 0)
            {
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangePromo?account=%@&session=%@&promo=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                request = [ASIFormDataRequest requestWithURL:url];
                //[request setPostValue:changeField.text forKey:@"value"];
                //[request setPostValue:@"grade" forKey:@"type"];
                //[defaults setObject:changeField.text forKey:kUserGradeKey];
                
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([response boolValue])
                    {
                        [defaults setObject:changeField.text forKey:kUserGradeKey];
                        [self.navigationController popViewControllerAnimated:YES];
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
                    };
                    [activityIndicator hide:YES];
                    
                }];
            }
            else
            {
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangeGrade?account=%@&session=%@&grade=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                request = [ASIFormDataRequest requestWithURL:url];
                //[request setPostValue:changeField.text forKey:@"value"];
                //[request setPostValue:@"grade" forKey:@"type"];
                //[defaults setObject:changeField.text forKey:kUserGradeKey];
                [request setCompletionBlock:^{
                    NSString *response = [request responseString];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if([response boolValue])
                    {
                        [defaults setObject:changeField.text forKey:kUserGradeKey];
                        [self.navigationController popViewControllerAnimated:YES];
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
                    };
                    [activityIndicator hide:YES];
                    
                }];
            }
            break;
        case 3:
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ChangeComment?account=%@&session=%@&comment=%@",kMeepleUrl,[defaults objectForKey:kUserIdKey],[defaults objectForKey:kSessionIdKey],changeView.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            request = [ASIFormDataRequest requestWithURL:url];
            
            //[defaults setObject:changeField.text forKey:kUserGradeKey];
            //[request setPostValue:changeView.text forKey:@"value"];
            //[request setPostValue:@"talk" forKey:@"type"];
            //[defaults setObject:changeView.text forKey:kUserTalkKey];
            [request setCompletionBlock:^{
                NSString *response = [request responseString];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if([response boolValue])
                {
                    [defaults setObject:changeView.text forKey:kUserTalkKey];
                    [self.navigationController popViewControllerAnimated:YES];
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
                };
                [activityIndicator hide:YES];
                
            }];
            break;
        default:
            break;
    }
    
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
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { 
    if([string isEqualToString:@"\n"])
    {
        return NO;
    }
    NSUInteger textLength = [textField.text length] + [string length] - range.length;
    if (textLength > maxLength && range.length == 0) 
    {
        textField.text = [textField.text substringToIndex:maxLength];
        return NO;
    }
    lengthLabel.text = [NSString stringWithFormat:@"%d",textLength];
    return YES;
    
}

#pragma mark - textView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        return NO;
    }
    
    //textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSUInteger textLength = [textView.text length] + [text length] - range.length;
    if (textLength > maxLength && range.length == 0) 
    {
        textView.text = [textView.text substringToIndex:maxLength];
        return NO;
    }
    lengthLabel.text = [NSString stringWithFormat:@"%d",textLength];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender   
{   
    
    [UIMenuController sharedMenuController].menuVisible = NO;  // 일단 메뉴가 안나오게 한다.
    [self resignFirstResponder];                      //혹시 나오더라도 유저가 선택할 수 없도록 한다.
    return NO;
}
@end
