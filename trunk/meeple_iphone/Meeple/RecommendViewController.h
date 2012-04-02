//
//  RecommendViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "PopUpViewController.h"

@interface RecommendViewController : UIViewController <UIScrollViewDelegate,MBProgressHUDDelegate>
{   
    UIScrollView *scrollView;
    NSMutableArray *controllersWait;
    NSMutableArray *controllersChat;
    NSMutableArray *usersWait;
    NSMutableArray *usersChat;
    NSInteger mType;    // mento or mentee type
    NSInteger popUpIndex;
    NSInteger popUpType;
    UIButton *adView;
    
    PopUpViewController *popUpViewController;
    MBProgressHUD *activityIndicator;
    id appDelegate;
    
}

@property (nonatomic, assign) NSInteger mType;
@property (nonatomic, retain) NSMutableArray *usersWait;
@property (nonatomic, retain) NSMutableArray *usersChat;
@property (nonatomic, retain) NSMutableArray *controllersChat;
@property (nonatomic, retain) NSMutableArray *controllersWait;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *adView;

-(void)popUpForWaitMeeple:(id)sender;
-(void)popUpForChatMeeple:(id)sender;
-(IBAction)openURL:(id)sender;

-(void)chatAccept:(id)sender;
-(void)chatReject:(id)sender;
-(void)goChat:(id)sender;

-(void)checkRecommendStatus;
-(void)refresh;
@end
