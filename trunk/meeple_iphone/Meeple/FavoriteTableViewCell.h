//
//  FavoriteTableViewCell.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeepleImageView.h"

@interface FavoriteTableViewCell : UITableViewCell
{
    MeepleImageView *userPic;
    UILabel *userNick;
	UILabel *userSchool;
    UIImageView *bubble;
}

@property (retain, nonatomic) IBOutlet MeepleImageView *userPic;
@property (retain, nonatomic) IBOutlet UILabel *userNick;
@property (retain, nonatomic) IBOutlet UILabel *userSchool;
@property (retain, nonatomic) IBOutlet UIImageView *bubble;
@end
