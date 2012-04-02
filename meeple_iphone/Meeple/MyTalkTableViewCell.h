//
//  MyTalkTableViewCell.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeepleImageView.h"

@interface MyTalkTableViewCell : UITableViewCell
{
    MeepleImageView *userPic;
    UILabel *count;
    UILabel *userName;
	UILabel *lastChat;
    UILabel *lastDate;    
}

@property (retain, nonatomic) IBOutlet MeepleImageView *userPic;
@property (retain, nonatomic) IBOutlet UILabel *count;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UILabel *lastChat;
@property (retain, nonatomic) IBOutlet UILabel *lastDate;

@end
