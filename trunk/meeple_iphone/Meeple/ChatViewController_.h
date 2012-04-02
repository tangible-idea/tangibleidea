//
//  ChatViewController_.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 23..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoom.h"
#import "User.h"
#import "UIExpandingTextView.h"
#import "MeepleProfileButton.h"
@interface ChatViewController_ : UIViewController 
<UITableViewDelegate,UITableViewDataSource,UIExpandingTextViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
{
    UIView *mainView;
    UITableView *tbl;
    UIView *keyboardBar;
    UIExpandingTextView *keyboard;
    NSMutableArray *messages;
    NSMutableArray *tempMessages;
    UIButton *send;
    ChatRoom *chatRoom;
    User *user;
    NSInteger beforeViewIndex;
    
    NSInteger lastLocalNo;
    NSInteger beforecount;
    NSInteger startLocalNo;
    NSString *lastDate;
    NSString *firstDate;
    
    NSInteger selectedFailMessageNo;
    NSInteger selectedFailMessageIndex;
    
    UIView *refreshHeaderView;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    BOOL isFirst;
    
    MBProgressHUD *activityIndicator;
    MeepleProfileButton *senderImageButton;
    id appDelegate;
}

@property (nonatomic, retain) ChatRoom *chatRoom;
@property (nonatomic, retain) User *user;
@property (nonatomic, assign) NSInteger beforeViewIndex;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;


- (void) scrollViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;
- (void) backgroundTap:(UIGestureRecognizer *)gesture;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)getUnloadChat;
- (void)refresh;
-(void)getNewChat;
@end
