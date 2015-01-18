//
//  TermsViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsViewController : UIViewController
- (IBAction)backButtonWasPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
