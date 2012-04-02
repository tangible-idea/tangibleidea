//
//  SegmentManager.m
//  NavBasedSeg
//
//  Created by Marcus Crafter on 25/06/10.
//  Copyright 2010 Red Artisan. All rights reserved.
//

#import "SegmentsController.h"

@interface SegmentsController ()
@property (nonatomic, retain, readwrite) NSArray                * viewControllers;
@property (nonatomic, retain, readwrite) UINavigationController * navigationController;
@end

@implementation SegmentsController

@synthesize viewControllers, navigationController,toolbar;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers
{
    if (self = [super init]) {
    
        self.navigationController   = aNavigationController;
        self.viewControllers = theViewControllers;
    }
    return self;
}
/*
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    NSUInteger index = aSegmentedControl.selectedSegmentIndex;
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:index];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = aSegmentedControl;
}
*/
- (void)dealloc {
    self.viewControllers = nil;
    self.navigationController = nil;
    self.toolbar = nil;
    [super dealloc];
}

- (void)segmentMessage {
    UIBarButtonItem *one = (UIBarButtonItem *)[toolbar.items objectAtIndex:1];
    ((UIButton *)(one.customView)).enabled = YES;
    UIBarButtonItem *two = (UIBarButtonItem *)[toolbar.items objectAtIndex:3];
    ((UIButton *)(two.customView)).enabled = NO;
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:1];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = toolbar;
    
}

- (void)segmentFavorite {
    UIBarButtonItem *one = (UIBarButtonItem *)[toolbar.items objectAtIndex:1];
    ((UIButton *)(one.customView)).enabled = NO;
    UIBarButtonItem *two = (UIBarButtonItem *)[toolbar.items objectAtIndex:3];
    ((UIButton *)(two.customView)).enabled = YES;
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:0];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = toolbar;
    
}


@end
