//
//  SignupViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupDelegate.h"
#import "SpecialTextField.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <KVNProgress/KVNProgress.h> 
@interface SignupViewController : UIViewController{
    id<SignupDelegate>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet SpecialTextField *username;
@property (strong, nonatomic) IBOutlet SpecialTextField *phonenumber;
@property (strong, nonatomic) IBOutlet SpecialTextField *passcode;
@property (strong, nonatomic) IBOutlet UIView *middleHolder;
- (IBAction)signupButtonPressed:(id)sender;

@end
