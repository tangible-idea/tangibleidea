//
//  ChatRoom.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "ChatRoom.h"

@implementation ChatRoom
@synthesize roomId,senderId,lastMessage,date,time,unreadCount,lastChatId,status,senderName;

- (void)dealloc 
{
    self.senderId = nil;
    self.senderName = nil;
    self.lastMessage = nil;
    self.date = nil;
    
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end
