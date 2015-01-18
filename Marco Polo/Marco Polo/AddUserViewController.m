//
//  AddUserViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/19/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "AddUserViewController.h"
#import "MarcoPoloCell.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "ECPhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
@interface AddUserViewController (){
    CGRect originalFrame;
    NSMutableArray *mainArray;
    NSMutableArray *informationHolder;
    NSMutableArray *headers;
    NSMutableArray *searchArray;
    NSInteger switcher;
    MFMessageComposeViewController *messageComposer;
    NSArray *alphabet;
}

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    originalFrame = self.searchBar.frame;
    
    //share view controller/
    [self.shareView createSubViews];
    self.shareView.parentController = self;
    //end share view
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    tap.delegate = self;
    [tap setCancelsTouchesInView:NO];
   
    
    //table view
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MarcoPoloCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView  respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView  setLayoutMargins:UIEdgeInsetsZero];
    }
    
    mainArray = [[NSMutableArray alloc]init];
    informationHolder = [[NSMutableArray alloc]init];
    headers = [[NSMutableArray alloc]init];
    searchArray =[[NSMutableArray alloc]init];
    
    switcher = 0;
    [self getOringalArray];
    
  
    
    //nill message composer
    messageComposer = [[MFMessageComposeViewController alloc]init];

    
    //search function
    [self fixSearch];
    
    //the current alphabet
    alphabet = [[NSArray alloc]init];
    alphabet = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    
    
    
    for(UIView *view in [self.tableView subviews])
    {

        [view setBackgroundColor:[UIColor clearColor]];
    }


    [self.tableView setSectionIndexColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor colorWithRed:0.941 green:0.761 blue:0.188 alpha:0.5]];
    for(UIView *view in [self.tableView subviews]) {
        if([view respondsToSelector:@selector(setIndexColor:)]) {
            [view performSelector:@selector(setIndexColor:) withObject:[UIColor whiteColor]];
        }
    }

    [[UITableView appearance] setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSectionIndexTrackingBackgroundColor:[UIColor colorWithRed:0.941 green:0.761 blue:0.188 alpha:0.5]];
    [[UITableView appearance] setSectionIndexColor:[UIColor whiteColor]];
    
    
    //this gets rid of the keyboard when scrolling
    //tap gesture recognizer to detect when something has been tapped
    UILongPressGestureRecognizer *longPressRecognizer =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(noKeyboard)];
    longPressRecognizer.minimumPressDuration = .001;
    longPressRecognizer.delegate = self;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:longPressRecognizer];
    longPressRecognizer.cancelsTouchesInView = NO;
    
    
}


-(void)noKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void)fixSearch
{
    //search start
    [self.searchBar setTintColor:[UIColor lightGrayColor]];
    self.searchBar.delegate = self;
    //search end
    //sets the color of the tint of the cancel button to white
    NSArray *subSearch = [self.searchBar subviews];
    for(UIView *v in subSearch)
    {
        if(![v isKindOfClass:[UILabel class]])
        {
            v.tintColor =[UIColor whiteColor];
        }
    }
    
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    [searchField setTintColor:[UIColor lightGrayColor]];
    
}



-(void)getOringalArray
{
    
    if(![self.contactsDictionary objectForKey:@"empty"])
    {
    
        NSArray * allKeys = [self.contactsDictionary allKeys];
        if(allKeys > 0)
        {
            NSArray *arr =  [[self.contactsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
            int i = 0;
            for(NSString *key in arr)
            {
                NSMutableArray *ar = [self.contactsDictionary objectForKey:key];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                for(NSMutableDictionary *dict in ar)
                {
                    [arr addObject:dict];
                }
                [informationHolder addObject:arr];
                [headers addObject:key];
                i++;
            }
    
    
        }
        
    }
         mainArray = informationHolder;
        [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

   
}



- (IBAction)backButtonWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



//search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self makeSearchBig];
    
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self makeSearchSmall];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    if(searchText.length < 4)
    {
        [searchArray removeAllObjects];
        mainArray = informationHolder;
        [self.tableView reloadData];
        
    }
    else
    {
            ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
            NSString *formattedNumber = [formatter stringForObjectValue:searchText];
     
            NSString *tstring = searchText;
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
            NSString *resultString = [[tstring componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            NSScanner *scanner = [NSScanner scannerWithString:resultString];
            BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
            if(isNumeric)
            {
                [self.searchBar setText:formattedNumber];
            }
      
        
             mainArray = searchArray;
            [self.tableView reloadData];
        
        [self searchFriends];
    }
        
    
    
}

//end search bar delegate


-(void)makeSearchBig
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.layer.anchorPoint = CGPointMake(1.0, 0.5);
    [UIView animateWithDuration:0
                          delay:0.0
                        options:0
                     animations:^{
                         [self.searchBar setFrame:CGRectMake(0, self.searchBar.frame.origin.y, self.view.frame.size.width, self.searchBar.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}


-(void)makeSearchSmall
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:0
                     animations:^{
                         [self.searchBar setFrame:originalFrame];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
}
//cancels keyboard
-(void)cancelKeyboard
{
    [self.view endEditing:YES];
}

//table view delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.searchBar.text.length > 3)
    {
        return 1;
    }

    return [mainArray count];
}

//index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchBar.text.length < 4)
    {
            return headers;
    }

    NSArray *arr = [[NSArray alloc]init];
    return arr;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int count = 0;
    ///return [subCategories count];
    if(self.searchBar.text.length < 4)
    {
        NSMutableArray *ar = [mainArray objectAtIndex:section];
        count = [ar count];
    }
    else
    {
        count = [mainArray count];
    }
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    MarcoPoloCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setLeftUtilityButtons:nil WithButtonWidth:80.0f];
    [cell setRightUtilityButtons:nil WithButtonWidth:80.0f];
    
    if (cell == nil)
    {
        cell = [[MarcoPoloCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
       
    }
    
    
//if we are not searhcing
if(self.searchBar.text.length<4)
{
     cell.cellType= 4;
     cell.delegate = self;
     cell.myPath = indexPath;
     [cell fixForContacts];
     NSMutableArray  *arr = [informationHolder objectAtIndex:indexPath.section];
      NSMutableDictionary *dict = [arr objectAtIndex:indexPath.row];
     NSString *name = [dict objectForKey:@"name"];
    NSString *phone = [dict objectForKey:@"phone"];
    NSString *invited = [dict objectForKey:@"invited"];
    NSData *data = [name dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
   
    NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
    [cell.mainLabel setText: valueEmoj];
    [cell.distanceLabel  setText:phone];
    if([invited intValue] == 0)
    {
          [cell.descriptionLabel  setText:@"INVITE"];
    }
    else
    {
          [cell.descriptionLabel  setText:@"INVITED"];
    }
    
}
else
{
    //NSMutableArray  *arr = [mainArray objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    cell.cellType= 5;

    NSString *name = [dict objectForKey:@"name"];
    NSString *phone = [dict objectForKey:@"phone"];
    NSData *data = [name dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
    [cell.mainLabel setText: valueEmoj];
     [cell.descriptionLabel  setText:@"MARCO"];
    
}
    
    NSUInteger row = indexPath.row;
    for (int i = 0; i < indexPath.section; i++) {
        row += [tableView numberOfRowsInSection:i];
    }
    BOOL isOdd = row % 2;

        if (isOdd)
        {
            switcher = 0;
            [cell setBackgroundColor:[UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1]];
            cell.myColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1];
            
      
        }
        else
        {
             switcher = 1;
            [cell setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]]; /*#2ecc71*/
            cell.myColor = [UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1];
        }
        
        
    NSLog(@"%d",switcher);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//header hight depending if we are searhing or not

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableArray *ar = [informationHolder objectAtIndex:section];
    if([ar count]==0)
    {
        return 0;
    }
    if(self.searchBar.text.length > 3)
    {
        return 0;
    }
    
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(2,1, 50, 13)];
        [info setTextColor:[UIColor whiteColor]];
        [info setText:[headers objectAtIndex:section]];
        [info setTextAlignment:NSTextAlignmentLeft];
        info.font = [UIFont fontWithName:@"GillSans-Bold" size:11.0f];
    
        if(switcher == 1)
        {
             [v setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1]]; /*#2ecc71*/
            
        }
        else
        {
             [v setBackgroundColor:[UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1]];
        }
   // [v setBackgroundColor:[UIColor clearColor]];
    
         [v addSubview:info];
    
    return v;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}





//searches for people by their username
-(void)searchFriends
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    
    
    
    NSDictionary *params = @{
                             @"user_id": [NSString stringWithFormat:@"%@",user_id],
                             @"username": [NSString stringWithFormat:@"%@",self.searchBar.text],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/searchUsername.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
         NSMutableArray *results = responseObject[@"results"];
        [searchArray removeAllObjects];
        for(NSMutableDictionary *dict in results)
        {
            [searchArray addObject:dict];
            
        }
   
    
        //mainArray = searchArray;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}






//marco polo cell delegate
-(void)cellWasInvited:(MarcoPoloCell *)myCell:(NSIndexPath *)cellPath
{
    
    NSMutableArray *arr = [informationHolder objectAtIndex:cellPath.section];
    NSMutableDictionary *dict = [arr objectAtIndex:cellPath.row];
    NSString *isInvited = [dict objectForKey:@"invited"];
    //ONLY IF THE USER HAS NOT BEEN INVITED BY U YET
    if([isInvited isEqualToString:@"0"])
    {
    
        NSString *phone = [dict objectForKey:@"phone"];
 
        if ([MFMessageComposeViewController canSendText]) {
            if (messageComposer) {
                messageComposer = nil;
                messageComposer = [[MFMessageComposeViewController alloc]init];
                [self.tableView selectRowAtIndexPath:cellPath animated:NO scrollPosition:self.tableView.contentOffset.y];
            }
            messageComposer.recipients = [NSArray arrayWithObjects:phone, nil];
            messageComposer.messageComposeDelegate = self;
            messageComposer.body = @"Come join me on this great new app, Marco Polo bitly.dfdfdf ";
            [self presentViewController:messageComposer animated:YES completion:nil];
        }
    }
    
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    
    NSIndexPath *cellPath = [self.tableView indexPathForSelectedRow];
    NSMutableArray *arr = [informationHolder objectAtIndex:cellPath.section];
    NSMutableDictionary *dict = [arr objectAtIndex:cellPath.row];
    UITableViewCell   *cell = [self.tableView cellForRowAtIndexPath:cellPath];
    
    NSMutableDictionary *m = [dict mutableCopy];

  //  ((SelectionListViewController *)myEditController)
    
    switch (result)
    {
        case MessageComposeResultCancelled:
              [self.tableView deselectRowAtIndexPath:cellPath animated:NO];
            break;
        case MessageComposeResultFailed:
             [self.tableView deselectRowAtIndexPath:cellPath animated:NO];
            break;
        case MessageComposeResultSent:
            
           
            [m setObject:@"1" forKey:@"invited"];
            [arr replaceObjectAtIndex:cellPath.row withObject:m];
            [((MarcoPoloCell *)cell).descriptionLabel setText:@"INVITED"];
            [((MarcoPoloCell *)cell) sendInviteStatus:m];
            [self.delegate userWasInvited:m:cellPath:[headers objectAtIndex:cellPath.section]];
            [self.tableView deselectRowAtIndexPath:cellPath animated:NO];
            break;
        // default:
        
    //    break;
      
    }
    [self dismissModalViewControllerAnimated:YES];
}


-(void)cellWasRandomMarco:(MarcoPoloCell *)myCell:(NSIndexPath *)cellPath
{

    NSMutableDictionary *dict = [mainArray objectAtIndex:cellPath.row];
    NSLog(@"ok this works");
    
    [self.delegate addRandomToMarcos:dict];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   if(!self.shareView.isClosed)
   {
       [self.shareView toggleSocialOut];
   }
}

//end marco polo cell delegate



///remove swipe
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{

    
    switch (state) {
        case 1:
      
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return NO;
            break;
        default:
            break;
    }
    
    return YES;
}


@end
