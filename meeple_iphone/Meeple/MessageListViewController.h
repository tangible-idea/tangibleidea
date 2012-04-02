//
//  MessageListViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 28..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController <UIScrollViewDelegate>
{
    UITableView *tbl;
    NSMutableArray *messages;
    NSMutableArray *read;
    float maxWidth;
    NSString *selectedUserId;
    NSString *selectedUserName;
    
    id appDelegate;
    NSInteger totalCount;
    MBProgressHUD *activityIndicator;
    NSMutableDictionary *userPictures;
}

@property (nonatomic,retain) IBOutlet UITableView *tbl;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) NSMutableArray *read;

@property (nonatomic, copy) NSString *selectedUserId;
@property (nonatomic, copy) NSString *selectedUserName;

-(void)refresh;
-(void)getMessagesFromServer;
@end
