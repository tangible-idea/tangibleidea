//
//  EndchatViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoom.h"
#import "User.h"
#import "UIExpandingTextView.h"

@interface EndchatViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UIView *mainView;
    UITableView *tbl;
    UIView *keyboardBar;
    UIExpandingTextView *keyboard;
    NSMutableArray *messages;
    ChatRoom *chatRoom;
    User *user;
    NSInteger beforeViewIndex;
    NSInteger lastLocalNo;
    NSInteger beforecount;
    NSInteger startLocalNo;
    NSString *lastDate;
    NSString *firstDate;
    
    UIView *refreshHeaderView;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    BOOL isFirst;
    
    MBProgressHUD *activityIndicator;
    id appDelegate;
}

@property (nonatomic, retain) ChatRoom *chatRoom;
@property (nonatomic, retain) User *user;
@property (nonatomic, assign) NSInteger beforeViewIndex;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)getUnloadChat;

@end
