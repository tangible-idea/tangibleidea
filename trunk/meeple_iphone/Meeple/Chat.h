//
//  Chat.h
//  meeple_
//
//  Created by Sung Yeol Bae on 11. 9. 8..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//
/*
type = 0 -> 대화      isSuccess = 0 -> 실패 (전송중, 혹은 실패)
1 -> 그림             isSuccess = 1 -> 성공 
2 -> (추후) 동영상     isSucess = 2 -> 전송 중?
*/
#import <Foundation/Foundation.h>

@interface Chat : NSObject
{
    NSString *interlocutor;
    NSInteger roomId;
    NSInteger localNo;
    NSString *text;
    //NSString *image;
    //NSInteger isSuccess;
    NSInteger chatType;
    NSString *date;
    NSString *time;
}

@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger localNo;
@property (nonatomic, copy) NSString *text;
//@property (nonatomic, copy) NSString *image;
//@property (nonatomic, assign) NSInteger isSuccess;
@property (nonatomic, assign) NSInteger chatType;
@property (nonatomic, copy) NSString *interlocutor;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@end
