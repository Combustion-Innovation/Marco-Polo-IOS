//
//  ChangePhoneViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>
#import <UIKit/UIKit.h>
#import "SpecialTextField.h"
#import "ChangePhoneProtocol.h"

@interface ChangePhoneViewController : UIViewController{
    id<ChangePhoneProtocol>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *changePhoneButton;
- (IBAction)changePhonePressed:(id)sender;

@property (strong, nonatomic) IBOutlet SpecialTextField *changePhoneNumber;
- (IBAction)backPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *middleView;

@end
