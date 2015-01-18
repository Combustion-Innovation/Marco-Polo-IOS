//
//  TermsViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
    NSString *urlString = @"http://combustioninnovation.com";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonWasPressed:(id)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}
@end
