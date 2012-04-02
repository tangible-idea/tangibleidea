//
//  SegmentManager.h
//  NavBasedSeg
//
//  Created by Marcus Crafter on 25/06/10.
//  Copyright 2010 Red Artisan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SegmentsController : NSObject {
    NSArray                * viewControllers;
    UINavigationController * navigationController;
    UIToolbar *toolbar;
}

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain, readonly) NSArray * viewControllers;
@property (nonatomic, retain, readonly) UINavigationController * navigationController;

- (id)initWithNavigationController:(id)aNavigationController viewControllers:(NSArray *)viewControllers;
//- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;
- (void)segmentMessage;
- (void)segmentFavorite;

@end
