//
//  ChangePasscodeViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>
#import <UIKit/UIKit.h>
#import "SpecialTextField.h"
#import "ChangePasscodeDelegate.h"
@interface ChangePasscodeViewController : UIViewController{
    id<ChangePasscodeDelegate>delegate;
    
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet SpecialTextField *oldPassCode;
@property (strong, nonatomic) IBOutlet SpecialTextField *nPassCode;
@property (strong, nonatomic) IBOutlet SpecialTextField *cPassCOde;
@property (strong, nonatomic) IBOutlet SpecialTextField *cPassCode;
@property (strong, nonatomic) IBOutlet UIButton *changePasscodeButton;
- (IBAction)changePassWasPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *middleView;
- (IBAction)backWasPressed:(id)sender;

@end
