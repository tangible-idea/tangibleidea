//
//  Message.m
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 9. 6..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize no,senderId,date,isRead,text,receiverId,name;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc 
{
    self.senderId = nil;
    self.date = nil;
    self.text = nil;
    self.receiverId = nil;
    self.name = nil;
    [super dealloc];
}

@end
