//
//  Chat.m
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 9. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "Chat.h"

@implementation Chat
@synthesize roomId,localNo,text,//image
//isSuccess,
chatType,interlocutor,date,time;

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
    self.text = nil;
    //self.image = nil;
    self.interlocutor = nil;
    self.date = nil;
    self.time = nil;
    [super dealloc];
}
@end
