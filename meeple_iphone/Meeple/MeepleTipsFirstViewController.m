//
//  MeepleTipsFirstViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleTipsFirstViewController.h"
#import "MeepleTipsSecondViewController.h"

#import "SettingNav.h"

@implementation MeepleTipsFirstViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"BackButton"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height);
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
    [backBarButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)MenteeButtonPushed
{
    MeepleTipsSecondViewController *view = [[MeepleTipsSecondViewController alloc] init];
    view.m_type = 1;
    [self.navigationController pushViewController:view animated:YES];
    [view release];
    
}
-(IBAction)MentorButtonPushed
{
    MeepleTipsSecondViewController *view = [[MeepleTipsSecondViewController alloc] init];
    view.m_type = 0;
    [self.navigationController pushViewController:view animated:YES];
    [view release];
}

#pragma mark - navigation Button Pushed
-(void)backButtonPushed
{
    [(SettingNav *)self.navigationController.navigationBar changeBgForSetting];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
