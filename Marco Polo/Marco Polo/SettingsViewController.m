//
//  SettingsViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "SettingsViewController.h"
#import "ECPhoneNumberFormatter.h"
#import "ChangePreferencesManager.h"
#import "PhoneVerificationController.h"
#import "MBProgressHud.h"
#import "ChangePasscodeViewController.h"
#import "ChangeUsernameViewController.h"
#import "ChangePhoneViewController.h"
@interface SettingsViewController (){
    BOOL pickerIsOut;
    NSArray *specialTextFields;
    PhoneVerificationController *controller;
    toggleButtons *toggleButton;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    [self.locationButton addTarget:self
                              action:@selector(locationButtonTapped)
                    forControlEvents:UIControlEventValueChanged];
    
    [self.pushSwitch addTarget:self
                            action:@selector(preferencesWereChanged)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.exactLocationSwitch addTarget:self
                        action:@selector(preferencesWereChanged)
              forControlEvents:UIControlEventValueChanged];
    

    
   
    
    toggleButton = [[toggleButtons alloc]initWithFrame:self.toggleB.bounds];
    toggleButton.delegate = self;
    [self.toggleB addSubview:toggleButton];
    
    

  

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    NSString *searchable = [defaults objectForKey:@"searchable"];
    
    
        //gets the unit and last location stuff
    
    NSString *unit = [defaults objectForKey:@"unit"];
    NSString *exact_location = [defaults objectForKey:@"exact_location"];
    BOOL exact_location_on = [exact_location boolValue];
    
    [self.exactLocationSwitch setOn:exact_location_on];
    [toggleButton toggleMyButton:[unit intValue]];
    
    
    
    BOOL canBeSearched = [searchable boolValue];
    [self.searchableSwitch setOn:canBeSearched];
    
    [self.searchableSwitch addTarget:self
                        action:@selector(preferencesWereChanged)
              forControlEvents:UIControlEventValueChanged];

 
    NSString *push_is_on = [defaults objectForKey:@"push_notification"];
    
    [self.pushSwitch setOn:[push_is_on boolValue]];
    
    ///determines if one of the text fields are out so we cant open another
    pickerIsOut = NO;
    
    
    [self.locationButton setOn:[self checkforLocation]];
    //[self.locationButton setEnabled:NO];
    [self.locationButton setUserInteractionEnabled:NO];
    [self.locationOverlay setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    letterTapRecognizer.delegate = self;
    [self.locationOverlay addGestureRecognizer:letterTapRecognizer];

    //fixes the switch holder
    
    
    CGRect rect = self.holderOfSwitches.frame;
    rect.origin.y = self.view.frame.size.height - self.holderOfSwitches.frame.size.height;

    [self.holderOfSwitches setFrame:CGRectMake(0, self.distanceHolder.frame.origin.y + self.distanceHolder.frame.size.height, self.view.frame.size.width, self.holderOfSwitches.frame.size.height)];
    
    NSArray *buttons = [[NSArray alloc]init];
    buttons = @[self.eiButton,self.statsButton,self.cuButton,self.rateB];
    NSArray *bgImages = [[NSArray alloc]init];
    bgImages = @[[UIColor colorWithRed:0.188 green:0.678 blue:0.378 alpha:1] /*#30ad63*/,[UIColor colorWithRed:0.688 green:0.678 blue:0.808 alpha:1] /*#30ad68*/,[UIColor colorWithRed:0.188 green:0.678 blue:0.378 alpha:1],[UIColor colorWithRed:0.188 green:0.678 blue:0.378 alpha:1] /*#30ad63*/,[UIColor colorWithRed:0.588 green:0.678 blue:0.408 alpha:1]];
    int i = 0;
    for(UIButton *b in buttons)
    {
     //   [b setBackgroundImage:[self imageWithColor:[bgImages objectAtIndex:i]] forState:UIControlStateHighlighted];
        i++;
    }
    
    
    //a view that covers the push notificaiton button switch
    [self.pushSwitchCover setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *pushSwitchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSwitchWasTapped)];
    pushSwitchTap.numberOfTapsRequired = 1;
    pushSwitchTap.delegate = self;
    [self.locationOverlay addGestureRecognizer:pushSwitchTap];
    
    
    
    
    //sees if we have push notifications available if we do it turns switch on other wise it is off
    
[self.pushSwitch setUserInteractionEnabled:NO];
UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkIfNotifications];
    [self checkforLocation];
}


-(void)checkIfNotifications
{
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
    
    NSUInteger rntypes;
    if (!SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        rntypes = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    }else{
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
    
    
    if (rntypes == UIRemoteNotificationTypeNone)
    {
        [self.pushSwitch setOn:NO];
    }
    else
    {
        [self.pushSwitch setOn:YES];
    }
}


- (void)registerForKeyboardNotifications
{
    //ends editing on the tap screen
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)rateButtonPressed:(id)sender
{

}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)feedbackButtonPressed:(id)sender
{

        NSArray *to = [[NSArray alloc]init];
        to = @[@"contact@MarcoPolo"];
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:to];
        [controller setSubject:@"Hey Marco Polo!"];
        [controller setMessageBody:@"Dear MarcoPolo, " isHTML:NO];
        if (controller) [self presentModalViewController:controller animated:YES]; 

}
 
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)loutPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are about to log out"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            [self dismissViewControllerAnimated:YES completion:^{
                  [self.delegate UserDoesWantToLogOut];
            }];
          
    }
}


-(void)locationButtonTapped
{
    
}

//changes push notifications settings
-(void)preferencesWereChanged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    

    
    
    int push_is_on = [[NSNumber numberWithBool:self.pushSwitch.isOn]intValue];
    int search_is_on = [[NSNumber numberWithBool:self.searchableSwitch.isOn]intValue];
    int exact_l = [[NSNumber numberWithBool:self.exactLocationSwitch.isOn]intValue];
    int unit = toggleButton.currentSelected;
    
    
    [defaults setObject:[NSString stringWithFormat:@"%d",push_is_on] forKey:@"push_notification"];
     [defaults setObject:[NSString stringWithFormat:@"%d",search_is_on] forKey:@"searchable"];
       [defaults setObject:[NSString stringWithFormat:@"%d",exact_l] forKey:@"exact_location"];
       [defaults setObject:[NSString stringWithFormat:@"%d",unit] forKey:@"unit"];
    [defaults synchronize];
    NSDictionary *params = @{
                             @"push_notification":[NSString stringWithFormat:@"%d",push_is_on],
                             @"search":[NSString stringWithFormat:@"%d",search_is_on],
                             @"exact_location":[NSString stringWithFormat:@"%d",exact_l],
                             @"unit":[NSString stringWithFormat:@"%d",unit],
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             };
    
    
    
    
    ChangePreferencesManager *man = [[ChangePreferencesManager alloc]init];
    [man changePreferences:params];
}






-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Marco Polo"
                          message: message
                          delegate: nil
                          cancelButtonTitle: @"Okay"
                          otherButtonTitles:nil];
    [alert show];
}



//checks if my geolocation is off
-(BOOL)checkforLocation
{
   //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      bool ison = [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    
    
    
    if(!ison)
    {
        return NO;
    }
    
    
    return YES;
    
}


//if the location is not on then we tell the user to enable it
-(void)locationTapped
{
    
    if(!self.locationButton.isOn)
    {
        [self showAlert:@"Please Go to Settings > Location and Enable Geolocation"];
    }
    
}

//if the push switch is off we tell the user to enable
-(void)pushSwitchWasTapped
{
    if(!self.pushSwitch.isOn)
    {
        [self showAlert:@"Please Go to Settings > Push Notifications and Enable Push Notifications"];
    }
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//sets the marcopolo count in the label
-(void)setMarcoPoloCount:(NSInteger)polos :(NSInteger)marcosCount;
{
    NSString *labelText = [NSString stringWithFormat:@"%ldM : %ldP",(long)marcosCount,(long)polos];
    [self.mpcountLabel setText:labelText];
}


//toggle button delegate
-(void)tabWasChanged:(NSInteger)index
{
    [self preferencesWereChanged];
    NSLog(@"awesome");
    
}


- (IBAction)statsButtonPressed:(id)sender {
}

- (IBAction)eiPressed:(id)sender {
    //nothing using segue
}

- (IBAction)rateBPressed:(id)sender {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/push-press-until-something/id913315888?ls=1&mt=8"]];
}

- (IBAction)aboutBPressed:(id)sender {

}
@end
