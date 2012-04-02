//
//  FavoriteViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate>
{
    NSString *touchedUserNick;
    NSString *touchedUsrId;
    UITableView *tbl;
    NSMutableArray *favList;
    MBProgressHUD *activityIndicator;
    
    NSMutableDictionary *userPictures;
    id appDelegate;
}

-(void)getFavorite;

@property (nonatomic,retain) IBOutlet UITableView *tbl;
@property (nonatomic,retain) NSMutableArray *favList;
@end
