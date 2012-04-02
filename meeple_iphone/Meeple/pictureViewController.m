//
//  pictureViewController.m
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 8. 20..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "pictureViewController.h"

@implementation pictureViewController
@synthesize  image, userId,imageView;

-(void) dealloc 
{
    self.image = nil;
    self.userId = nil;
    self.imageView = nil;

    [super dealloc];
}
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
    imageView.image = image;
    self.navigationItem.title = userId;
    [self.navigationController.navigationBar setTranslucent:TRUE];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPushed)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftItem release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.image = nil;
    self.userId = nil;
    [imageView release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:FALSE];
}

-(IBAction)hidesBar:(id)sender 
{
    
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

-(void)doneButtonPushed
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
