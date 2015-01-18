//
//  SettingsViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "SettingsDelegate.h"
#import "SpecialTextField.h"
#import <CoreLocation/CoreLocation.h>
#import "toggleButtons.h"
@interface SettingsViewController : UIViewController<toggleButtonDelegate>{
    id<SettingsDelegate>delegate;
    
}
@property (strong, nonatomic) IBOutlet UISwitch *exactLocationSwitch;
@property (strong, nonatomic) IBOutlet UIView *distanceHolder;
@property (strong, nonatomic) IBOutlet UIView *toggleB;
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UILabel *mpcountLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)changeUsernamePressed:(id)sender;
- (IBAction)changePhoneButtonPressed:(id)sender;
- (IBAction)changePasscodePressed:(id)sender;
- (IBAction)addUserPressed:(id)sender;
- (IBAction)blockUserPressed:(id)sender;
- (IBAction)termsButtonPressed:(id)sender;
- (IBAction)feedbackButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *locationButton;
@property (strong, nonatomic) IBOutlet UISwitch *pushSwitch;
- (IBAction)loutPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *locationOverlay;
@property (strong, nonatomic) IBOutlet UIView *pushSwitchCover;
@property (strong, nonatomic) IBOutlet UIButton *changePButton;
@property (strong, nonatomic) IBOutlet UIButton *changePassCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) IBOutlet UIButton *feedbackButton;
@property (strong, nonatomic) IBOutlet UIView *holderOfSwitches;
@property (strong, nonatomic) IBOutlet UISwitch *searchableSwitch;
@property (strong, nonatomic) IBOutlet UIButton *eiButton;
@property (strong, nonatomic) IBOutlet UIButton *statsButton;
@property (strong, nonatomic) IBOutlet UIButton *cuButton;
@property (strong, nonatomic) IBOutlet UIButton *rateB;
- (IBAction)statsButtonPressed:(id)sender;
- (IBAction)eiPressed:(id)sender;
- (IBAction)rateBPressed:(id)sender;
- (IBAction)aboutBPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cUButtomn;
-(void)setMarcoPoloCount:(NSInteger)polos : (NSInteger)marcosCount;

@end
