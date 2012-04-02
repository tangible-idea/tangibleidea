//
//  JoinViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinViewController : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource,MBProgressHUDDelegate > {
	NSInteger mType;  // mento or mentee
	NSString *authId; // authentication id : if mentee then nil;
	NSString *univName; // university name : if mentee then nil;
	NSUInteger schoolNum;
	
	UITextField *idField;
	UITextField *pwField;
	UITextField *nameField;
	UITextField *emailField;
	UITextField *schoolField;
	UITextField *majorField;
    UITextField *gradeField;
	UITextField *sexField;
    MBProgressHUD *activityIndicator;
    
	UILabel *schoolLabel;
	UILabel *majorLabel;
	UILabel *gradeLabel;
    
	CGFloat animatedDistance; // for animation
	
	UIButton *joinButton;
    NSArray *sexArray;
}

@property (nonatomic, assign) NSInteger mType;
@property (copy, nonatomic) NSString *authId;
@property (copy, nonatomic) NSString *univName;
@property (assign,nonatomic) NSUInteger schoolNum;
@property (retain, nonatomic) MBProgressHUD *activityIndicator;

@property (retain, nonatomic) IBOutlet UITextField *sexField;
@property (retain, nonatomic) IBOutlet UITextField *idField;
@property (retain, nonatomic) IBOutlet UITextField *pwField;
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *emailField;
@property (retain, nonatomic) IBOutlet UITextField *schoolField;
@property (retain, nonatomic) IBOutlet UITextField *majorField;
@property (retain, nonatomic) IBOutlet UITextField *gradeField;
@property (retain, nonatomic) NSArray *sexArray;

@property (retain, nonatomic) IBOutlet UILabel *schoolLabel;
@property (retain, nonatomic) IBOutlet UILabel *majorLabel;
@property (retain, nonatomic) IBOutlet UILabel *gradeLabel;

@property (retain, nonatomic) IBOutlet UIButton *joinButton;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldEditingStart:(UITextField *)textField;
- (IBAction)textFieldEditingOver:(UITextField *)textField;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)joinButtonPressed:(id)sender;

- (NSString*) md5:(NSString*)srcStr;

@end
