//
//  MeepleAppDelegate.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SegmentsController.h"
#import "User.h"
#import "Message.h"
#import "ChatRoom.h"
#import "TempChat.h"
#import "Chat.h"
@interface MeepleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{
    SegmentsController *SegmentsController;
    UINavigationController *segNav;
    NSUserDefaults *userDefaults;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) SegmentsController *segmentsController;

@property (nonatomic, retain) IBOutlet UINavigationController *segNav;

- (NSArray *)segmentViewControllers;

- (void)showTabBar;
// init DB
- (void)initDB:(NSString *)fileName;
- (sqlite3 *)getDatabase:(NSString *)fileName;

// user_list
- (void)getUser:(User *)user userId:(NSString *)userId;
- (NSString *)getUserName:(NSString *)userId;
- (void)getFavoriteList:(NSMutableArray *)result;
- (void)insertUser:(User *)user;
- (void)updateUser:(User *)user;
- (void)deleteUser:(NSString *)userId;
- (void)deleteFavorite:(User *)user;
- (int)isFavorite:(NSString *)userId;
- (void)AddFavoriteList:(NSMutableArray *)list;
- (void)initFavorite;
- (void)updateEndUser:(NSMutableArray *)list;

// recommend_list
- (void)getChatWaitRecommendList:(NSMutableArray *)result;
- (void)getWaitRecommendList:(NSMutableArray *)result;
- (void)getChatRecommendList:(NSMutableArray *)result;

- (void)initRecommendation; // delete recommendation user (즐겨찾기 유저인 경우 update)
- (void)refreshRecommendsWait:(NSMutableArray *)result;
- (void)refreshRecommends:(NSMutableArray *)result;
- (void)refreshRecommendsChat:(NSMutableArray *)result;
//chat_room list

- (void)initChatRoom;
- (void)updateEndChatRoomAndUser;
- (void)getChatRoomList:(NSMutableArray *)result;
- (ChatRoom *)getChatRoomByUserId:(NSString *)userId;
- (void)insertChatRoom:(NSString *)userId;
- (void)checkAndInsertChatRoom:(NSString *)userId;
- (void)refreshChatRoomList:(NSMutableArray *)list;
- (void)updateChatRoom:(ChatRoom *)chatroom;
- (void)deleteChatRoom:(ChatRoom *)chatroom;

//chat_list

- (void)deleteChatAndTempList:(NSInteger)roomId;
- (void)makeChatAndTempList:(NSInteger)roomId;
- (NSInteger)getChatCount:(NSInteger)roomId;
- (NSInteger)getUnloadChatList:(NSMutableArray *)result 
                        roomId:(NSInteger)roomId 
                     firstDate:(NSString *)firstDate 
                          from:(NSInteger)from;

- (NSInteger)getNewChatList:(NSMutableArray *)result 
                     roomId:(NSInteger)roomId 
                lastLocalNo:(NSInteger)lastLocalNo 
                   lastDate:(NSString *)lastDate;

- (NSInteger)getFirstChatList:result 
                       roomId:(NSInteger)roomId 
                  lastLocalNo:(NSInteger)lastLocalNo;

- (void)insertChat:(Chat *)chat roomId:(NSInteger)roomId;
- (void)insertChatWithNo:(NSMutableArray *)chat_list roomId:(NSInteger)roomId;

- (void)getTempChatList:(NSMutableArray *)result roomId:(NSInteger)roomId;
- (void)insertTempChat:(TempChat *)tempChat roomId:(NSInteger)roomId;
- (void)setFailTempChatWithNo:(NSInteger)no roomId:(NSInteger)roomId;
- (void)setResendTempChatWithNo:(NSInteger)no roomId:(NSInteger)roomId;
- (void)updateTempChat:(TempChat *)tempChat roomId:(NSInteger)roomId;
- (void)deleteTempChat:(NSInteger)no roomId:(NSInteger)roomId;

//message_list

- (void)insertMessages:(NSArray *)messageList;
- (void)getMessageList:(NSMutableArray *)result;
- (void)getMessageList:(NSMutableArray *)result from:(NSInteger)from count:(NSInteger)count;
- (void)setMessagesRead:(NSMutableArray *)noList;
- (void)deleteMessage:(NSInteger)no;
- (void)deleteMessageByUserId:(NSString *)userId;
- (NSInteger)getMessagesCount;
- (void)updateMessagesCount:(int)count;
- (void)checkLogin;
@end
