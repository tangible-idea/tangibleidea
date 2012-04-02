//
//  FavoriteTableViewCell.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 26..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "FavoriteTableViewCell.h"

@implementation FavoriteTableViewCell
@synthesize userPic,userSchool,userNick,bubble;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.userPic = nil;
    self.userNick = nil;
    self.userSchool = nil;
    self.bubble = nil;
    [super dealloc];
}


@end
