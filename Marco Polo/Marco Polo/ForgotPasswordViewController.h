//
//  ForgotPasswordViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/7/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialTextField.h"
@interface ForgotPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIButton *resetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *resetPasswordButtonPressed;
- (IBAction)rpWasPressed:(id)sender;
- (IBAction)backButtonWasPressed:(id)sender;
@property (strong, nonatomic) IBOutlet SpecialTextField *usernameField;
@property (strong, nonatomic) IBOutlet SpecialTextField *phoneField;

@end
