//
//  ChatRoom.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 22..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoom : NSObject
{
    NSInteger roomId; // room No
    NSString *senderId; // sender Id 
    NSString *senderName;
    NSString *lastMessage; // lastMessage
    NSString *date; // date
    NSString *time;
    NSInteger unreadCount; // count(unread message)
    NSInteger status; // type (진행중, 종료)
    NSInteger lastChatId;
}

@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString *senderId;
@property (nonatomic, copy) NSString *lastMessage;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger lastChatId;
@property (nonatomic, copy) NSString *senderName;
@end
