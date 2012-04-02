//
//  MeepleIntroduceViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleIntroduceViewController.h"
#import "SettingNav.h"

@implementation MeepleIntroduceViewController
@synthesize scrollView,pageControl;

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

- (void)dealloc
{
    self.scrollView = nil;
    self.pageControl = nil;
    [super dealloc];
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
    int i = 0;
    for(i=0; i< 2; i++)
    {
        CGRect frame;
        frame.origin.x = 21 + 320*i;
        frame.origin.y = 0;
        frame.size.width = 278;
        frame.size.height = 342;
        UIImageView *temp = [[UIImageView alloc] init];
        [temp setFrame:frame];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"04_3_intro%d",i+1]];
        [temp setImage:image];
        [scrollView addSubview:temp];
        [temp release];
    }
    pageControl.numberOfPages = i;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * i , 342);
    
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.pageControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark ScrollView

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(!pageControlBeingUsed) {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) +1;
        self.pageControl.currentPage = page;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

-(void)scrollViewDidEndDeceleration:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}
#pragma mark - pagecontrol

-(IBAction)changePage
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}

#pragma mark - navigation

-(void)backButtonPushed
{
    [(SettingNav *)self.navigationController.navigationBar changeBgForSetting];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
