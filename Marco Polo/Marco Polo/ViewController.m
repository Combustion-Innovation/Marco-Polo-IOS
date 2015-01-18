//
//  ViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "ViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "LoginManager.h"

#import "LandingScreenViewController.h"
@interface ViewController (){
        NSArray *mainButtons;
        LoginManager *lManager;
        UIView *coverView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      //cover view if we are already logged in
    coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    [coverView setBackgroundColor:[UIColor colorWithRed:0.161 green:0.502 blue:0.725 alpha:1] /*#2980b9*/];
    [self.view addSubview:coverView];
    [self.view bringSubviewToFront:coverView];
    
    
    [self setupButtons];
    lManager = nil;
    [self.navigationController.navigationBar setHidden:YES];
    
  

    
    
    
    
    [self checkIfLoggedIn];
}

//sets up the buttons
-(void)setupButtons
{
    mainButtons = [[NSArray alloc]init];
    mainButtons = @[self.loginView,self.signupView];
    
    [self.signupView setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1] /*#2ecc71*/];
    [self.loginView setBackgroundColor:[UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1] /*#3498db*/];
    
    NSArray *alternateBG = [[NSArray alloc]init];
    alternateBG = @[[UIColor colorWithRed:0.161 green:0.502 blue:0.725 alpha:1] /*#2980b9*/,[UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1] /*#27ae60*/];
    
    int i = 0;
    
    NSArray *strings = [[NSArray alloc]init];
    strings = @[@"Log In",@"Sign Up"];
    for(CutOutView *v in mainButtons)
    {
      
        [v setFrame:CGRectMake(0,(self.view.frame.size.height/2) * i, self.view.frame.size.width, self.view.frame.size.height/2)];
        v.delegate = self;
        [v createSubViews];
         v.tag = i;
         v.alternate = [alternateBG objectAtIndex:i];
        [v.l setText:[strings objectAtIndex:i]];
        i++;
        
    }
    
    
    
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//start cut out view delegate

-(void)buttonSelectAnimationHasStarted:(NSInteger)index
{
    [self disableButtonClicks];
    
    
}
-(void)buttonDeselectAnimationHasStarted:(NSInteger)index
{
    
}
-(void)buttonSelectAnimationHasEnded:(NSInteger)index
{
    
    if(index == 0)
    {
        //login button
        
         UIStoryboard *storyBoard = [self storyboard];
        LoginViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"lvc"];
        c.delegate = self;
        [self.navigationController pushViewController:c animated:YES];
    }
    else
    {
        //sign up button
        
        UIStoryboard *storyBoard = [self storyboard];
        SignupViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"svc"];
         c.delegate = self;
        [self.navigationController pushViewController:c animated:YES];
    }
    
}
-(void)buttonDeselectAnimationHasEnded:(NSInteger)index
{
    
}

//end cut out view delegate



//disable clicking of other cut out view
-(void)disableButtonClicks
{
    for(CutOutView *v in mainButtons)
    {
        v.isEnabled=NO;
        
    }
    
    
}



//re enable cliccking of other cut out views
-(void)resetButtons
{
    
    for(CutOutView *v in mainButtons)
    {
        if(v.isOpen)
        {
            [v resetButton];
             v.isOpen = NO;
        }
        v.isEnabled=YES;
        
    }
    
}


//login delegate start

-(void)loginWasSuccessful
{
    //[self showHud];
    [self resetButtons];
    [self goToMainScreen];
}
-(void)loginWasCanceled
{
     [self resetButtons];
}

//login delegate end;


//signup delegate start

-(void)signupWasSuccessful:(NSString *)username:(NSString *)password
{
    [self resetButtons];
    [self showHud];
    [self tryToLogin:username:password];
}
-(void)signupWasCanceled
{
     [self resetButtons];
}
//signup delegate end


-(void)tryToLogin:(NSString *)username:(NSString *)password
{
    if(lManager)
    {
        lManager = nil;
    }
    
    lManager = [[LoginManager alloc]initWithFrame:CGRectZero];
    lManager.delegate = self;
    [lManager login:username :password];
    
    
    
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



//login manager deleaget start

-(void)PushLoginError
{
    [self hideHud];
    [self showAlert:@"There was an error!"];
    [self logoutOfMP];
}
-(void)PushUpdatedLogin:(NSDictionary *)extraData
{
     [self hideHud];
     [self goToMainScreen];
}
/*
-(void)showHud
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hideHud
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
 */

//end login delegate




//goes to the lsitviewsceeen

-(void)goToMainScreen
{
    [self hideHud];
    UIStoryboard *storyBoard = [self storyboard];
    LandingScreenViewController *c  = [storyBoard instantiateViewControllerWithIdentifier:@"lsvc"];
    c.delegate = self;
    [self presentViewController:c animated:YES completion:^{
       [self.view sendSubviewToBack:coverView];
    }];
    [self hideHud];
 
  }



//checks if the user is logged in
-(void)checkIfLoggedIn
{
    [self.view  bringSubviewToFront:coverView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lt = [defaults objectForKey:@"logintype"];
     if([lt isEqualToString:@"PUSH"])
    {
        [self.view  bringSubviewToFront:coverView];
        NSString *username = [defaults objectForKey:@"username"];
        NSString *password = [defaults objectForKey:@"password"];
        [self tryToLogin:username:password];
    }
    else
    {
         [self.view  sendSubviewToBack:coverView];
        [self hideHud];
    }
    
}
//end check if user is logged in


//landing screen delegate start

-(void)userHasLoggedout
{
    [self logoutOfMP];
}


//landingscreen delegate end


//logout function


-(void)logoutOfMP
{
    [self hideHud];
    [coverView removeFromSuperview];
     NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

//

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
