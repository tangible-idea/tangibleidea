//
//  JoinViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "JoinViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import <CommonCrypto/CommonDigest.h>
#import "BeforeLoginViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.3;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation JoinViewController
@synthesize mType;
@synthesize authId;
@synthesize univName;

@synthesize idField;
@synthesize pwField;
@synthesize nameField;
@synthesize emailField;
@synthesize schoolField;
@synthesize majorField;
@synthesize gradeField;
@synthesize sexField;
@synthesize sexArray;
@synthesize activityIndicator;
@synthesize schoolLabel,majorLabel,gradeLabel;
@synthesize schoolNum;

@synthesize joinButton;

#pragma mark - view lifecycle
- (void)viewDidUnload {
	self.authId = nil;
	self.univName = nil;
	self.activityIndicator = nil;
	self.idField = nil;
	self.pwField = nil;
	self.nameField = nil;
	self.emailField = nil;
	self.schoolField = nil;
	self.majorField = nil;
    self.gradeField = nil;
    self.sexField = nil;
    
	self.schoolLabel = nil;
	self.majorLabel = nil;
	self.gradeLabel = nil;
    
	self.joinButton = nil;
	
    self.sexArray = nil;
	[super viewDidUnload];
    
}


- (void)dealloc {
	
    self.authId = nil;
	self.univName = nil;
	
	self.idField = nil;
	self.pwField = nil;
	self.nameField = nil;
	self.emailField = nil;
	self.schoolField = nil;
	self.majorField = nil;
    self.gradeField = nil;
    self.sexField = nil;
	self.schoolLabel = nil;
	self.majorLabel = nil;
	self.gradeLabel = nil;
    self.activityIndicator = nil;
    
	self.joinButton = nil;
    self.sexArray = nil;
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if(mType == 0) {
		schoolLabel.text = @"대학교";
		schoolField.text = univName;
		schoolField.textColor = [UIColor grayColor];
        schoolField.userInteractionEnabled = NO;
		gradeLabel.text = @"학번";
        gradeField.placeholder = @"입학년도 ex)2007";
        
        if([univName isEqualToString:@"서울대학교"])
        {
            emailField.text = [NSString stringWithFormat:@"%@@snu.ac.kr",authId];
            emailField.textColor = [UIColor grayColor];
            emailField.userInteractionEnabled = NO;
        }
        else if([univName isEqualToString:@"연세대학교"])
        {
            
        }
        else if([univName isEqualToString:@"고려대학교"])
        {
            
        }
	}
	else if(mType == 1) {
		schoolLabel.text = @"학교";
		majorLabel.text = @"학년";
        majorField.keyboardType = UIKeyboardTypeNumberPad;
        majorField.placeholder = @"예) 1학년의 경우 1, 2학년의 경우 2";
		gradeLabel.hidden = TRUE;
		gradeField.hidden = TRUE;
        
	}
    sexArray = [[NSArray alloc] initWithObjects:@"-------",@"남자",@"여자",nil];
    UIPickerView* sexPicker = [[UIPickerView alloc] init];
	sexPicker.delegate = self;
	sexPicker.dataSource = self;
	sexPicker.showsSelectionIndicator = YES;
    sexField.inputView = sexPicker;
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem* selectButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:sexField action:@selector(resignFirstResponder)] autorelease];
	[toolbar setItems:[NSArray arrayWithObjects:
                       [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                       selectButton,nil] animated:YES];
	sexField.inputAccessoryView = toolbar;
	[sexPicker release];
	[toolbar release];
    
    /* activty Indicator */
    MBProgressHUD *tempProgress = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    tempProgress.delegate = self;
    tempProgress.labelText = @"회원가입 중...";
    self.activityIndicator = tempProgress;
    [tempProgress release];
    
	[[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

- (IBAction)textFieldEditingOver:(UITextField *)textField
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
	[nameField resignFirstResponder];
	[emailField resignFirstResponder];
	[schoolField resignFirstResponder];
	[majorField resignFirstResponder];
    [gradeField resignFirstResponder];
    [sexField resignFirstResponder];
}

- (IBAction)joinButtonPressed:(id)sender {
	
    [idField resignFirstResponder];
	[pwField resignFirstResponder];
	[nameField resignFirstResponder];
	[emailField resignFirstResponder];
	[schoolField resignFirstResponder];
	[majorField resignFirstResponder];
    [gradeField resignFirstResponder];
    [sexField resignFirstResponder];
    
    NSString *userId = idField.text;
    if(userId.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"아이디 오류!"
														message:@"아이디를 입력해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        return ;
    }
    NSString *pw = [self md5:pwField.text];
    
    if(pw.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"비밀번호 오류!"
														message:@"비밀번호를 입력해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        return ;
    }
    
    NSString *name = nameField.text;
    if(name.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"이름 오류!"
														message:@"이름을 입력해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        return ;
    }
    //name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger sex;
    if([sexField.text isEqualToString:@"남자"])
    {
        sex = 1;
    }
    else if([sexField.text isEqualToString:@"여자"])
    {
        sex = 2;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"성별 오류!"
														message:@"성별을 선택해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        return ;
    }
    
    NSString *email = emailField.text;
    if(email.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"이메일 오류!"
														message:@"이메일을 입력해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        return ;
    }
    else 
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
        if(![emailTest evaluateWithObject:email])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"이메일 오류!"
                                                            message:@"이메일을 바르게 입력해주세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ; 
        }
    }
    
    NSString *school = schoolField.text;
    if(school.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학교 오류!"
                                                        message:@"학교명을 바르게 입력해주세요!"
                                                        delegate:nil
                                                        cancelButtonTitle:@"확인!" 
                                                        otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    
    NSString *major = majorField.text;
    if(major.length == 0 ) {
        if(mType == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학년 오류!"
                                                            message:@"학년을 바르게 입력해주세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"전공명 오류!"
                                                            message:@"전공명을 바르게 입력해주세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    }
    else
    {
        if(mType == 1) // 학년 검사
        {
            NSString *gradeRegex = @"[1-6]"; 
            NSPredicate *gradeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gradeRegex]; 
            if(![gradeTest evaluateWithObject:major])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학년 오류!"
                                                                message:@"학년을 바르게 입력해주세요!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return ; 
            }
        }
    }
    
    NSString *grade = gradeField.text;
    if(mType == 0)
    {
        if(grade.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학번 오류!"
                                                            message:@"학번을 바르게 입력해주세요!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;

        }
        else 
        {
            NSString *gradeRegex = @"[1-2][0,9][0-9][0-9]"; 
            NSPredicate *gradeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gradeRegex]; 
            NSInteger gradeInteger = grade.intValue;
            if(![gradeTest evaluateWithObject:grade])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학번 오류!"
                                                                message:@"학번을 바르게 입력해주세요!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return ; 
            }
            else
            {
                if(gradeInteger < 1900) 
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"학번 오류!"
                                                                    message:@"학번을 바르게 입력해주세요!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인!" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return ; 
                }
            }
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenAsString = [defaults objectForKey:kDeviceTokenKey];
    NSString *pushAllow = [defaults objectForKey:kPushAllowKey];
    NSURL *url;
    if(mType == 0)
    {
        NSString *urlString = [[NSString stringWithFormat:@"%@RegisterMentor?account=%@&password=%@&isPush=%@&push=%@&name=%@&gender=%d&email=%@&univ=%@&major=%@&promo=%@",kMeepleUrl,userId,pw,pushAllow,tokenAsString,name,sex,email,school,major,grade]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlString];
    }
    else
    {
        // major = > 학년 , grade =>없음
        NSString *urlString = [[NSString stringWithFormat:@"%@RegisterMentee?account=%@&password=%@&isPush=%@&push=%@&name=%@&gender=%d&email=%@&school=%@&grade=%@",kMeepleUrl,userId,pw,pushAllow,tokenAsString,name,sex,email,school,major] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        url = [NSURL URLWithString:urlString];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTimeOutSeconds:20];
    [request setDidFinishSelector:@selector(joinConnectionSuccess:)];
    [request setDidFailSelector:@selector(joinConnectionFail:)];
    [request startAsynchronous];
    [activityIndicator show:YES];
}

-(NSString*)md5:(NSString*)srcStr
{
	const char *cStr = [srcStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
			result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerVoew numberOfRowsInComponent:(NSInteger)component {
	return [sexArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView 
			titleForRow:(NSInteger)row 
		   forComponent:(NSInteger)component {
	return [sexArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView
	 didSelectRow:(NSInteger)row
	  inComponent:(NSInteger)component {
	if(row == 0) {
		sexField.text = @"";
	}
	else {
		sexField.text = [sexArray objectAtIndex:row];
	}	
}

-(void)joinConnectionSuccess:(ASIHTTPRequest *)request 
{
    NSString *responseString = [request responseString];
    SBJsonParser* parser = [ [ SBJsonParser alloc ] init ];
    
    NSMutableDictionary *info = [parser objectWithString:responseString];
    BOOL isSuccess = [[info valueForKey:@"success"] boolValue];
    if(isSuccess) {
        NSString *sessionId = [info valueForKey:@"session"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSNumber *mType_ = [[NSNumber alloc] initWithInt:mType];
        [user setObject:mType_ forKey:kUserTypeKey];
        [mType_ release];
        [user setObject:idField.text forKey:kUserIdKey];
        [user setObject:[NSString stringWithFormat:@"%@.sqlite",idField.text] forKey:kDBFileNameKey];
        [user setObject:sessionId forKey:kSessionIdKey];
        [user setObject:nameField.text forKey:kUserNameKey];
        [user setObject:sexField.text forKey:kUserSexKey];
        [user setObject:schoolField.text forKey:kUserSchoolKey];
        [user setObject:emailField.text forKey:kUserEmailKey];
        
        if(mType == 0) {
            [user setObject:majorField.text forKey:kUserMajorKey];
            [user setObject:gradeField.text forKey:kUserGradeKey];
        }
        else {
            [user setObject:majorField.text forKey:kUserGradeKey];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"감사합니다"
														message:@"회원가입을 완료하였습니다."
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
        
		[alert release];
        id appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate initDB:[user objectForKey:kDBFileNameKey]];
        
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
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"가입 오류"
                                                        message:[info valueForKey:@"reason"]
                                                       delegate:nil
                                              cancelButtonTitle:@"확인!" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    [parser release];
    [activityIndicator hide:YES];
    
}

-(void)joinConnectionFail:(ASIHTTPRequest *)request
{
    [activityIndicator hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류"
                                                    message:@"3G/WIFI 상태를 확인하세요"
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end

