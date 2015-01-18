//
//  ViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CutOutView.h"
#import <KVNProgress/KVNProgress.h>
@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet CutOutView *loginView;
@property (strong, nonatomic) IBOutlet CutOutView *signupView;

@end

