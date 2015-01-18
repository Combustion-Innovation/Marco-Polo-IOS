//
//  LoginViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
#import <KVNProgress/KVNProgress.h> 
#import <UIKit/UIKit.h>
#import "loginDelegate.h"
#import "SpecialTextField.h"
@interface LoginViewController : UIViewController{
    id<loginDelegate>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet SpecialTextField *username;
@property (strong, nonatomic) IBOutlet SpecialTextField *password;
@property (strong, nonatomic) IBOutlet UIView *middleHolder;
- (IBAction)loginButtonWasPressed:(id)sender;

@end
