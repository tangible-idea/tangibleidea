//
//  SendingChatRequest.m
//  Meeple
//
//  Created by sung yeol bae on 11. 10. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendingChatRequest.h"
#import "ChatViewController_.h"
#import "SBJson.h"

@implementation SendingChatRequest
@synthesize roomId,no;

- (id)initWithURL:(NSURL *)aURL {

    self = [super initWithURL:aURL];
    __block id blockSelf = self;
    [self setCompletionBlock:^{
        [blockSelf sendSuccess];
    }];
    [self setFailedBlock:^{
        [blockSelf sendFail];
    }];

    return self;
}
- (void)sendSuccess
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSInteger statusCode = [self responseStatusCode];
    if(statusCode == 200)
    {
        NSString *response = [self responseString];
        
        SBJsonParser *parser = [ [ SBJsonParser alloc ] init ];
        NSMutableArray *chat_list = [parser objectWithString:response];
        
        if([chat_list count] == 0)
        {
            [appDelegate setFailTempChatWithNo:no roomId:roomId];
            [parser release];
            
        }
        else
        {
            [appDelegate deleteTempChat:no roomId:roomId];
            NSMutableArray *insert_list = [[NSMutableArray alloc] init];
            for(NSDictionary *user_info in chat_list)
            {
                Chat *chat = [[Chat alloc] init];
                chat.roomId = roomId;
                chat.text = [user_info objectForKey:@"chat"];
                NSString *date = [user_info objectForKey:@"dateTime"];
                chat.date = [date substringToIndex:10];
                chat.time = [date substringFromIndex:11];
                chat.localNo = ((NSString *)[user_info objectForKey:@"chatId"]).intValue;
                chat.interlocutor = [user_info objectForKey:@"senderAccount"];
                [insert_list addObject:chat];
                [chat release];
            }
            
            [appDelegate insertChatWithNo:insert_list roomId:roomId];
            [insert_list release];
            [parser release];
        }
    }
    else
    {
        [appDelegate setFailTempChatWithNo:no roomId:roomId];
        
    }
    UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];

    UIViewController *viewController = [navigationController visibleViewController];
    if([viewController isKindOfClass:[ChatViewController_ class]])
    {
        [(ChatViewController_ *)viewController refresh];
        ((ChatViewController_ *)viewController).chatRoom.unreadCount = 0;
    }
}

- (void)sendFail
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setFailTempChatWithNo:no roomId:roomId];
    
    UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];

    UIViewController *viewController = [navigationController visibleViewController];
    if([viewController isKindOfClass:[ChatViewController_ class]])
    {
        [(ChatViewController_ *)viewController refresh];
    }
}



@end
