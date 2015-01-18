//
//  EditInfoViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "EditInfoViewController.h"
#import "ChangePhoneViewController.h"
#import "ChangeUsernameViewController.h"
#import "ChangePasscodeViewController.h"
@interface EditInfoViewController ()

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeUsernamePressed:(id)sender
{

}
- (IBAction)changePhoneButtonPressed:(id)sender
{

    
}


//change passcode delegate
-(void)passcodeWasChanged
{
    [self toastMessage:@"Passcode Changed!"];
}
//end change passcode delegate


//start change username delegate

-(void)userNameHasChanged
{
    [self toastMessage:@"Username Changed!"];
}
//end change username delegate

//start change phone delegate

-(void)phoneHasChanged
{
    [self toastMessage:@"Phone # Changed!"];
}
//end change phone delegate

//toasts a message
-(void)toastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    //   hud.l = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] /*#e74c3c*/;
    hud.labelColor = [UIColor whiteColor];
    hud.color = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] /*#e74c3c*/;
    [hud hide:YES afterDelay:1];
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cuPressed:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    ChangeUsernameViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"changeuser"];
    c.delegate = self;
    [self presentViewController:c animated:YES completion:nil];
}

- (IBAction)cpPressed:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    ChangePhoneViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"changephone"];
    c.delegate = self;
    [self presentViewController:c animated:YES completion:nil];
}

- (IBAction)changePasspress:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    ChangePasscodeViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"changepass"];
    c.delegate = self;
    [self presentViewController:c animated:YES completion:nil];
}
@end
