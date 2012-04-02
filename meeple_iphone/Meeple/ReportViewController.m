//
//  ReportViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ReportViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@implementation ReportViewController
@synthesize userIdField,reasonView,userIdFieldBg,reasonViewBg,contentsView;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.24;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.91;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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
    self.userIdField = nil;
    self.reasonView = nil;
    self.userIdFieldBg = nil;
    self.reasonViewBg = nil;
    self.contentsView = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.userIdField = nil;
    self.reasonView = nil;
    self.userIdFieldBg = nil;
    self.reasonViewBg = nil;
    self.contentsView = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주의"
                                                    message:@"신고 시, 신고 된 유저와의 대화 내용을 운영자가 보고 판단하여야 하므로 운영자가 대화를 보는 것에 동의하는 것으로 간주합니다"
                                                   delegate:nil
                                          cancelButtonTitle:@"확인" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    
    /* UINavigationBar Setting */
    
    UIImage *backButtonImage = [UIImage imageNamed:@"BackButton"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
    
    UIImage *reportButtonImage = [UIImage imageNamed:@"04_4_ReportButton.png"];
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportButton.bounds = CGRectMake( 0, 0, reportButtonImage.size.width, reportButtonImage.size.height);
    [reportButton addTarget:self action:@selector(reportButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [reportButton setImage:reportButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *reportBarButton = [[UIBarButtonItem alloc] initWithCustomView:reportButton];
    self.navigationItem.rightBarButtonItem=reportBarButton;
    [reportBarButton release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150.0f,28.0f)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:59/255 green:66.0f/255 blue:90.0f/255 alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:21.0];
    titleLabel.text = @"신고하기";
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    /* setting NavigationBar End */
    
    UIImage *fieldBgImage = [UIImage imageNamed:@"04_4_TextFieldBg"];
    UIImage *viewBgImage = [UIImage imageNamed:@"04_4_TextViewBg"];
    
    [userIdFieldBg setImage:[fieldBgImage stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
    [reasonViewBg setImage:[viewBgImage stretchableImageWithLeftCapWidth:30 topCapHeight:30]];
    reasonView.contentInset = UIEdgeInsetsMake(-4,-8,0,0);

    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)textFieldDone:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap {
	[userIdField resignFirstResponder];
    [reasonView resignFirstResponder];
}

-(void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reportButtonPushed {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = userIdField.text;
    NSString *reason = reasonView.text;
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@ReportUser?localAccount=%@&oppoAccount=%@&session=%@&content=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],userId,[userDefaults objectForKey:kSessionIdKey],reason] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    /*
    [request setPostValue:userId forKey:@"userId"];
    [request setPostValue:reason forKey:@"reason"];
    [request setPostValue:@"bsr117" forKey:@"myId"];
    */
    [request setCompletionBlock:^{
        NSString *response = [request responseString];
        NSInteger status = [request responseStatusCode];
        if(status == 200)
        {
            BOOL success = [response boolValue];
            if(success)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"신고 성공"
                                                                message:@"신고 요청이 완료되었습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"신고 실패"
                                                                message:@"서버에 문제가 있습니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인!" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"신고 실패"
                                                            message:@"서버에 문제가 있습니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인!" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    
    [request setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"신고 요청 실패"
														message:@"3G/WIFI 상태를 확인하세요."
													   delegate:nil
											  cancelButtonTitle:@"확인!" 
											  otherButtonTitles:nil];
		[alert show];
        [alert release];
        
    }];
    
    [request startAsynchronous];
}

#pragma mark- textview

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textViewRect =
    [contentsView.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [contentsView.window convertRect:contentsView.bounds fromView:contentsView];
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
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
    CGRect viewFrame = contentsView.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [contentsView setFrame:viewFrame];
    
    [UIView commitAnimations];
 
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = contentsView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [contentsView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
