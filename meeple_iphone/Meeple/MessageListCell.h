//
//  MessageListCell.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 28..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeepleProfileButton.h"

@interface MessageListCell : UITableViewCell
{
    UIImageView *balloonView;
	UILabel *header;
    UILabel *date;
    UILabel *contents;
    MeepleProfileButton *userPic;
    UIImageView *from;
}

@property (nonatomic, retain) IBOutlet UIImageView *balloonView;
@property (nonatomic, retain) IBOutlet UILabel *header;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *contents;
@property (nonatomic, retain) IBOutlet MeepleProfileButton *userPic;
@property (nonatomic, retain) IBOutlet UIImageView *from;
@end
