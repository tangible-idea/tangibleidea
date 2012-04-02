//
//  MyTalkTableViewCell.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MyTalkTableViewCell.h"

@implementation MyTalkTableViewCell
@synthesize userPic,count, userName, lastChat, lastDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

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
    self.userName = nil;
    self.lastChat = nil;
    self.lastDate = nil;
    self.count = nil;
    [super dealloc];
}

@end
