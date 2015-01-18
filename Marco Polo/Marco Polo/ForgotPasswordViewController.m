//
//  ForgotPasswordViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/7/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>

#import "ForgotPasswordViewController.h"
#import "ECPhoneNumberFormatter.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface ForgotPasswordViewController (){
    NSArray *tf;
    NSArray *placeholders;
    CGRect origninalMiddleFrame;

}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    origninalMiddleFrame = self.middleView.frame;
   
    
    [self setupStuff];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupStuff
{
    placeholders = [[NSArray alloc]init];
    placeholders = @[@"Username",@"Phone Number"];
    
    tf = [[NSArray alloc]init];
    tf = @[self.usernameField,self.phoneField];
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

- (void)registerForKeyboardNotifications
{
    //ends editing on the tap screen
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    
    
    [self.phoneField addTarget:self
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
    CGRect containerFrame = self.middleView.frame;
    //  containerFrame.origin.y = (screen.size.height-42) - (keyboardBounds.size.height);
    containerFrame.origin.y = 100;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set middleView with new info
    self.middleView.frame = containerFrame;
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
    CGRect containerFrame = self.middleView.frame;
    containerFrame.origin.y = (screen.size.height - 42);
    containerFrame.size.height = 42;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    self.middleView.frame = origninalMiddleFrame;
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
    NSLog(@"sstarted");
    SpecialTextField *s = textField;
    [s setWhitePlaceholder:s.originalPlaceholder :[UIColor whiteColor]];
    [s hideShapeLayer];
    return YES;
}

- (IBAction)rpWasPressed:(id)sender {
            [self resetPassword];
}

- (IBAction)backButtonWasPressed:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//gets rid of the keyboard
-(void)tapDetected
{
    [self.view endEditing:YES];
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


- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == tf.count - 1)
    {
        NSLog(@"done");
        [self resetPassword];
    }
    else
    {
        SpecialTextField *t = [tf objectAtIndex:textField.tag + 1];
    
        [textField resignFirstResponder];
        [t becomeFirstResponder];
    }
    
    
}
//when the phone number text field changes we format it to be a phone number
-(void)phoneChanged
{
    ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:self.phoneField.text];
    [self.phoneField setText:formattedNumber];
    
}


//trying to reset password
-(void)resetPassword
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
            [self showHud];
            
            NSString *phone = [self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *username= [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSDictionary *params = @{
                                     @"username": [NSString stringWithFormat:@"%@",username],
                                     @"phone": [NSString stringWithFormat:@"%@",phone],
           
                                     };
            
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://combustionlaboratory.com/marco/php/forgotPW.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
                
                NSString *status = responseObject[@"status"];
                
                if ([status isEqualToString:@"one"])
                {
                    NSLog(@"it was one");
                    [self toastMessage:@"A new password has been sent!"];
                }
                else if([status isEqualToString:@"two"])
                {
                     [self showAlert:@"Username/Phone Number Incorrect"];
                }
                else if ([status isEqualToString:@"three"])
                {
                     [self showAlert:@"There was an error"];
                }
                else if ([status isEqualToString:@"four"])
                {
                     [self showAlert:@"There was an error"];
                }
                else
                {
                    [self showAlert:@"There was an error"];
                }
                
                [self hideHud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self hideHud];
            }];
            
            
            
            
            
        }
        i++;
    }
    
    
    
}



-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleSize = 55.0f;
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
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
    [hud hide:YES afterDelay:3];
}
@end
