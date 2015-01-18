//
//  SignupViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "SignupViewController.h"
#import "PhoneVerificationController.h"
#import "ECPhoneNumberFormatter.h"
@interface SignupViewController (){
    NSArray *tf;
    NSArray *placeholders;
    CGRect origninalMiddleFrame;
    PhoneVerificationController *controller;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupStuff];
    [self registerForKeyboardNotifications];
    
    origninalMiddleFrame = self.middleHolder.frame;
    
    controller = nil;
    
    
    
    
    UIStoryboard *storyBoard = [self storyboard];
    controller = [storyBoard instantiateViewControllerWithIdentifier:@"pvc"];
    [controller.view setHidden:YES];
    [self.view addSubview:controller.view];
    controller.delegate = self;
    controller.type = 0;
    [controller didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupStuff
{
    placeholders = [[NSArray alloc]init];
    placeholders = @[@"Username",@"Phone #",@"Passcode"];
    
    tf = [[NSArray alloc]init];
    tf = @[self.username,self.phonenumber,self.passcode];
    int i = 0;
    for(SpecialTextField *t in tf)
    {
        [t setFields];
        t.tag = i;
        [t setWhitePlaceholder:[placeholders objectAtIndex:i] :[UIColor whiteColor]];
        [t setTextAlignment:NSTextAlignmentCenter];
        [t setDelegate:self];
        t.originalPlaceholder = [placeholders objectAtIndex:i];
        [t setTintColor:[UIColor whiteColor]];
        [t setRestorationIdentifier:[placeholders objectAtIndex:i]];
   
        i++;
        
    }
    
    
}

//keyboard notifications
- (void)registerForKeyboardNotifications
{
    //ends editing on the tap screen
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    
    
    [self.phonenumber addTarget:self
                         action:@selector(phoneChanged)
               forControlEvents:UIControlEventEditingChanged];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (IBAction)backButtonPressed:(id)sender
{
      [self.view endEditing:YES];
      [self.navigationController popViewControllerAnimated:YES];
      [self.delegate signupWasCanceled];
}





-(void) keyboardWillShow:(NSNotification *)note
{
        // get keyboard size and loctaion
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        // Need to translate the bounds to account for rotation.
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        // get a rect for the textView frame
        CGRect containerFrame = self.middleHolder.frame;
      //  containerFrame.origin.y = (screen.size.height-42) - (keyboardBounds.size.height);
        containerFrame.origin.y = 100;
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        // set views with new info
        self.middleHolder.frame = containerFrame;
        // commit animations
        [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    CGRect  screen =  [[UIScreen mainScreen] bounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // CGRect  screen =  [[UIScreen mainScreen] bounds];
    // get a rect for the textView frame
    CGRect containerFrame = self.middleHolder.frame;
    containerFrame.origin.y = (screen.size.height - 42);
    containerFrame.size.height = 42;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.middleHolder.frame = origninalMiddleFrame;
    // commit animations
    [UIView commitAnimations];
    //self.middleHolder.frame = containerFrame;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
        return YES;
        
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//gets rid of the keyboard
-(void)tapDetected
{
    [self.view endEditing:YES];
}




//sign up operation

-(void)performSignup
{
    [self tapDetected];
    
    if([self validateForm])
    {
        
        [self sendInitialForm];
        
        
        
        
        
        
    }
    
}




//validates the form

-(BOOL)validateForm
{
    
    
    return YES;
}

//initial sign up


-(void)sendInitialForm
{
    
    [self tapDetected];
    int i = 0;
    for(UITextField *input in tf)
    {
        if(input.text.length < 1)
        {
            [self showAlert:[NSString stringWithFormat:@"%@ Cannot Be Empty",input.restorationIdentifier]];
            break;
        }
        
        if(i == tf.count -1)
        {
          
            
            if(self.username.text.length<6 || self.username.text.length > 13)
            {
                [self showAlert:@"Username must be between 6 and 13 characters"];
            }
            
            else if(self.passcode.text.length < 6)
            {
                [self showAlert:@"Passcode Must Be at Least 6 Characters"];
            }
        
            else
            {
                [self showHud];
                
            
                NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *phone = [self.phonenumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *passcode = [self.passcode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                
                
                
                NSDictionary *params = @{
                                         @"username": [NSString stringWithFormat:@"%@",username],
                                         @"phone": [NSString stringWithFormat:@"%@",phone],
                                         @"password": [NSString stringWithFormat:@"%@",passcode],
       
                                         };
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:@"http://combustionlaboratory.com/marco/php/setPhoneForVerification.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSString *status = responseObject[@"status"];
                    
                    if ([status isEqualToString:@"one"])
                    {
                        
                        controller.signupDictionary = params;
                        [controller.phoneToVerify setText:self.phonenumber.text];
                        [controller showVerificationAlert];
                        
                        
                    }
                    else if([status isEqualToString:@"two"])
                    {
                        
                        [self showAlert:@"Username is Taken!"];
                    }
                    else if ([status isEqualToString:@"three"])
                        
                    {
                        [self showAlert:@"Phone Number in use!"];
                    }
                    else
                    {
                        [self showAlert:@"There was an error"];
                    }
                    
                       [self hideHud];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self hideHud];
                    
                    [self showAlert:@"There was an error"];
                }];
            }
        }
        
        i++;
    }
    
    
}



//








//textfield delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SpecialTextField *s = textField;
    [s setWhitePlaceholder:@" " :[UIColor whiteColor]];
    [s showShapeLayer];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    SpecialTextField *s = textField;
    s.placeholder = s.originalPlaceholder;
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    SpecialTextField *s = textField;
   [s setWhitePlaceholder:s.originalPlaceholder :[UIColor whiteColor]];
    [s hideShapeLayer];
    return YES;
}

- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == tf.count - 1)
    {
        NSLog(@"done");
        [self performSignup];
    }
    else
    {
        SpecialTextField *t = [tf objectAtIndex:textField.tag + 1];
     //   [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag + 1))) animated:YES];
        [textField resignFirstResponder];
        [t becomeFirstResponder];
    }
    
    
}

//end textfield delegate


//phone verificaiton delegation methods
-(void)userDidVerify :(NSString*)username :(NSString *)password
{
    [controller hideVerificationAlert];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate signupWasSuccessful:username :password];
}
-(void)userCanceledVerification
{
    
}

//delegate mathod of the phone verification. we entered a code and now we want to see if it is correct.
-(void)tryToVerify:(NSString *)code:(NSDictionary *)dict
{
    [self finalSignup:code:dict];
}
-(void)resendCodeButtonPressed:(NSDictionary *)dict
{
    [self reSendCode:dict];
}
// end delegate


//this checks if the verification code was right
-(void)finalSignup:(NSString *)codes:(NSDictionary *)dict
{
    
    
    [self.view endEditing:YES];
    if(codes.length <4)
    {
        [self showAlert:@"Invalid Security Code"];
    }
    else
    {
        
        [controller showHud];
        
        NSString *username = [dict objectForKey:(@"username")];
        NSString *phone = [dict objectForKey:(@"phone")];
        NSString *password = [dict objectForKey:(@"password")];
        NSString *code = codes;
        
       
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        
        
        
        NSDictionary *params = @{
                                 @"username": [NSString stringWithFormat:@"%@",username],
                                 @"phone": [NSString stringWithFormat:@"%@",phone],
                                 @"password": [NSString stringWithFormat:@"%@",password],
                                 @"code": [NSString stringWithFormat:@"%@",code],
                                 @"device": [NSString stringWithFormat:@"%@",@"iPhone"],
                                 };
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://combustionlaboratory.com/marco/php/phoneSignup.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            
            NSString *status = responseObject[@"status"];
            
            if ([status isEqualToString:@"one"])
            {
                
                //this is fi everythign worked and we were able to sign up. now the controller should dismiss it self.
                
                    [controller hideHud];
                    [self userDidVerify:username:password];
            }
            else if([status isEqualToString:@"two"])
            {
                [self showAlert:@"Username taken"];
            }
            else if ([status isEqualToString:@"three"])
            {
                [self showAlert:@"Phone in use"];
            }
            else if ([status isEqualToString:@"four"])
            {
                [self showAlert:@"Invalid Security Code"];
            }
            else
            {
                [self showAlert:@"There was an error"];
            }
            
            [controller hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            [controller hideHud];
        }];
        
    }
    
}



-(void)reSendCode:(NSDictionary *)dict
{
    
    [controller showHud];
    
    
    [self.view endEditing:YES];
    
    NSString *name = [dict objectForKey:(@"name")];
    NSString *username = [dict objectForKey:(@"username")];
    NSString *phone = [dict objectForKey:(@"phone")];
    NSString *password = [dict objectForKey:(@"password")];
    
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    
    NSDictionary *params = @{
                             @"username": [NSString stringWithFormat:@"%@",username],
                             @"phone": [NSString stringWithFormat:@"%@",phone],
                             @"password": [NSString stringWithFormat:@"%@",password],
                             @"name": [NSString stringWithFormat:@"%@",name],
                             
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/setPhoneForVerification.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        
        if ([status isEqualToString:@"one"])
        {
            [self showAlert:@"Code has been sent to your phone"];
        }
        else if([status isEqualToString:@"two"])
        {
            [self showAlert:@"Username taken"];
        }
        else if ([status isEqualToString:@"three"])
        {
            [self showAlert:@"Phone in use"];
        }
        else if ([status isEqualToString:@"four"])
        {
            [self showAlert:@"Invalid Security Code"];
        }
        else
        {
            [self showAlert:@"There was an error"];
        }
        
        [controller hideHud];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    
    
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




//phone formatter
-(void)phoneChanged
{
    ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:self.phonenumber.text];
    [self.phonenumber setText:formattedNumber];
    
}


- (IBAction)signupButtonPressed:(id)sender
{
    [self sendInitialForm];
}


-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
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

-(void)hideHud
{
    [KVNProgress dismiss];
    
}
@end
