//
//  PhoneVerificationController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PhoneVerificationController.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "ECPhoneNumberFormatter.h"

@interface PhoneVerificationController (){
    
}

@end

@implementation PhoneVerificationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //makes the background clear
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //holder view holds all the views to verify the code.
    [self.holderView setClipsToBounds:YES];
    [self.holderView.layer setCornerRadius:5.0f];
    //centers the holder view.
    [self.holderView setFrame:CGRectMake(self.view.frame.size.width/2 - (self.holderView.frame.size.width/2), self.holderView.frame.origin.y, self.holderView.frame.size.width, self.holderView.frame.size.height)];
    
    
    
    self.codeInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER CODE" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    //this is the code input view.
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.codeInput.layer.cornerRadius = 4.0;
    self.codeInput.tag = 0;
    [self.codeInput setBorderStyle:UITextBorderStyleNone];
    self.codeInput.layer.borderWidth = 1.0;
    self.codeInput.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeInput.layer.masksToBounds = YES;
    [self.codeInput setLeftViewMode:UITextFieldViewModeAlways];
    [self.codeInput setLeftView:spacerView];
    self.codeInput.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.codeInput.delegate = self;
    //end code input view
    
    
    //this allows us to dismisskeyboard when we tap the view.
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
    //end tap gesture recognizer delegate
    
    //sets a semi transparent black background
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45] /*#000000*/];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didLongPress
{
    [self.view endEditing:YES];
}

//shows the view and the holder view animated
-(void)showVerificationAlert
{
    [self.view setHidden:NO];
    self.holderView.transform = CGAffineTransformMakeScale(0.51,0.51);
    [UIView animateWithDuration:0.21
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.holderView.transform = CGAffineTransformIdentity;
                     }completion:^(BOOL finished) {
                         
                         
                     }];
}
//hides the verification view and the holderview animated.
-(void)hideVerificationAlert
{
     [self.view endEditing:YES];
      self.holderView.transform = CGAffineTransformIdentity;
       [UIView animateWithDuration:0.31
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.holderView.transform = CGAffineTransformMakeScale(0.10,0.10);
                     }completion:^(BOOL finished) {
                         [self.view setHidden:YES];
                         [self.codeInput setText:@""];
                     }];

}


//resend button is pressed so we tell the delegate to resend the code
- (IBAction)resendButtonPressed:(id)sender
{
    [self reSendCode];
}

///cancel button was pressed
- (IBAction)cancelVerificationPressed:(id)sender
{
    [self hideVerificationAlert];
}

//now we try to verify that the code is correct
- (IBAction)okVerificationButtonPressed:(id)sender
{
    [self.delegate tryToVerify:self.codeInput.text:self.signupDictionary];
}

//tells the gesture recognizer which views to ignore.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
}


//we need to resend the verification code
-(void)reSendCode;
{
    [self.delegate resendCodeButtonPressed:self.signupDictionary];
}


//the code has been resent and the delegate has told us that it has been sent so we alert the user.
-(void)codeResent
{
    [self showAlert:@"Verification Code re-sent!"];
}


//shows the progress hud
-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.83f];
    [KVNProgress appearance].circleSize = 55.0f;
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  
    [KVNProgress showWithParameters:
     @{KVNProgressViewParameterFullScreen: @(YES),
       KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
       KVNProgressViewParameterStatus: @"",
       KVNProgressViewParameterSuperview: self.view
       }];
    
}


//hides the progress hud
-(void)hideHud
{
    [KVNProgress dismiss];
    
}

//the code was wrong so we tell them
-(void)codeWasWrong
{
    [self hideHud];
    [self showAlert:@"Verification code was Incorrect"];
   
}

//should the textfield return
- (IBAction)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate tryToVerify:self.codeInput.text:self.signupDictionary];
    [self.view endEditing:YES];
}

//shows the alert
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


@end
