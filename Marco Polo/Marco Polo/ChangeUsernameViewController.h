//
//  ChangeUsernameViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialTextField.h"
#import "ChangeUsernameDelegate.h"

@interface ChangeUsernameViewController : UIViewController{
    id<ChangeUsernameDelegate>delegate;
    
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet SpecialTextField *username;

@property (strong, nonatomic) IBOutlet UIView *middleView;


@property (strong, nonatomic) IBOutlet UIButton *changeusernamebutton;
- (IBAction)backButtonWasPressed:(id)sender;
- (IBAction)changeUsernamePressed:(id)sender;

- (IBAction)changeUsernamebuttonPressed:(id)sender;
@end
