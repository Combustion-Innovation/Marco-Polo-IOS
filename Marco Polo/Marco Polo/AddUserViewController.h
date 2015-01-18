//
//  AddUserViewController.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/19/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUserDelegate.h"
#import "ShareView.h"
@interface AddUserViewController : UIViewController{
    id<AddUserDelegate>delegate;
}
- (IBAction)backButtonWasPressed:(id)sender;
@property(nonatomic,retain)NSMutableDictionary *contactsDictionary;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ShareView *shareView;
@end
