//
//  LoginViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <MBProgressHUDDelegate> {
	UITextField *idField;
	UITextField *pwField;
    
	UIButton *loginButton;
	UIButton *joinMento;
	UIButton *joinMentee;
	
	CGFloat animatedDistance; 
    
    MBProgressHUD *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UITextField *idField;
@property (nonatomic, retain) IBOutlet UITextField *pwField;

@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UIButton *joinMento;
@property (nonatomic, retain) IBOutlet UIButton *joinMentee;

- (IBAction)loginDone:(id)sender;
- (IBAction)joinMentoDone:(id)sender;
- (IBAction)joinMenteeDone:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldEditingStart:(id)sender;
- (IBAction)textFieldEditingOver:(id)sender;
- (IBAction)backgroundTap:(id)sender;
-(NSString*) md5:(NSString*)srcStr;

@end
