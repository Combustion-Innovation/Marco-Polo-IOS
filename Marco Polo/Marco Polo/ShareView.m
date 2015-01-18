//
//  ShareView.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/9/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "ShareView.h"
@import Twitter;
@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    
    if(self)
    {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.941 green:0.761 blue:0.188 alpha:1] /*#f0c230*/];
        self.isClosed = YES;
        self.canClick = YES;
        [self createSubViews];
    }

    return self; 
}




-(void)createSubViews
{
    
    [self setBackgroundColor:[UIColor clearColor]/*#f0c230*/];

    self.b = [[UIButton alloc]initWithFrame:self.bounds];
    [self.b.titleLabel setFont: [UIFont fontWithName:@"GillSans" size:35.0f]];
    [self.b setTitle:@"SHARE" forState:UIControlStateNormal];
    [self.b setTintColor:[UIColor whiteColor]];
    [self addSubview:self.b];
    [self setClipsToBounds:YES];
    
    self.isClosed = YES;
    self.canClick = YES;
    
    self.messageComposer = [[MFMessageComposeViewController alloc]init];
    
    [self.b setBackgroundColor:[UIColor colorWithRed:0.941 green:0.761 blue:0.188 alpha:1] ];
    UIColor *pressColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] /*#000000*/;
    
    [self.b setBackgroundImage:[self imageWithColor:pressColor] forState:UIControlStateHighlighted];
    
    [self.b addTarget:self action:@selector(toggleSocialIn) forControlEvents:UIControlEventTouchUpInside];
    [self createSocialButtons];
    
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(toggleSocialOut)];
    swiperight.numberOfTouchesRequired=1;
    swiperight.delegate = self;
    swiperight.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swiperight];
    
}





//creates all the social media Buttons
-(void)createSocialButtons
{
    
    self.facebookButton = [[UIButton alloc]init];
    self.twitterButton = [[UIButton alloc]init];
    self.textMessageButton = [[UIButton alloc]init];
    self.emailButton = [[UIButton alloc]init];
    self.cancelButton = [[UIButton alloc]init];
    self.moreButton = [[UIButton alloc]init];
    
    [self.cancelButton addTarget:self action:@selector(toggleSocialOut) forControlEvents:UIControlEventTouchUpInside];
   
    NSArray *buttons = [[NSArray alloc]init];
   // buttons = @[self.facebookButton,self.twitterButton,self.textMessageButton,self.emailButton,self.cancelButton];
     buttons = @[self.facebookButton,self.twitterButton,self.moreButton];
    NSArray *normalState = [[NSArray alloc]init];
    normalState = @[@"facebook",@"twitter",@"elipsis",@"facebook",@"facebook"];
    
    NSArray *pressState = [[NSArray alloc]init];
    pressState = @[@"facebookpushed",@"twitterpushed",@"elipsispushed",@"facebookpushed",@"facebookpushed"];
    
    NSInteger width = self.frame.size.width / [buttons count];
    
  
    
    int i = 0;
    for(UIButton *b in buttons)
    {
  
        [b setFrame:CGRectMake(width * i, 0, width, self.frame.size.height)];
        //[b setBackgroundColor:[UIColor blueColor]];
        [self addSubview:b];
        UIColor *pressColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.02] /*#000000*/;
        [b setBackgroundColor:[UIColor colorWithRed:0.941 green:0.761 blue:0.188 alpha:1] ];
        [b setBackgroundImage:[self imageWithColor:pressColor] forState:UIControlStateHighlighted];
        [b setImage:[UIImage imageNamed:[normalState objectAtIndex:i]] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:[pressState objectAtIndex:i]] forState:UIControlStateHighlighted];
        CGAffineTransform scaleTrans  = CGAffineTransformMakeScale(0.8f, 0.8f);
        b.transform = scaleTrans;
        [self sendSubviewToBack:b];
         [b addTarget:self action:@selector(socialButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
      if(i == [buttons count]-1)
     {
     //       [b addTarget:self action:@selector(socialButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
         [b setFrame:CGRectMake(self.frame.size.width - width, 0, width-10, self.frame.size.height)];
         [self sendSubviewToBack:b];
     }
        
        
        i++;
    }
    
    
    
    [self bringSubviewToFront:self.b];
}






//brings in the social buttons
-(void)toggleSocialIn
{
    NSLog(@"trying");
    if(self.isClosed  && self.canClick)
    {
        self.isClosed = NO;
        self.canClick = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.b setFrame:CGRectMake(self.frame.size.width, 0, self.b.frame.size.width, self.b.frame.size.height)];
            
       
        }completion:^(BOOL finished) {
            if(finished)
            {
                 self.canClick = YES;
            }
        }];
        
        
        NSArray *buttons = [[NSArray alloc]init];
       // buttons = @[self.facebookButton,self.twitterButton,self.textMessageButton,self.emailButton,self.cancelButton];
             buttons = @[self.facebookButton,self.twitterButton,self.moreButton];
        int i = 0;
        CGAffineTransform scaleTrans  = CGAffineTransformMakeScale(1.0f, 1.0f);
     
        
        
        for(UIButton *b in buttons)
        {
            [UIView animateWithDuration:0.3
                                  delay:0.2 * i
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 b.transform = scaleTrans;
             }completion:^(BOOL finished) {
                 
             }];
            
            i++;
        }
        
    }
    else
    {
        NSLog(@"wtf");
    }
    
    
}



//animates the social buttons out
-(void)toggleSocialOut
{
    if(!self.isClosed && self.canClick)
    {
        self.isClosed = YES;
        self.canClick = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
              [self.b setFrame:CGRectMake(0, 0, self.b.frame.size.width, self.b.frame.size.height)];
            
        }completion:^(BOOL finished) {
           if(finished)
           {
               self.canClick = YES;
           }
            
            
        }];

        NSArray *buttons = [[NSArray alloc]init];
     //   buttons = @[self.cancelButton,self.emailButton,self.textMessageButton,self.twitterButton,self.facebookButton];
            buttons = @[self.moreButton,self.twitterButton,self.facebookButton];
        CGAffineTransform scaleTrans  = CGAffineTransformMakeScale(0.5f, 0.5f);
        int i = 0;
        
        
        for(UIButton *b in buttons)
        {
            [UIView animateWithDuration:0.3
                                  delay:0.2 * i
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 b.transform = scaleTrans;
                             }completion:^(BOOL finished) {
                                 
                             }];
            
            i++;
        }
        
    }
    
    
}




//one of the scoail buttons was pressed
-(void)socialButtonWasPressed:(id)sender
{
    if(self.canClick)
    {
        if(sender == self.facebookButton)
        {
            
            BOOL isInstalled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
            if(isInstalled)
            {
              SLComposeViewController *fb=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                // make the default string
                NSString *FBString= [NSString
                                     stringWithFormat:@" via #GibberishGenerator"];
                [fb setInitialText:FBString];
                [fb addImage:[UIImage imageNamed:@"sharebutton"]];
                // show the controller
                [self.parentController presentViewController:fb animated:YES completion:nil];

                
                
            }
            else
            {
                       [self showAlert:@"Please go to settings > social and log into Facebook"];
            }
  
            
        
        }
        else if(sender ==self.twitterButton)
        {
            

            
            TWTweetComposeViewController *tweetComposeViewController =
            [[TWTweetComposeViewController alloc] init];
            
            BOOL isInstalled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
            if(isInstalled)
            {
            
            [tweetComposeViewController addImage:[UIImage imageNamed:@"sharebutton"]];
            [tweetComposeViewController setInitialText:@"Lorem ipsum dolor sit amet."];
            [self.parentController presentViewController:tweetComposeViewController
                                                    animated:YES
                                                  completion:^{
                                                      //...
                                                  }];
                
            }
            else
            {
                //means twitter is not logged in
                [self showAlert:@"Please go to settings > social and log into Twitter"];
            }
  
        }
        else if(sender == self.emailButton)
        {
            NSArray *to = [[NSArray alloc]init];
            to = @[@"contact@MarcoPolo"];
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:to];
            [controller setSubject:@"Hey Marco Polo!"];
            [controller setMessageBody:@"Dear MarcoPolo, " isHTML:NO];
            if (controller) [self.parentController presentModalViewController:controller animated:YES];
  
        }
        else if(sender == self.textMessageButton)
        {
                if ([MFMessageComposeViewController canSendText]) {
                    if (self.messageComposer) {
                        self.messageComposer = nil;
                        self.messageComposer = [[MFMessageComposeViewController alloc]init];
               
                    }
                    // self.messageComposer.recipients = [NSArray arrayWithObjects:phone, nil];
                    self.messageComposer.messageComposeDelegate = self;
                    self.messageComposer.body = @"Come join me on this great new app, Marco Polo bitly.dfdfdf ";
                    [self.parentController presentViewController:self.messageComposer animated:YES completion:nil];
                }
        }
        
        else if(sender == self.moreButton)
        {
            
            NSString *string = @"";
            NSURL *URL = @"";
            
            UIActivityViewController *activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                              applicationActivities:nil];
         
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook];
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToTwitter];
            [self.parentController presentViewController:activityViewController
                                               animated:YES
                                             completion:^{
                                                 // ...
                                             }];
            
            
            
            
        }

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




//text message delegate

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{

    //  ((SelectionListViewController *)myEditController)
    
    switch (result)
    {
        case MessageComposeResultCancelled:
       
            break;
        case MessageComposeResultFailed:
      
            break;
        case MessageComposeResultSent:
            
          
            break;
            
     
            
    }
    [self.parentController dismissModalViewControllerAnimated:YES];
}


//mail composer delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self.parentController dismissModalViewControllerAnimated:YES];
}

-(void)showAlert:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Marco Polo"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
