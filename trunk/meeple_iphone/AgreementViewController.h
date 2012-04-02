//
//  AgreementViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UIViewController
{
    NSInteger mType;
	NSString *auth_id;
	NSString *auth_univ;
    UITextView *agreementTextView;
	UIButton *agreeButton;
	UIButton *disagreeButton;
}

@property (nonatomic, retain) IBOutlet UITextView *agreementTextView; 
@property (nonatomic, retain) IBOutlet UIButton *agreeButton;
@property (nonatomic, retain) IBOutlet UIButton *disagreeButton;
@property (nonatomic, assign) NSInteger mType;
@property (nonatomic, copy) NSString *auth_id;
@property (nonatomic, copy) NSString *auth_univ;

-(IBAction)agreeButtonPressed:(id)sender;
-(IBAction)disagreeButtonPressed:(id)sender;

@end
