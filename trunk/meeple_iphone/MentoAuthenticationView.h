//
//  MentoAuthenticationView.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentoAuthenticationView : UIViewController < UIPickerViewDelegate, UIPickerViewDataSource, MBProgressHUDDelegate > {
	UITextField *univField;
	UITextField *auth_idField;
	UITextField *auth_pwField;
	CGFloat animatedDistance;
	UIButton *authDone;
	NSArray *univData;
	NSMutableData *receivedData;
    MBProgressHUD *activityIndicator;
    NSUInteger schoolnum;
}

@property (nonatomic, retain) IBOutlet UITextField *univField;
@property (nonatomic, retain) IBOutlet UITextField *auth_idField;
@property (nonatomic, retain) IBOutlet UITextField *auth_pwField;
@property (nonatomic, retain) IBOutlet UIButton *authDone;
@property (nonatomic, retain) NSArray *univData;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) MBProgressHUD *activityIndicator;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldEditingStart:(id)sender;
- (IBAction)textFieldEditingOver:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)authDonePressed:(id)sender;

@end
