//
//  User.m
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "ASIDownloadCache.h"

@implementation User
@synthesize type,userId,name,school,grade,major,imageURL,talk,flag,updateDate,isFirst;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc 
{
    self.userId = nil;
    self.school = nil;
    self.name = nil;
    self.imageURL = nil;
    self.talk = nil;
    self.major = nil;
    self.updateDate = nil;
    [super dealloc];    
}

@end
