//
//  LandingScreenViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "AddUserViewController.h"
#import <UIKit/UIKit.h>
#import "LandingScreenDeleate.h"
#import "SettingsViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "ExpanableButton.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomControl.h"
#import "resortHeaders.h"
@interface LandingScreenViewController : UIViewController{
    id<LandingScreenDeleate>delegate;
    
}
@property (strong, nonatomic) IBOutlet ExpanableButton *addButton;

@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableVIew;

- (IBAction)settingsButtonWasPressed:(id)sender;

- (IBAction)addPeopleButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet ExpanableButton *settingsButton;
@property(strong,nonatomic)CustomControl *refresh;
@end
