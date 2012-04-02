//
//  SettingViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDelegate,UITableViewDelegate>
{
    UITableView *tbl;
    NSArray *sectionList;
    NSDictionary *settingData;
}

@property (nonatomic, retain) IBOutlet UITableView *tbl;
@end
