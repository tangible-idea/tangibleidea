//
//  AgreementViewController.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "AgreementViewController.h"
#import "JoinViewController.h"

@implementation AgreementViewController
@synthesize agreementTextView;
@synthesize mType;
@synthesize auth_id;
@synthesize agreeButton;
@synthesize disagreeButton;
@synthesize auth_univ;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
	agreementTextView.layer.cornerRadius = 5.0f;
	
	[super viewDidLoad];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
 }
 */
- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	//[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.130 green:0.571 blue:0.824 alpha:1.000]];
	self.navigationController.navigationBar.translucent = YES;
	//self.wantsFullScreenLayout = YES;	
	
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.wantsFullScreenLayout = YES;
	self.agreementTextView = nil;
    self.auth_id = nil;
	self.auth_univ = nil;
	
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    self.auth_id = nil;
    self.auth_univ = nil;
	[agreementTextView release];
    [super dealloc];
}

-(IBAction)agreeButtonPressed:(id)sender {
	JoinViewController *joinview = [[[JoinViewController alloc] init] autorelease];
	joinview.mType = mType ;
	if(mType == 0) {
		joinview.authId = self.auth_id;
		joinview.univName = self.auth_univ;
	}
	[self.navigationController pushViewController:joinview animated:YES];
    
}

-(IBAction)disagreeButtonPressed:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
