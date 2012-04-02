//
//  SendingChatRequest.h
//  Meeple
//
//  Created by sung yeol bae on 11. 10. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "TempChat.h"

@interface SendingChatRequest : ASIFormDataRequest
{
    NSInteger roomId;
    NSInteger no;
}

@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger no;

-(void)sendFail;
-(void)sendSuccess;
@end
