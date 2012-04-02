//
//  MessageListCell.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 28..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell
@synthesize userPic, contents, header, balloonView, date,from;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc {
    self.userPic = nil;
    self.contents = nil;
    self.header= nil;
    self.balloonView = nil;
    self.date = nil;
    self.from = nil;
    [super dealloc];
    
}

@end
