//
//  LoginViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"
#import "ECPhoneNumberFormatter.h"
#import "MBProgressHud.h"
#import "SWTableViewCell.h"
@interface LoginViewController (){
    NSArray *tf;
    NSArray *placeholders;
    CGRect origninalMiddleFrame;
    LoginManager *lManager;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    origninalMiddleFrame = self.middleHolder.frame;
    lManager = nil;
    
    [self setupStuff];
    [self registerForKeyboardNotifications];
}



-(void)setupStuff
{
    placeholders = [[NSArray alloc]init];
    placeholders = @[@"Username or Phone #",@"Passcode"];
    
    tf = [[NSArray alloc]init];
    tf = @[self.username,self.password];
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
    
    
    
    [self.username addTarget:self
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate loginWasCanceled];
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
    NSString *formattedNumber = [formatter stringForObjectValue:self.username.text];
    if(self.username.text.length > 4)
    {
        NSString *tstring = self.username.text;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSString *resultString = [[tstring componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
     
        NSScanner *scanner = [NSScanner scannerWithString:resultString];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if(isNumeric)
        {
            [self.username setText:formattedNumber];
        }
    }
    else
    {
        
    }
    
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
    SpecialTextField *s = textField;
    [s setWhitePlaceholder:s.originalPlaceholder :[UIColor whiteColor]];
    [s hideShapeLayer];
    return YES;
}

- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == tf.count - 1)
    {
        NSLog(@"done");
        [self tryToLogin];
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


-(void)tryToLogin
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
         
     
            if(lManager)
            {
                lManager = nil;
            }
            [self showHud];
            NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *passcode = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            lManager = [[LoginManager alloc]initWithFrame:CGRectZero];
            lManager.delegate = self;
            [lManager login:username :passcode];
            
            
            
            
        }
        i++;
    }
    
}


//login manager delegate



//login manager deleaget start

-(void)PushLoginError
{
    [self hideHud];
    [self showAlert:@"Username/Password Incorrect"];
}
-(void)PushUpdatedLogin:(NSDictionary *)extraData
{
    [self hideHud];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate loginWasSuccessful];
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

//end login delegate







- (IBAction)loginButtonWasPressed:(id)sender {
    [self tryToLogin];
}
@end
