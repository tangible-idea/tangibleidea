//
//  MeepleAppDelegate.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 16..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "MeepleAppDelegate.h"
#import "FavoriteViewController.h"
#import "MessageListViewController.h"
#import "LoginViewController.h"
#import "MeepleToolBar.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "BeforeLoginViewController.h"
#import "RecommendViewController.h"
#import "ChatViewController_.h"

@implementation MeepleAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize segmentsController,segNav;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if([[userDefaults objectForKey:kUserIdKey] isEqualToString:@""] || [userDefaults objectForKey:kUserIdKey] == nil)
    { 
    
        BeforeLoginViewController *loginBefore = [[BeforeLoginViewController alloc] init];
        self.window.rootViewController = loginBefore;
        [loginBefore release];
    
        LoginViewController *loginView = [[[LoginViewController alloc] init] autorelease];
        
        UINavigationController *loginViewNav = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
        loginViewNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentModalViewController:loginViewNav animated:YES];
    }
    else
    {
        NSArray * viewControllers = [self segmentViewControllers];
        segmentsController = [[SegmentsController alloc] initWithNavigationController:segNav viewControllers:viewControllers];
        UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *flexibleSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favButton.frame = CGRectMake( 0, 0, 84, 24);
        [favButton addTarget:segmentsController action:@selector(segmentFavorite) forControlEvents:UIControlEventTouchUpInside];
        [favButton setImage:[UIImage imageNamed:@"03_SegmentFav"] forState:UIControlStateNormal];
        [favButton setImage:[UIImage imageNamed:@"03_SegmentFavSelected"] forState:UIControlStateDisabled];
        UIBarButtonItem *favBarButton = [[UIBarButtonItem alloc] initWithCustomView:favButton];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        messageButton.frame = CGRectMake(0, 0, 85, 24);
        [messageButton addTarget:segmentsController action:@selector(segmentMessage) forControlEvents:UIControlEventTouchUpInside];
        [messageButton setImage:[UIImage imageNamed:@"03_SegmentMessage"] forState:UIControlStateNormal];
        [messageButton setImage:[UIImage imageNamed:@"03_SegmentMessageSelected"] forState:UIControlStateDisabled];
        UIBarButtonItem *messageBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
        
        NSArray *buttons = [NSArray arrayWithObjects:flexibleSpace1,favBarButton,flexibleSpace2, messageBarButton,flexibleSpace3,nil];
        MeepleToolBar *toolbar = [[MeepleToolBar alloc] initWithFrame:CGRectMake(0, 0, 169, 25)];
        toolbar.backgroundColor = [UIColor whiteColor];
        
        [toolbar setItems:buttons animated:NO];
        
        [messageBarButton release];
        [favBarButton release];
        
        [flexibleSpace1 release];
        [flexibleSpace2 release];
        [flexibleSpace3 release];
        segmentsController.toolbar = toolbar;
        [segmentsController segmentFavorite];
        
        [toolbar release];
        
        //[self initDB:FILE_NAME];
        
        self.window.rootViewController = self.tabBarController;
    }
    
    [self.window makeKeyAndVisible];

    
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    NSDictionary *userInfo = [launchOptions objectForKey:
                              UIApplicationLaunchOptionsRemoteNotificationKey]; 
    
    if(userInfo != nil) 
    { 
        [self application:application didReceiveRemoteNotification:userInfo];
    }

    return YES;
}
- (void)showTabBar
{
    NSArray * viewControllers = [self segmentViewControllers];
    segmentsController = [[SegmentsController alloc] initWithNavigationController:segNav viewControllers:viewControllers];
    UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favButton.frame = CGRectMake( 0, 0, 84, 24);
    [favButton addTarget:segmentsController action:@selector(segmentFavorite) forControlEvents:UIControlEventTouchUpInside];
    [favButton setImage:[UIImage imageNamed:@"03_SegmentFav"] forState:UIControlStateNormal];
    [favButton setImage:[UIImage imageNamed:@"03_SegmentFavSelected"] forState:UIControlStateDisabled];
    UIBarButtonItem *favBarButton = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0, 85, 24);
    [messageButton addTarget:segmentsController action:@selector(segmentMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageButton setImage:[UIImage imageNamed:@"03_SegmentMessage"] forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"03_SegmentMessageSelected"] forState:UIControlStateDisabled];
    UIBarButtonItem *messageBarButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    
    NSArray *buttons = [NSArray arrayWithObjects:flexibleSpace1,favBarButton,flexibleSpace2, messageBarButton,flexibleSpace3,nil];
    MeepleToolBar *toolbar = [[MeepleToolBar alloc] initWithFrame:CGRectMake(0, 0, 169, 25)];
    toolbar.backgroundColor = [UIColor whiteColor];
    
    [toolbar setItems:buttons animated:NO];
    
    [messageBarButton release];
    [favBarButton release];
    
    [flexibleSpace1 release];
    [flexibleSpace2 release];
    [flexibleSpace3 release];
    segmentsController.toolbar = toolbar;
    [segmentsController segmentFavorite];
    
    [toolbar release];
    
    //[self initDB:FILE_NAME];
    
    self.window.rootViewController = self.tabBarController;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    int app1 = [[[self.tabBarController.tabBar.items objectAtIndex:0] badgeValue] intValue];
    int app2 = [[[self.tabBarController.tabBar.items objectAtIndex:1] badgeValue] intValue];
    int app3 = [[[self.tabBarController.tabBar.items objectAtIndex:2] badgeValue] intValue];
    application.applicationIconBadgeNumber = app1 + app2 + app3;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    int app1 = [[[self.tabBarController.tabBar.items objectAtIndex:0] badgeValue] intValue];
    int app2 = [[[self.tabBarController.tabBar.items objectAtIndex:1] badgeValue] intValue];
    int app3 = [[[self.tabBarController.tabBar.items objectAtIndex:2] badgeValue] intValue];
    application.applicationIconBadgeNumber = app1 + app2 + app3;
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    self.segmentsController = nil;
    self.segNav = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Segment Content

- (NSArray *)segmentViewControllers {
    UIViewController *firstView =  [[FavoriteViewController alloc] init];
    UIViewController *secondView = [[MessageListViewController alloc] init];
    
    NSArray * viewControllers = [NSArray arrayWithObjects:firstView,secondView, nil];
    
    [firstView release];
    [secondView release];
    
    return viewControllers;
}

#pragma mark - push

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newToken = [deviceToken description];
    
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [userDefaults setObject:@"TRUE" forKey:kPushAllowKey];
    [userDefaults setObject:newToken forKey:kDeviceTokenKey];

}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [userDefaults setObject:@"FALSE" forKey:kPushAllowKey];
    [userDefaults setObject:@"0000000000000000000000000000000000000000000000000000000000000000" forKey:kDeviceTokenKey];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *type = [userInfo objectForKey:@"t"];
    
    switch ([type intValue]) {
        case 1: // 1 -> message
        {
            NSString *currentBadge = [[_tabBarController.tabBar.items objectAtIndex:2] badgeValue];
            [[_tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",([currentBadge intValue]+1)]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessage" object:self];
            break;
        }
        case 2:
        {
            NSString *currentBadge = [[_tabBarController.tabBar.items objectAtIndex:1] badgeValue];
            [[_tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",([currentBadge intValue]+1)]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newChat" object:self];
            break;
        }
        case 3:
        {
            NSString *currentBadge = [[_tabBarController.tabBar.items objectAtIndex:1] badgeValue];
            [[_tabBarController.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d",([currentBadge intValue]+1)]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRecommend" object:self];
            break;
        }
        default:
            break;
    }
    
    
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


#pragma mark - initDB and Get_database

- (void)initDB:(NSString *)fileName;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    /*database 여부 확인 */
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) return;
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    
    // user_list 
    char *sql = "CREATE TABLE user_list (user_id TEXT PRIMARY KEY NOT NULL, type INTEGER, name TEXT, image_url TEXT, school TEXT, major TEXT, grade INTEGER, update_date TEXT, talk TEXT, flag INTEGER)";
    if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    
    // message_list
    
    sql = "CREATE TABLE message_list (no INTEGER PRIMARY KEY AUTOINCREMENT, sender_id TEXT, receiver_id TEXT, date TEXT, text TEXT, is_read INTEGER)";
    if (sqlite3_exec(database,sql,nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    // chatroom_list
    sql = "CREATE TABLE chatroom_list (room_id INTEGER PRIMARY KEY NOT NULL, sender_id TEXT, count INTEGER, last_message TEXT, status INTEGER, date TEXT, last_chat_id INTEGER)";
    
    if (sqlite3_exec(database,sql,nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    
    sqlite3_close(database);
}

- (sqlite3 *)getDatabase:(NSString *)fileName 
{
    sqlite3 *database;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    return database;
}

#pragma mark - user_list (for Recommend, Favorite) db

- (void)getUser:(User *)user userId:(NSString *)userId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk, flag FROM user_list where user_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String],  -1, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            user.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                user.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                user.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                user.major = [NSString stringWithUTF8String:major];
            }
            user.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                user.updateDate = [NSString stringWithUTF8String:date];
            }
            user.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                user.talk = [NSString stringWithUTF8String:talk];
            }
            user.flag = sqlite3_column_int(statement, 9);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (NSString *)getUserName:(NSString *)userId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *ret = [NSString stringWithFormat:@""];
    char *sql = "SELECT name FROM user_list where user_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String],  -1, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 0);
            if(name != NULL) {
                ret = [NSString stringWithUTF8String:name];
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return ret;
}

- (void)getFavoriteList:(NSMutableArray *)result
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk, flag FROM user_list where flag = 4 or flag = 5 or flag = 6 or flag = 7 or flag = 8 ";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            User *fav = [[User alloc] init];
            fav.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            fav.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                fav.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                fav.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                fav.major = [NSString stringWithUTF8String:major];
            }
            fav.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                fav.updateDate = [NSString stringWithUTF8String:date];
            }
            fav.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                fav.talk = [NSString stringWithUTF8String:talk];
            }
            fav.flag = sqlite3_column_int(statement, 9);
            [result addObject:fav];
            [fav release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)insertUser:(User *)user
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "INSERT INTO user_list (user_id,name,image_url,school,major,grade,update_date,type,talk,flag) VALUES(?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [user.userId UTF8String],  -1, nil);
        sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, nil);
        sqlite3_bind_text(statement, 3, [user.imageURL UTF8String], -1, nil);
        sqlite3_bind_text(statement, 4, [user.school UTF8String], -1, nil);
        sqlite3_bind_text(statement, 5, [user.major UTF8String], -1, nil);
        sqlite3_bind_int(statement, 6, user.grade);
        sqlite3_bind_text(statement, 7, [user.updateDate UTF8String], -1, nil);
        sqlite3_bind_int(statement, 8, user.type);
        sqlite3_bind_text(statement, 9, [user.talk UTF8String], -1, nil);
        sqlite3_bind_int(statement, 10, user.flag);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)updateUser:(User *)user
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "update user_list set name = ? , image_url = ?, school = ?, major = ?, grade = ?, update_date = ?, type = ?, talk = ?, flag = ? where user_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
        sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
        sqlite3_bind_text(statement, 3, [user.school UTF8String], -1, nil);
        sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
        sqlite3_bind_int(statement, 5, user.grade);
        sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
        sqlite3_bind_int(statement,7, user.type);
        sqlite3_bind_text(statement, 8, [user.talk UTF8String], -1, nil);
        sqlite3_bind_int(statement, 9, user.flag);
        sqlite3_bind_text(statement, 10, [user.userId UTF8String],  -1, nil);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)deleteUser:(NSString *)userId {
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "delete from user_list where user_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)AddFavoriteList:(NSMutableArray *)list
{
    [self initFavorite];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [list count] ; i++) 
    {
        User *user = [list objectAtIndex:i];
        int isfavorite = [self isFavorite:user.userId];
        if(isfavorite >=4)
        {
            char *sql = "UPDATE user_list SET name = ? , image_url = ? , school = ?, major = ?, grade = ?, update_date = ? , talk = ? WHERE user_id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 5, user.grade);
                sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_text(statement, 7, [user.talk UTF8String], -1, nil);
                sqlite3_bind_text(statement, 8, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        else if(isfavorite >=0)
        {
            char *sql = "UPDATE user_list SET name = ? , image_url = ? , school = ?, major = ?, grade = ?, update_date = ? , talk = ?, flag = flag + 5 WHERE user_id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 5, user.grade);
                sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_text(statement, 7, [user.talk UTF8String], -1, nil);
                sqlite3_bind_text(statement, 8, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        else
        {
            char *sql = "INSERT INTO user_list (user_id,name,image_url,school,major,grade,update_date,type,talk,flag) VALUES(?,?,?,?,?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 4, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 5, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 6, user.grade);
                sqlite3_bind_text(statement, 7, [user.updateDate UTF8String], -1, nil);
                if([[userDefaults objectForKey:kUserTypeKey] intValue] == 0)
                {
                    sqlite3_bind_int(statement, 8, 1);
                }
                else
                {
                    sqlite3_bind_int(statement, 8, 0);
                }
                sqlite3_bind_text(statement, 9, [user.talk UTF8String], -1, nil);
                sqlite3_bind_int(statement, 10, 4);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
    }
    sqlite3_close(database);
   
}
- (int)isFavorite:(NSString *)userId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    int flag = -1;
    char *sql = "SELECT flag FROM user_list where user_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String],  -1, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            flag = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return flag;
}
- (void)initFavorite
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "delete from user_list where flag = 4";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sql = "update user_list set flag = flag - 5 where flag > 4";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)deleteFavorite:(User *)user {
    /*
     user 의 flag 가 4 인 경우는 아무 일도 없으므로 지워버려도 됨! 
     하지만 5,6,7,8 인 경우 0,1,2,3 으로 교체할 것
     */
    if(user.flag == 4)
    {
        sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
        sqlite3_stmt *statement;
        char *sql = "delete from user_list where user_id = ?";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    else 
    {
        user.flag = user.flag - 5;
        [self updateUser:user];
    }
    
}

#pragma recommend_list
- (void)getChatRecommendList:(NSMutableArray *)result
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk, flag FROM user_list where flag = 2 or flag = 7 order by flag";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            User *user = [[User alloc] init];
            user.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                user.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                user.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                user.major = [NSString stringWithUTF8String:major];
            }
            user.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                user.updateDate = [NSString stringWithUTF8String:date];
            }
            user.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                user.talk = [NSString stringWithUTF8String:talk];
            }
            user.flag = sqlite3_column_int(statement,9);
            [result addObject:user];
            [user release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)getChatWaitRecommendList:(NSMutableArray *)result
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk,flag FROM user_list where flag != 3 and flag != 4 and flag != 8 order by flag";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            User *user = [[User alloc] init];
            user.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                user.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                user.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                user.major = [NSString stringWithUTF8String:major];
            }
            user.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                user.updateDate = [NSString stringWithUTF8String:date];
            }
            user.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                user.talk = [NSString stringWithUTF8String:talk];
            }
            user.flag = sqlite3_column_int(statement,9);
            [result addObject:user];
            [user release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

// getWaitRecommendList 함수의 경우 특별히 mentee 의 입장에서는 추천대기와 , 채팅 모두를 포함하므로 
// getWaitRecommendList 가 wait, chat 모두를 포함하게 된다. 즉 간단히 말하면 mento 의 경우는 나눠서 쓰지만
// mentee 의 경우는 이 함수 하나만 호출한다.

- (void)getWaitRecommendList:(NSMutableArray *)result
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk,flag FROM user_list where flag = 0 or flag = 5 order by flag";
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            User *user = [[User alloc] init];
            user.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                user.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                user.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                user.major = [NSString stringWithUTF8String:major];
            }
            user.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                user.updateDate = [NSString stringWithUTF8String:date];
            }
            user.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                user.talk = [NSString stringWithUTF8String:talk];
            }
            user.flag = sqlite3_column_int(statement,9);
            [result addObject:user];
            [user release];
        }
        sqlite3_finalize(statement);
    }
    
    sql = "SELECT user_id, name, image_url, school, major, grade, update_date, type, talk,flag FROM user_list where flag = 1 or flag = 6 order by flag";
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            User *user = [[User alloc] init];
            user.userId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
            user.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
            char *imageURL = (char *)sqlite3_column_text(statement, 2);
            if(imageURL != NULL) {
                user.imageURL = [NSString stringWithUTF8String:imageURL];
            }
            char *school = (char *)sqlite3_column_text(statement, 3);
            if(school != NULL) {
                user.school = [NSString stringWithUTF8String:school];
            }
            char *major = (char *)sqlite3_column_text(statement, 4);
            if(major != NULL) {
                user.major = [NSString stringWithUTF8String:major];
            }
            user.grade = sqlite3_column_int(statement,5);
            char *date = (char *)sqlite3_column_text(statement, 6);
            if(date != NULL) {
                user.updateDate = [NSString stringWithUTF8String:date];
            }
            user.type = sqlite3_column_int(statement,7);
            char *talk = (char *)sqlite3_column_text(statement, 8);
            if(talk != NULL) {
                user.talk = [NSString stringWithUTF8String:talk];
            }
            user.flag = sqlite3_column_int(statement,9);
            [result addObject:user];
            [user release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)initRecommendation
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    
    char *sql = "delete FROM user_list where flag = 0 or flag = 1 or flag = 3";
    if (sqlite3_exec(database,sql,nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    sql = "update user_list set flag = 4 where flag = 5 or flag = 6 or flag = 7";
    if (sqlite3_exec(database,sql,nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    
    sqlite3_close(database);
}
- (void)initChatRoom
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    
    char *sql = "update chatroom_list set status = 2 where status = 0"; //2 -> 보류상태
    if (sqlite3_exec(database,sql,nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }
    
    sqlite3_close(database);

}
/*
 * 대기 중인 상태 
 */
- (void)refreshRecommendsWait:(NSMutableArray *)list
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [list count] ; i++) 
    {
        User *user = [list objectAtIndex:i];
        int isfavorite = [self isFavorite:user.userId];
        if(isfavorite >=4)
        {
            char *sql = "UPDATE user_list SET name = ? , image_url = ? , school = ?, major = ?, grade = ?, update_date = ? , talk = ?, flag = 6 WHERE user_id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 5, user.grade);
                sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_text(statement, 7, [user.talk UTF8String], -1, nil);
                sqlite3_bind_text(statement, 8, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        else 
        {
            char *sql = "INSERT INTO user_list (user_id,name,image_url,school,major,grade,update_date,type,talk,flag) VALUES(?,?,?,?,?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 4, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 5, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 6, user.grade);
                sqlite3_bind_text(statement, 7, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_int(statement, 8, 1);
                sqlite3_bind_text(statement, 9, [user.talk UTF8String], -1, nil);
                sqlite3_bind_int(statement, 10, 1);
                sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
    }
    sqlite3_close(database);
}
/*
 추천 상태
 */
- (void)refreshRecommends:(NSMutableArray *)list
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [list count] ; i++) 
    {
        User *user = [list objectAtIndex:i];
        int isfavorite = [self isFavorite:user.userId];
        if(isfavorite >=4)
        {
            char *sql = "UPDATE user_list SET name = ? , image_url = ? , school = ?, major = ?, grade = ?, update_date = ? , talk = ?, flag = 5 WHERE user_id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 5, user.grade);
                sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_text(statement, 7, [user.talk UTF8String], -1, nil);
                sqlite3_bind_text(statement, 8, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        else 
        {
            char *sql = "INSERT INTO user_list (user_id,name,image_url,school,major,grade,update_date,type,talk,flag) VALUES(?,?,?,?,?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 4, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 5, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 6, user.grade);
                sqlite3_bind_text(statement, 7, [user.updateDate UTF8String], -1, nil);
                if([[userDefaults objectForKey:kUserTypeKey] intValue] == 0)
                {
                    sqlite3_bind_int(statement, 8, 1);
                }
                else
                {
                    sqlite3_bind_int(statement, 8, 0);
                }
                sqlite3_bind_text(statement, 9, [user.talk UTF8String], -1, nil);
                sqlite3_bind_int(statement, 10, 0);
                sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
    }
    sqlite3_close(database);
}
/*
 채팅 상태
 */
- (void)refreshRecommendsChat:(NSMutableArray *)list
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [list count] ; i++) 
    {
        User *user = [list objectAtIndex:i];
        int isfavorite = [self isFavorite:user.userId];
        if(isfavorite >=4)
        {
            char *sql = "UPDATE user_list SET name = ? , image_url = ? , school = ?, major = ?, grade = ?, update_date = ? , talk = ?, flag = 7 WHERE user_id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 2, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 4, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 5, user.grade);
                sqlite3_bind_text(statement, 6, [user.updateDate UTF8String], -1, nil);
                sqlite3_bind_text(statement, 7, [user.talk UTF8String], -1, nil);
                sqlite3_bind_text(statement, 8, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        else 
        {
            char *sql = "INSERT INTO user_list (user_id,name,image_url,school,major,grade,update_date,type,talk,flag) VALUES(?,?,?,?,?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, nil);
                sqlite3_bind_text(statement, 3, [user.imageURL UTF8String], -1, nil);
                sqlite3_bind_text(statement, 4, [user.school UTF8String],-1,nil);
                sqlite3_bind_text(statement, 5, [user.major UTF8String], -1, nil);
                sqlite3_bind_int(statement, 6, user.grade);
                sqlite3_bind_text(statement, 7, [user.updateDate UTF8String], -1, nil);
                if([[userDefaults objectForKey:kUserTypeKey] intValue] == 0)
                {
                    sqlite3_bind_int(statement, 8, 1);
                }
                else
                {
                    sqlite3_bind_int(statement, 8, 0);
                }
                sqlite3_bind_text(statement, 9, [user.talk UTF8String], -1, nil);
                sqlite3_bind_int(statement, 10, 2);
                sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                }
                sqlite3_finalize(statement);
            }
        }
        char *sql = "update chatroom_list set status = 0 where sender_id = ? and status = 2";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [user.userId UTF8String], -1, nil);
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        }
        [self checkAndInsertChatRoom:user.userId];
    }
    
    sqlite3_close(database);
    [self updateEndChatRoomAndUser];
}

#pragma mark - chatroom_list db
- (void)updateEndUser:(NSMutableArray *)list
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    for(int i=0; i < [list count] ; i++) 
    {
        NSString *userId = [list objectAtIndex:i];
        int isfavorite = [self isFavorite:userId];
        if(isfavorite == 4)
        {
            char *sql = "UPDATE user_list set flag = 8 WHERE user_id = ?";
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text(statement,1,[userId UTF8String],-1,nil);
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    
                }
                sqlite3_finalize(statement);
            }
        }
        else if(isfavorite == 2)
        {
            char *sql = "UPDATE user_list set flag = 3 WHERE user_id = ?";
            sqlite3_stmt *statement;
            if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_bind_text(statement,1,[userId UTF8String],-1,nil);
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    
                }
                sqlite3_finalize(statement);
            }
        }
    }
    sqlite3_close(database);
}
- (void)updateEndChatRoomAndUser
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    NSMutableArray *id_list = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    char *sql = "select sender_id from chatroom_list where status = 2";
    if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK) {
        if(sqlite3_step(statement) != SQLITE_DONE) {
            char *senderId = (char *)sqlite3_column_text(statement,0);
            if(senderId != NULL) {
                [id_list addObject:[NSString stringWithUTF8String:senderId]];
            }
        }
        sqlite3_finalize(statement);
    }
    [self updateEndUser:id_list];
    [id_list release];
    
    sql = "update chatroom_list set status = 1 where status = 2";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)refreshChatRoomList:(NSMutableArray *)list
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    for(int i=0; i < [list count] ; i++) 
    {
        ChatRoom *room = [list objectAtIndex:i];
        [self checkAndInsertChatRoom:room.senderId];
        sqlite3_stmt *statement;
        char *sql = "UPDATE chatroom_list SET last_message = ? , count = ?, date = ? , last_chat_id = ? WHERE sender_id = ? AND status = 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [room.lastMessage UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [room.date UTF8String], -1, nil);
            sqlite3_bind_int(statement, 2, room.unreadCount);
            sqlite3_bind_text(statement, 5, [room.senderId UTF8String], -1, nil);
            sqlite3_bind_int(statement, 4, room.lastChatId);
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        }
    }
    sqlite3_close(database);
}

- (void)getChatRoomList:(NSMutableArray *)result{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    [result removeAllObjects];
    sqlite3_stmt *statement;
    char *sql = "SELECT chatroom_list.room_id, chatroom_list.sender_id, chatroom_list.count,chatroom_list.last_message,chatroom_list.status, chatroom_list.date, user_list.name,chatroom_list.last_chat_id FROM chatroom_list, user_list where chatroom_list.sender_id = user_list.user_id";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            ChatRoom *chatroom = [[ChatRoom alloc] init];
            chatroom.roomId = sqlite3_column_int(statement,0);
            char *senderId = (char *)sqlite3_column_text(statement,1);
            if(senderId != NULL) {
                chatroom.senderId = [NSString stringWithUTF8String:senderId];
            }
            chatroom.unreadCount = sqlite3_column_int(statement,2);
            char *lastMessage = (char *)sqlite3_column_text(statement, 3);
            if(lastMessage != NULL) {
                chatroom.lastMessage = [NSString stringWithUTF8String:lastMessage];
            }
            chatroom.status = sqlite3_column_int(statement,4);
            char *date = (char *)sqlite3_column_text(statement, 5);
            if(date != NULL) {
                chatroom.date = [NSString stringWithUTF8String:date];
            }
            char *name = (char *)sqlite3_column_text(statement,6);
            if(name != NULL) {
                chatroom.senderName = [NSString stringWithUTF8String:name];
            }
            
            chatroom.lastChatId = sqlite3_column_int(statement,7);
            
            [result addObject:chatroom];
            [chatroom release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (ChatRoom *)getChatRoomByUserId:(NSString *)userId
{
    ChatRoom *tempChatRoom = [[ChatRoom alloc] init];
    tempChatRoom.roomId = -1;
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT chatroom_list.room_id, chatroom_list.sender_id, chatroom_list.count,chatroom_list.last_message,chatroom_list.status, chatroom_list.date, user_list.name,chatroom_list.last_chat_id FROM chatroom_list, user_list where chatroom_list.sender_id = ? and chatroom_list.sender_id = user_list.user_id and chatroom_list.status = 0";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            tempChatRoom.roomId = sqlite3_column_int(statement,0);
            char *senderId = (char *)sqlite3_column_text(statement,1);
            if(senderId != NULL) {
                tempChatRoom.senderId = [NSString stringWithUTF8String:senderId];
            }
            tempChatRoom.unreadCount = sqlite3_column_int(statement,2);
            char *lastMessage = (char *)sqlite3_column_text(statement, 3);
            if(lastMessage != NULL) {
                tempChatRoom.lastMessage = [NSString stringWithUTF8String:lastMessage];
            }
            tempChatRoom.status = sqlite3_column_int(statement,4);
            char *date = (char *)sqlite3_column_text(statement, 5);
            if(date != NULL) {
                tempChatRoom.date = [NSString stringWithUTF8String:date];
            }
            char *name = (char *)sqlite3_column_text(statement,6);
            if(name != NULL) {
                tempChatRoom.senderName = [NSString stringWithUTF8String:name];
            }
            
            tempChatRoom.lastChatId = sqlite3_column_int(statement,7);
        }
        sqlite3_finalize(statement);
    }
    /*
    if(tempChatRoom.roomId == -1)
    {
        sql = "INSERT INTO chatroom_list (sender_id,count,last_message,status,date) VALUES(?,0,'',0,'')";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                tempChatRoom.roomId = sqlite3_column_int(statement,0);
                char *senderId = (char *)sqlite3_column_text(statement,1);
                if(senderId != NULL) {
                    tempChatRoom.senderId = [NSString stringWithUTF8String:senderId];
                }
                tempChatRoom.unreadCount = sqlite3_column_int(statement,2);
                char *lastMessage = (char *)sqlite3_column_text(statement, 3);
                if(lastMessage != NULL) {
                    tempChatRoom.lastMessage = [NSString stringWithUTF8String:lastMessage];
                }
                tempChatRoom.status = sqlite3_column_int(statement,4);
                char *date = (char *)sqlite3_column_text(statement, 5);
                if(date != NULL) {
                    tempChatRoom.date = [NSString stringWithUTF8String:date];
                }
                char *name = (char *)sqlite3_column_text(statement,6);
                if(name != NULL) {
                    tempChatRoom.senderName = [NSString stringWithUTF8String:name];
                }
            }
            sqlite3_finalize(statement);
        }
    }
    */
    sqlite3_close(database);
    return tempChatRoom;
}
- (void)checkAndInsertChatRoom:(NSString *)userId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger roomId = -1;
    char *sql = "SELECT room_id from chatroom_list where sender_id = ? and status = 0 or status = 2";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            roomId = sqlite3_column_int(statement,1);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    if(roomId == -1)
    {
        [self insertChatRoom:userId];
    }
}

- (void)insertChatRoom:(NSString *)senderId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger roomId;
    char *sql = "INSERT INTO chatroom_list (sender_id,count,last_message,status,date,last_chat_id) VALUES(?,0,'',0,'',0)";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [senderId UTF8String], -1, nil);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    roomId = sqlite3_last_insert_rowid(database);
    sqlite3_close(database);
    
    [self makeChatAndTempList:roomId];
}

- (void)updateChatRoom:(ChatRoom *)chatroom
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "update chatroom_list set count = ? , last_message = ?, status = ?, date= ?, last_chat_id = ? where room_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 6, chatroom.roomId);
        sqlite3_bind_int(statement, 1, chatroom.unreadCount);
        sqlite3_bind_text(statement, 2, [chatroom.lastMessage UTF8String], -1, nil);
        sqlite3_bind_int(statement, 3, chatroom.status);
        sqlite3_bind_text(statement,4,[chatroom.date UTF8String], -1, nil);
        sqlite3_bind_int(statement, 5, chatroom.lastChatId);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)deleteChatRoom:(ChatRoom *)chatroom
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "delete from chatroom_list where room_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, chatroom.roomId);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    
    // drop the table (temp_table, room_table)
    sqlite3_close(database);
}

#pragma mark - make(delete) Chat And TempList  db

- (void)makeChatAndTempList:(NSInteger)roomId 
{
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE %@ (local_no INTEGER PRIMARY KEY NOT NULL, contents TEXT, chat_type INTEGER, interlocutor TEXT,date TEXT,time TEXT)",chatTable];
    //char *sql = "CREATE TABLE ? (local_no INTEGER PRIMARY KEY NOT NULL, text TEXT, image TEXT, chat_type INTEGER, sender_id TEXT,date TEXT,time TEXT)"; 
    if(sqlite3_exec(database, [sql1 UTF8String], nil, nil, nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }    
    NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE %@ (no INTEGER PRIMARY KEY NOT NULL, contents TEXT, chat_type INTEGER, interlocutor TEXT, is_fail INTEGER)",tempTable];
    if(sqlite3_exec(database, [sql2 UTF8String], nil, nil, nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }    
    sqlite3_close(database);
}

- (void)deleteChatAndTempList:(NSInteger)roomId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    
    NSString *sql1 = [NSString stringWithFormat:@"DROP TABLE %@ ",chatTable];
    if(sqlite3_exec(database, [sql1 UTF8String], nil, nil, nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }    
    NSString *sql2 = [NSString stringWithFormat:@"DROP TABLE %@",tempTable];
    if(sqlite3_exec(database, [sql2 UTF8String], nil, nil, nil) != SQLITE_OK) {
        sqlite3_close(database);
        return;
    }    
    sqlite3_close(database);
}

#pragma mark - chat
- (NSInteger)getChatCount:(NSInteger)roomId;
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger totalCount=0;
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) FROM %@",chatTable];
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        while(sqlite3_step(statement)==SQLITE_ROW) {
            totalCount = sqlite3_column_int(statement,0);
        }
    }
    return totalCount;
}

- (NSInteger)getNewChatList:(NSMutableArray *)result roomId:(NSInteger)roomId 
                lastLocalNo:(NSInteger)lastLocalNo lastDate:(NSString *)lastDate
{
    [self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger no = 0;
    NSString *firstDate = lastDate;
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"SELECT local_no, chat_type, interlocutor, contents, date,time FROM %@ where local_no > ? order by local_no",chatTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, lastLocalNo);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            Chat *chat = [[Chat alloc] init];
            chat.localNo = sqlite3_column_int(statement, 0);
            no = chat.localNo;
            chat.chatType = sqlite3_column_int(statement, 1);
            char *senderId = (char *)sqlite3_column_text(statement, 2);
            if(senderId != NULL) 
            {
                chat.interlocutor = [NSString stringWithUTF8String:senderId];
            }
            char *text = (char *)sqlite3_column_text(statement, 3);
            if(text != NULL) 
            {
                chat.text = [NSString stringWithUTF8String:text];
            }
            char *date = (char *)sqlite3_column_text(statement,4);
            if(date != NULL) 
            {
                chat.date = [NSString stringWithUTF8String:date];
            }
            char *time = (char *)sqlite3_column_text(statement,5);
            if(time != NULL) 
            {
                chat.time = [NSString stringWithUTF8String:time];
            }
            
            if(![firstDate isEqualToString:chat.date])
            {
                Chat *dateChat = [[Chat alloc] init];
                dateChat.chatType = 3;
                dateChat.text = chat.date;
                [result addObject:dateChat];
                [dateChat release];
            }
            
            [result addObject:chat];
            firstDate = chat.date;
            [chat release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return no;
}

- (NSInteger)getUnloadChatList:(NSMutableArray *)result roomId:(NSInteger)roomId 
                     firstDate:(NSString *)firstDate from:(NSInteger)from
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger no = (from-26 >= 1) ? from-26:1;
    NSString *lastDate = firstDate;
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"SELECT local_no, chat_type, interlocutor, contents, date,time FROM %@ where local_no >= ? and local_no < ? order by local_no desc",chatTable];
    int i=0;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, no);
        sqlite3_bind_int(statement, 2, from);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            Chat *chat = [[Chat alloc] init];
            chat.localNo = sqlite3_column_int(statement, 0);
            chat.chatType = sqlite3_column_int(statement, 1);
            char *senderId = (char *)sqlite3_column_text(statement, 2);
            if(senderId != NULL) 
            {
                chat.interlocutor = [NSString stringWithUTF8String:senderId];
            }
            char *text = (char *)sqlite3_column_text(statement, 3);
            if(text != NULL) 
            {
                chat.text = [NSString stringWithUTF8String:text];
            }
            char *date = (char *)sqlite3_column_text(statement,4);
            if(date != NULL) 
            {
                chat.date = [NSString stringWithUTF8String:date];
            }
            char *time = (char *)sqlite3_column_text(statement,5);
            if(time != NULL) 
            {
                chat.time = [NSString stringWithUTF8String:time];
            }
            
            if(i==0)
            {   
                if([lastDate isEqualToString:chat.date])    
                {
                    // 마지막 날짜와 이번 마지막 데이터의 날짜가 같으므로 날짜를 지운다.
                    [result removeObjectAtIndex:0]; // 처음의 날짜를 지운다
                }
            }
            else 
            {
                if(![lastDate isEqualToString:chat.date])
                {
                    Chat *dateChat = [[Chat alloc] init];
                    dateChat.chatType = 3;
                    dateChat.text = lastDate;
                    [result insertObject:dateChat atIndex:0];
                    [dateChat release];
                }
            }
            
            [result insertObject:chat atIndex:0];
            lastDate = chat.date;
            [chat release];
            i++;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    Chat *dateChat = [[Chat alloc] init];
    dateChat.chatType = 3;
    dateChat.text = lastDate;
    [result insertObject:dateChat atIndex:0];
    [dateChat release];
    
    firstDate = lastDate;
    return no;
}

/* ChatViewController viewdidload 시 호출 됨 */
- (NSInteger)getFirstChatList:result roomId:(NSInteger)roomId lastLocalNo:(NSInteger)lastLocalNo
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSInteger from = (lastLocalNo-24 >= 1) ? lastLocalNo-24:1;
    NSString *lastDate = @"";
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"SELECT local_no, chat_type, interlocutor, contents, date,time FROM %@ where local_no >= ? and local_no <= ? order by local_no asc",chatTable];
    int i=0;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, from);
        sqlite3_bind_int(statement, 2, lastLocalNo);
        while (sqlite3_step(statement)==SQLITE_ROW) {

            Chat *chat = [[Chat alloc] init];
            chat.localNo = sqlite3_column_int(statement, 0);
            chat.chatType = sqlite3_column_int(statement, 1);
            char *senderId = (char *)sqlite3_column_text(statement, 2);
            if(senderId != NULL) 
            {
                chat.interlocutor = [NSString stringWithUTF8String:senderId];
            }
            char *text = (char *)sqlite3_column_text(statement, 3);
            if(text != NULL) 
            {
                chat.text = [NSString stringWithUTF8String:text];
            }
            char *date = (char *)sqlite3_column_text(statement,4);
            if(date != NULL) 
            {
                chat.date = [NSString stringWithUTF8String:date];
            }
            char *time = (char *)sqlite3_column_text(statement,5);
            if(time != NULL) 
            {
                chat.time = [NSString stringWithUTF8String:time];
            }
            
            if(i==0)
            {
                lastDate = chat.date;
                Chat *dateChat = [[Chat alloc] init];
                dateChat.chatType = 3;
                dateChat.text = lastDate;
                //lastDate = chat.date;
                [result addObject:dateChat];
                [dateChat release];
                i++;
            }
            else if(i!=0 && ![lastDate isEqualToString:@""] && ![lastDate isEqualToString:chat.date])
            {
                Chat *dateChat = [[Chat alloc] init];
                dateChat.chatType = 3;
                dateChat.text = chat.date;
                lastDate = chat.date;
                [result addObject:dateChat];
                [dateChat release];
            }
            lastDate = chat.date;
            
            [result addObject:chat];
            [chat release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return from;
}

- (void)insertChat:(Chat *)chat roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (chat_type, interlocutor, contents, date,time) VALUES(?,?,?,?,?)",chatTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, chat.chatType);
        sqlite3_bind_text(statement, 2, [chat.interlocutor UTF8String], -1, nil);
        sqlite3_bind_text(statement, 3, [chat.text UTF8String], -1, nil);
        sqlite3_bind_text(statement, 4, [chat.date UTF8String], -1, nil);
        sqlite3_bind_text(statement, 5, [chat.time UTF8String], -1, nil);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }     
    sqlite3_close(database);
}

- (void)insertChatWithNo:(NSMutableArray *)chat_list roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *chatTable = [NSString stringWithFormat:@"chat_list_%d",roomId];
    for(Chat *chat in chat_list)
    {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (chat_type, interlocutor, contents, date,time , local_no) VALUES(?,?,?,?,?,?)",chatTable];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
        {
            sqlite3_bind_int(statement, 1, chat.chatType);
            sqlite3_bind_text(statement, 2, [chat.interlocutor UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [chat.text UTF8String], -1, nil);
            sqlite3_bind_text(statement, 4, [chat.date UTF8String], -1, nil);
            sqlite3_bind_text(statement, 5, [chat.time UTF8String], -1, nil);
            sqlite3_bind_int(statement, 6, chat.localNo);
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        } 
    }
    sqlite3_close(database);
}


- (void)getTempChatList:(NSMutableArray *)result roomId:(NSInteger)roomId 
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *chatTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"SELECT no, chat_type, interlocutor, contents, is_fail FROM %@ order by no asc",chatTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) 
        == SQLITE_OK) 
    {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            TempChat *tempChat = [[TempChat alloc] init];
            tempChat.no = sqlite3_column_int(statement, 0);
            tempChat.chatType = sqlite3_column_int(statement, 1);
            char *senderId = (char *)sqlite3_column_text(statement, 2);
            if(senderId != NULL) 
            {
                tempChat.interlocutor = [NSString stringWithUTF8String:senderId];
            }
            char *text = (char *)sqlite3_column_text(statement, 3);
            if(text != NULL) 
            {
                tempChat.text = [NSString stringWithUTF8String:text];
            }
            
            tempChat.isFail = sqlite3_column_int(statement,4);
            
            [result addObject:tempChat];
            [tempChat release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}


- (void)insertTempChat:(TempChat *)tempChat roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (chat_type, interlocutor, contents, is_fail) VALUES(?,?,?,?)",tempTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, tempChat.chatType);
        sqlite3_bind_text(statement, 2, [tempChat.interlocutor UTF8String], -1, nil);
        sqlite3_bind_text(statement, 3, [tempChat.text UTF8String], -1, nil);
        sqlite3_bind_int(statement, 4, tempChat.isFail);
        if (sqlite3_step(statement) != SQLITE_DONE) {

        }
        sqlite3_finalize(statement);
    }     
    tempChat.no = sqlite3_last_insert_rowid(database);
    sqlite3_close(database);
}
- (void)setFailTempChatWithNo:(NSInteger)no roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"update %@ set is_fail = 1 WHERE no = ?",tempTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, no);
        if (sqlite3_step(statement) != SQLITE_DONE) {

        }
        sqlite3_finalize(statement);
    }     
    sqlite3_close(database); 
}
-(void)setResendTempChatWithNo:(NSInteger)no roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"update %@ set is_fail = 0 WHERE no = ?",tempTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, no);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }     
    sqlite3_close(database); 
}
- (void)updateTempChat:(TempChat *)tempChat roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"update %@ set is_fail = ? WHERE no = ?",tempTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, tempChat.isFail);
        sqlite3_bind_int(statement, 2, tempChat.no);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }     
    sqlite3_close(database);
}

- (void)deleteTempChat:(NSInteger)no roomId:(NSInteger)roomId
{
    //[self makeChatAndTempList:roomId];
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    NSString *tempTable = [NSString stringWithFormat:@"temp_list_%d",roomId];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ WHERE no = ?",tempTable];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) 
    {
        sqlite3_bind_int(statement, 1, no);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }     
    sqlite3_close(database);
}


#pragma mark - message 
- (void)insertMessages:(NSArray *)messageList
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [messageList count] ; i++) 
    {
        Message *message = [messageList objectAtIndex:i];
        char *sql = "INSERT INTO message_list (sender_id,receiver_id,date,text,is_read) VALUES(?,?,?,?,?)";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [message.senderId UTF8String], -1, nil);
            sqlite3_bind_text(statement, 2, [message.receiverId UTF8String], -1, nil);
            sqlite3_bind_text(statement, 3, [message.date UTF8String],-1,nil);
            sqlite3_bind_text(statement, 4, [message.text UTF8String], -1, nil);
            sqlite3_bind_int(statement, 5, message.isRead);
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        } 
    }
    sqlite3_close(database);
}
- (void)getMessageList:(NSMutableArray *)result from:(NSInteger)from count:(NSInteger)count;
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT message_list.no, message_list.sender_id, message_list.receiver_id, message_list.date, message_list.is_read, message_list.text, user_list.name FROM message_list, user_list where (message_list.sender_id = user_list.user_id or message_list.receiver_id = user_list.user_id) and message_list.no > ? order by message_list.no limit ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, from);
        sqlite3_bind_int(statement, 2, count);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            Message *message = [[Message alloc] init];
            message.no = sqlite3_column_int(statement,0);
            char *senderId = (char *)sqlite3_column_text(statement, 1);
            if(senderId != NULL) {
                message.senderId = [NSString stringWithUTF8String:senderId];
            }
            
            char *receiverId = (char *)sqlite3_column_text(statement,2);
            if(receiverId != NULL) {
                message.receiverId = [NSString stringWithUTF8String:receiverId];
            }
            char *date = (char *)sqlite3_column_text(statement, 3);
            if(date != NULL) {
                message.date = [NSString stringWithUTF8String:date];
            }
            message.isRead = sqlite3_column_int(statement,4);
            char *text = (char *)sqlite3_column_text(statement, 5);
            if(text != NULL) {
                message.text = [NSString stringWithUTF8String:text];
            }
            
            char *name = (char *)sqlite3_column_text(statement, 6);
            if(name != NULL) {
                message.name = [NSString stringWithUTF8String:name];
            }
            
            [result addObject:message];
            [message release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
}

- (void)getMessageList:(NSMutableArray *)result
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT no, sender_id, receiver_id, date, is_read, text FROM message_list order by no desc";
    //char *sql = "SELECT message_list.no, message_list.sender_id, message_list.receiver_id, message_list.date, message_list.is_read, message_list.text, user_list.name FROM message_list, user_list where message_list.sender_id = user_list.user_id or message_list.receiver_id = user_list.user_id order by message_list.no desc";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            Message *message = [[Message alloc] init];
            message.no = sqlite3_column_int(statement,0);
            char *senderId = (char *)sqlite3_column_text(statement, 1);
            if(senderId != NULL) {
                message.senderId = [NSString stringWithUTF8String:senderId];
            }
            
            char *receiverId = (char *)sqlite3_column_text(statement,2);
            if(receiverId != NULL) {
                message.receiverId = [NSString stringWithUTF8String:receiverId];
            }
            char *date = (char *)sqlite3_column_text(statement, 3);
            if(date != NULL) {
                message.date = [NSString stringWithUTF8String:date];
            }
            message.isRead = sqlite3_column_int(statement,4);
            char *text = (char *)sqlite3_column_text(statement, 5);
            if(text != NULL) {
                message.text = [NSString stringWithUTF8String:text];
            }
            
            if([message.senderId isEqualToString:[userDefaults objectForKey:kUserIdKey]])
            {
                message.name = [self getUserName:message.receiverId];
            }
            else
            {
                message.name = [self getUserName:message.senderId];
            }
            
            [result addObject:message];
            [message release];
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
}
- (void)setMessagesRead:(NSMutableArray *)noList
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    for(int i=0; i < [noList count] ; i++) {
        NSNumber *no = (NSNumber *)[noList objectAtIndex:i];
        char *sql = "UPDATE message_list set is_read = 1 WHERE no = ?";
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [no intValue]);
            if (sqlite3_step(statement) != SQLITE_DONE) {
            }
            sqlite3_finalize(statement);
        }
    }
    sqlite3_close(database);
    [noList removeAllObjects];
}

- (void)deleteMessage:(NSInteger)no
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "delete from message_list where no = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, no);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

- (void)deleteMessageByUserId:(NSString *)userId
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "delete from message_list where sender_id = ? or receiver_id = ?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [userId UTF8String], -1, nil);
        sqlite3_bind_text(statement, 2, [userId UTF8String], -1, nil);
        if (sqlite3_step(statement) != SQLITE_DONE) {
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (NSInteger)getMessagesCount
{
    NSInteger count = 0;
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "SELECT seq from sqlite_sequence where name = 'message_list'";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            count = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return count;
}
- (void)updateMessagesCount:(int)count
{
    sqlite3 *database = [self getDatabase:[userDefaults objectForKey:kDBFileNameKey]];
    sqlite3_stmt *statement;
    char *sql = "INSERT INTO sqlite_sequence (seq, name) VALUES (?, 'message_list')";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, count);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);    
}

-(void)checkLogin
{
    if([userDefaults objectForKey:kUserIdKey]!=nil || [userDefaults objectForKey:kUserIdKey]!=@"")
    {
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@CheckLogin?account=%@&session=%@",kMeepleUrl,[userDefaults objectForKey:kUserIdKey],[userDefaults objectForKey:kSessionIdKey]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setCompletionBlock:^{
            NSString *response = [request responseString];
            NSInteger status = [request responseStatusCode];
            if(status == 200)
            {
                if(![response boolValue])
                {
                    id appDelegate = [[UIApplication sharedApplication] delegate];
                    UINavigationController *navigationController = (UINavigationController *)[[appDelegate tabBarController] selectedViewController];
                    if([self.window.rootViewController isKindOfClass:[LoginViewController class]])
                    {
                        
                    }
                    else
                    {
                        
                        UIViewController *viewController = [navigationController visibleViewController];
                        if([viewController isKindOfClass:[ChatViewController_ class]])
                        {
                            [navigationController popViewControllerAnimated:NO];
                            
                        }
                        [[appDelegate tabBarController] setSelectedIndex:0];
                        LoginViewController *loginView = [[[LoginViewController alloc] init] autorelease];
                        UINavigationController *loginViewNav = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
                        loginViewNav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                        [self.window.rootViewController presentModalViewController:loginViewNav animated:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"세션 종료!"
                                                                        message:@"다시 로그인해주세요 ^^;!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"확인!" 
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        
                    }
                }
            }
            
        }];
        [request setFailedBlock:^{
        
        }];
        [request startAsynchronous];
    }
}
@end
