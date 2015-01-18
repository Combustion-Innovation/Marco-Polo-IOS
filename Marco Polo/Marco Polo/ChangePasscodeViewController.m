//
//  ChangePasscodeViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "ChangePasscodeViewController.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface ChangePasscodeViewController (){
    NSArray *tf;
    NSArray *placeholders;
    CGRect origninalMiddleFrame;
}

@end

@implementation ChangePasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    origninalMiddleFrame = self.middleView.frame;

    [self setupStuff];
    [self registerForKeyboardNotifications];
}


-(void)setupStuff
{
    placeholders = [[NSArray alloc]init];
    placeholders = @[@"Old Password",@"New Passcode",@"Confirm Passcode"];
    
    tf = [[NSArray alloc]init];
    tf = @[self.oldPassCode,self.nPassCode,self.cPassCode];
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
    // set views with new info
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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


- (IBAction)changePassWasPressed:(id)sender {
    [self changeUsername];
}
- (IBAction)backWasPressed:(id)sender {
      [self tapDetected];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [self changeUsername];
    }
    else
    {
        SpecialTextField *t = [tf objectAtIndex:textField.tag + 1];
        //   [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag + 1))) animated:YES];
        [textField resignFirstResponder];
        [t becomeFirstResponder];
    }
    
    
}


-(void)changeUsername
{
    [self tapDetected];
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
            
            if(self.nPassCode.text.length < 6)
            {
                [self showAlert:@"New Password Must Be at least 6 Characters"];
            }
            else if(![self.nPassCode.text isEqualToString:self.cPassCode.text])
            {
                [self showAlert:@"Passwords Do Not Match!"];
            }
            else
            {
            
            [self showHud];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
               NSString *oldPass = [self.oldPassCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
               NSString *nPass = [self.nPassCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
                NSString *user_id = [defaults objectForKey:@"user_id"];

            
            
            NSDictionary *params = @{
                                     @"oldpassword": [NSString stringWithFormat:@"%@",oldPass],
                                     @"newpassword": [NSString stringWithFormat:@"%@",nPass],
                                      @"user_id": [NSString stringWithFormat:@"%@",user_id],
                                     };
            
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://combustionlaboratory.com/marco/php/changePassword.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
                
                NSString *status = responseObject[@"status"];
                
                
                
                if ([status isEqualToString:@"one"])
                {
                    [self hideHud];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:nPass forKey:@"password"];
                    [defaults synchronize];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.delegate passcodeWasChanged];
                    }];
                }
                else if([status isEqualToString:@"two"])
                {
                    [self showAlert:@"Old Password Incorrect!"];
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
            
            
            
        }
        i++;
    }

}

-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.83f];
    [KVNProgress appearance].circleSize = 55.0f;
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
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



@end
