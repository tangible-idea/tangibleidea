//
//  MentoAuthenticationView.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MentoAuthenticationView.h"
#import "AgreementViewController.h"
#import "ASIFormDataRequest.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.4;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 1.0;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation MentoAuthenticationView
@synthesize univField;
@synthesize auth_pwField;
@synthesize auth_idField;
@synthesize univData;
@synthesize authDone;
@synthesize receivedData;
@synthesize activityIndicator;

- (void)viewDidLoad {
	[super viewDidLoad];
	UIPickerView* univPicker = [[UIPickerView alloc] init];
	univPicker.delegate = self;
	univPicker.dataSource = self;
	univPicker.showsSelectionIndicator = YES;
	NSArray *dataarray = [[NSArray alloc] initWithObjects:@"------",@"서울대학교",nil];
	self.univData = dataarray;
	[dataarray release];
	
	univField.inputView = univPicker;
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem* selectButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:univField action:@selector(resignFirstResponder)] autorelease];
	[toolbar setItems:[NSArray arrayWithObjects:
                       [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                       selectButton,nil] animated:YES];
	univField.inputAccessoryView = toolbar;
	[univPicker release];
	[toolbar release];
    
    MBProgressHUD *tempProgress = [[MBProgressHUD alloc] initWithView:self.view];
    tempProgress.delegate = self;
    tempProgress.labelText = @"잠시 기다려주세요";
    self.activityIndicator = tempProgress;
    [tempProgress release];
    
	[self.view addSubview:activityIndicator];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.130 green:0.571 blue:0.824 alpha:1.000]];
	self.navigationController.navigationBar.translucent = YES;
	//self.wantsFullScreenLayout = YES;	
    
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [auth_idField resignFirstResponder];
    [auth_pwField resignFirstResponder];
    [univField resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.auth_idField = nil;
	self.auth_pwField = nil;
	self.univField = nil;
	self.univData = nil;
	self.authDone = nil;
	self.receivedData = nil;
    self.activityIndicator = nil;
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.auth_idField = nil;
    self.auth_pwField = nil;
    self.univField = nil;
    self.univData = nil;
    self.authDone = nil;
    self.receivedData = nil;
    self.activityIndicator = nil;
	[super dealloc];
}

- (IBAction)authDonePressed:(id)sender {
	if([univField.text isEqualToString:@"서울대학교"] == YES) {
		
		/* HTTP REQUEST */
        [activityIndicator show:YES];
        /*
		NSURL *url = [NSURL URLWithString:@"https://sso.snu.ac.kr/safeidentity/modules/auth_idpwd"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setPostValue:@"SnuUser1" forKey:@"si_realm"];
        [request setPostValue:@"http://sso.snu.ac.kr/snu/ssologin_proc.jsp?si_redirect_address=http://my.snu.ac.kr/portal/site/snuep/mylogin?autoLogin=False" forKey:@"si_redirect_address"];
         */
        
        NSURL *url = [NSURL URLWithString:@"https://sso.snu.ac.kr/safeidentity/modules/auth_idpwd"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setPostValue:@"SnuUser1" forKey:@"si_realm"];
        [request setPostValue:@"http://mysnu.ac.kr/mysnu/login?langKnd=ko" forKey:@"si_redirect_address"];
        [request setPostValue:@"submit" forKey:@"_enpass_login"];
        [request setPostValue:auth_idField.text forKey:@"si_id"];
        [request setPostValue:auth_pwField.text forKey:@"si_pwd"];
        [request setTimeOutSeconds:20];
        [request startAsynchronous];
        
	}
	else if([univField.text isEqualToString:@"고려대학교"] == YES) {
        
    }
    else if([univField.text isEqualToString:@"연세대학교"] == YES) {
        
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"인증 실패!"
														message:@"대학교를 선택해주세요!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
}

- (IBAction)textFieldDoneEditing:(id)sender{
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
	[auth_idField resignFirstResponder];
	[auth_pwField resignFirstResponder];
	[univField resignFirstResponder];
}

#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerVoew numberOfRowsInComponent:(NSInteger)component {
	return [univData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView 
			titleForRow:(NSInteger)row 
		   forComponent:(NSInteger)component {
	return [univData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView
	 didSelectRow:(NSInteger)row
	  inComponent:(NSInteger)component {
	if(row == 0) {
		univField.text = @"";
	}
	else {
		univField.text = [univData objectAtIndex:row];
	}
    schoolnum = row;
}

#pragma mark -
#pragma mark HTTPREQUEST

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    [activityIndicator hide:YES];
    
    NSString *data = [request responseString];
    if(data!=nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Success!"
														message:@"인증 성공!"
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        AgreementViewController *agreementview = [[[AgreementViewController alloc] init] autorelease];
        agreementview.mType = 0;
        agreementview.auth_id = auth_idField.text;
        agreementview.auth_univ = univField.text;
        [self.navigationController pushViewController:agreementview animated:YES];
        
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Fail!"
														message:@"아이디, 비밀번호를 확인하세요."
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [activityIndicator hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Fail"
                                                    message:@"3G/WIFI상태 혹은 아이디,비밀번호를 확인하세요."
                                                   delegate:nil
                                          cancelButtonTitle:@"확인!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end