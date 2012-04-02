//
//  User.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 21..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSInteger type; // mento or mentee
    NSInteger grade;
    NSInteger flag;
    
    NSString *userId; // id 
    NSString *name; // name
    NSString *school; // school
    NSString *major; // 전공
    
    NSString *talk; 
    NSString *imageURL;
    NSString *updateDate;
    
    NSInteger isFirst;
}

@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger grade;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *talk;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, assign) NSInteger isFirst;
@end
