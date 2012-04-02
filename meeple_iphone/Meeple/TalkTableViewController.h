//
//  TalkTableViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, MBProgressHUDDelegate>
{
    NSArray *sectionList;
    NSMutableDictionary *dataSource;
    UITableView *tbl;
    NSInteger mType;
    NSDateFormatter *dateFormatter;
    id appDelegate;
    BOOL isFirst;
    MBProgressHUD *activityIndicator;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tbl;

-(void)updateChatRoom;
-(void)refresh;
@end
