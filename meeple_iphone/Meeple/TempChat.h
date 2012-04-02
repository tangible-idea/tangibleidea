//
//  TempChat.h
//  Meeple
//
//  Created by sung yeol bae on 11. 10. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempChat : NSObject
{
    NSInteger no;
    NSInteger isFail; // 0 인경우 false -> 진행 중, 1 인경우 true -> 전송 실패
    NSInteger chatType;
    NSString *text;
    NSString *interlocutor;
}

@property (nonatomic, assign) NSInteger no;
@property (nonatomic, assign) NSInteger isFail;
@property (nonatomic, assign) NSInteger chatType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *interlocutor;

@end
