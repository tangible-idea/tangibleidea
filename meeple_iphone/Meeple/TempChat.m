//
//  TempChat.m
//  Meeple
//
//  Created by sung yeol bae on 11. 10. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TempChat.h"

@implementation TempChat
@synthesize no,isFail,chatType,text,interlocutor;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    self.text = nil;
    self.interlocutor = nil;
    [super dealloc];
}
@end
