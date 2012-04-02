//
//  Message.h
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 9. 6..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject
{   
    NSInteger no;
    NSString *senderId;
    NSString *receiverId;
    NSString *date;
    NSInteger isRead;
    NSString *text;
    NSString *name;
    
    NSString *selectedUserId;
    NSString *selectedUserName;
}

@property (nonatomic, assign) NSInteger no;
@property (nonatomic, copy) NSString *senderId;
@property (nonatomic, copy) NSString *receiverId;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;

@end
