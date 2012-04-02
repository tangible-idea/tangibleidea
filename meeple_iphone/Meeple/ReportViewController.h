//
//  ReportViewController.h
//  Meeple
//
//  Created by Sung Yeol Bae on 11. 9. 29..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController <UITextViewDelegate>
{
    UITextField *userIdField;
    UITextView *reasonView;
    UIImageView *userIdFieldBg;
    UIImageView *reasonViewBg;
    UIView *contentsView;
    CGFloat animatedDistance;
}

@property (nonatomic, retain) IBOutlet UIView *contentsView;
@property (nonatomic, retain) IBOutlet UITextField *userIdField;
@property (nonatomic, retain) IBOutlet UITextView *reasonView;
@property (nonatomic, retain) IBOutlet UIImageView *userIdFieldBg;
@property (nonatomic, retain) IBOutlet UIImageView *reasonViewBg;


- (IBAction)textFieldDone:(id)sender;
- (IBAction)backgroundTap;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
@end
