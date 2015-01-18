//
//  LandingScreenViewController.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
@import CoreLocation;
#import "LandingScreenViewController.h"
#import "INTULocationManager.h"
#import "PINTrans.h"
#import "GetContacts.h"
#import "ECPhoneNumberFormatter.h"
#import "AppDelegate.h"
#import "timeAgo.h"
#import "getDistance.h"
#import "MarcoPoloCell.h"

@interface LandingScreenViewController (){
    CLLocation *myLocation;
    GetContacts *c;
    NSMutableArray *peopleContacts;
    NSMutableArray *myMarcos;
    NSMutableArray *myPolos;
    NSMutableDictionary  *myContacts;
    NSMutableArray *peopleNames;
    NSMutableArray *myFriends;
    NSMutableArray *informationHolder;
    NSArray *evenColors;
    NSArray *oddColors;
    BOOL isFirstTime;
    NSMutableArray *headers;
    int wid;
    int switcher;
    AppDelegate *appDelegate;
    NSInteger marcoCount;
    NSInteger poloCount;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) PINTrans *transitionController;
@end

@implementation LandingScreenViewController
@synthesize transitionController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      appDelegate.delegate = self;
    
    

    
    //location manager stuff
    self.settingsButton.layer.anchorPoint = CGPointMake(1.0,1.0);
    self.addButton.layer.anchorPoint = CGPointMake(0,1.0);
    [self.settingsButton setFrame:CGRectMake(self.view.frame.size.width-self.settingsButton.frame.size.height, self.view.frame.size.height - self.settingsButton.frame.size.height, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height)];
    [self.addButton setFrame:CGRectMake(0, self.view.frame.size.height - self.addButton.frame.size.height, self.addButton.frame.size.width, self.addButton.frame.size.height)];
    wid = self.view.frame.size.width;
    //attach xtra
    [self.settingsButton attach];
    [self.addButton attach];
    
    //sets mylocation to nil so we know if it has been set
    
    myLocation = nil;
    isFirstTime = YES;
    
    //init all arrays
    informationHolder = [[NSMutableArray alloc]init];
    myFriends = [[NSMutableArray alloc]init];
    myContacts = [[NSMutableDictionary alloc]init];
    myPolos = [[NSMutableArray alloc]init];
    peopleNames = [[NSMutableArray alloc]init];
    
    evenColors = [[NSArray alloc]init];
    oddColors = [[NSArray alloc]init];
    //,[UIColor colorWithRed:0.204 green:0.596 blue:0.847 alpha:1] /*#3498d8*/
    evenColors = @[[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] /*#e74c3c*/,[UIColor colorWithRed:0.204 green:0.596 blue:0.847 alpha:1] /*#3498d8*/,[UIColor colorWithRed:0.18 green:0.8 blue:0.443 alpha:1] /*#2ecc71*/,[UIColor colorWithRed:0.204 green:0.286 blue:0.369 alpha:1] /*#34495e*/];
    oddColors = @[[UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:1] /*#c0392b*/,[UIColor colorWithRed:0.161 green:0.502 blue:0.725 alpha:1] /*#2980b9*/,[UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1] /*#27ae60*/,[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] /*#2c3e50*/];
    //end location manager stuff
    
    self.tableVIew.delegate =self;
    self.tableVIew.dataSource = self;
    [self.tableVIew setBackgroundColor:[UIColor clearColor]];
    [self.tableVIew registerClass:[MarcoPoloCell class] forCellReuseIdentifier:@"cell"];
    
    //header views
    headers = [[NSMutableArray alloc]init];
    [headers addObject:@"polos"];
    [headers addObject:@"recent"];


    [self.tableVIew setBackgroundColor:[UIColor clearColor]];
   // [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    if ([self.tableVIew respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableVIew  setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableVIew  respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableVIew  setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
  
    

    //gives me refresh control option
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableVIew;
    
    self.refresh = [[CustomControl alloc] init];
    self.refresh.tintColor = [UIColor grayColor];
    [self.refresh setTintColor:[UIColor whiteColor]];
    // refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [self.refresh addTarget:self action:@selector(doRefreshTwo) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = self.refresh;

    [self.refresh addSpecial];
    
    
    //the number of marcos and polos I have performed so far
    marcoCount = 0;
    poloCount = 0;
    
    
    
    //gets even switching cells
    switcher = 0;
    
    
    //buttons are hidden until things
    [self openButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doRefresh)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    

    
}


-(void)viewDidAppear:(BOOL)animated
{
    if(isFirstTime)
    {
        self.transitionController = [[PINTrans alloc] init];
        isFirstTime = NO;
        [self getUserContacts];
    }
}


-(void)doLocationStuff
{
    

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.4
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                                                 // currentLocation contains the device's current location.
                                                 //sets users defaults
                                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                 [defaults setObject:@"1" forKey:@"geolocation"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude] forKey:@"lat"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] forKey:@"lng"];
                                                 [defaults synchronize];
                                                
                                                 //sets the location variable
                                                 myLocation = currentLocation;
                                                 
                                                 //gets marcos polos and others
                                                 [self getMarcosAndPolos];
                                                 
                                             }
                                             else if (status == INTULocationStatusTimedOut) {
                                                 // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                 // However, currentLocation contains the best location available (if any) as of right now,
                                                 // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                 [defaults setObject:@"1" forKey:@"geolocation"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude] forKey:@"lat"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] forKey:@"lng"];
                                                 [defaults synchronize];
                                                 
                                                  //gets marcos polos and others
                                                  [self setFakeLocation];
                                                  [self getMarcosAndPolos];
                                             }
                                             else {
                                                 // An error occurred, more info is available by looking at the specific status returned.
                                                 
                                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                 [defaults setObject:@"2" forKey:@"geolocation"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",0.0] forKey:@"lat"];
                                                 [defaults setObject:[NSString stringWithFormat:@"%f",0.0] forKey:@"lng"];
                                                 [defaults synchronize];
                                                 [self setFakeLocation];
                                                 [self getMarcosAndPolos];
                                             }
                                         }];
}



-(void)setFakeLocation
{
    myLocation = [[CLLocation alloc] initWithLatitude:0.000000 longitude:0.0000000];

}


-(void)getMarcosAndPolos
{
    [self.tableVIew setScrollEnabled:NO];
    
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       NSString *user_id  = [defaults objectForKey:@"user_id"];

    
    NSDictionary *params = @{
                             @"user_id": [NSString stringWithFormat:@"%@",user_id],
                             @"lat": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude]],
                             @"lng": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]],
                             @"numbers": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[peopleContacts componentsJoinedByString:@","]]],
                             @"names": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[peopleNames componentsJoinedByString:@","]]],
                             @"device": @"iPhone:",
                             };

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/getListOfMarcoPolos.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *results = responseObject[@"results"];
        
        for(NSDictionary *dict in results)
        {
    
                 NSMutableArray *polos = [dict objectForKey:@"polos"];
                 NSMutableArray *marcos = [dict objectForKey:@"marcos"];
                 NSMutableDictionary *contacts = [dict objectForKey:@"contacts"];
                 NSMutableArray *blocked = [dict objectForKey:@"blocked"];
            
            
                //gets the amount of marcos and polos we made and sets them to our globals to pass to the settings obj.
                NSMutableDictionary *mpcount = [dict objectForKey:@"mp"];
          
                NSInteger mpCount = [[mpcount objectForKey:@"marcos"]intValue];
                NSInteger pc = [[mpcount objectForKey:@"polos"]intValue];
                marcoCount = mpCount;
                poloCount = pc;
                //end
            
                NSMutableArray *polosNew = [[NSMutableArray alloc]init];
                for(NSMutableDictionary *dict in polos)
                {
                    [polosNew addObject:dict];
                }
            
            
            
                NSMutableArray *marcosNew = [[NSMutableArray alloc]init];
                for(NSMutableDictionary *dict in marcos)
                {
                    [marcosNew addObject:dict];
                }
            
            
            
            
                [informationHolder addObject:polosNew];
                [informationHolder addObject:marcosNew];
          
            
                  NSMutableDictionary *friends = [dict objectForKey:@"friends"];
                if(![friends objectForKey:@"empty"])
                {
                   NSArray *arr =  [[friends allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];

                    int i = 0;
                    for(NSString *key in arr)
                    {
                        NSMutableArray *ar = [friends objectForKey:key];
                        NSMutableArray *temp = [[NSMutableArray alloc]init];

                        for(NSDictionary *dict in ar)
                        {
                            [temp addObject:dict];
                        }
                    
                        [informationHolder addObject:temp];
                        [headers addObject:key];
                        i++;
                    }
                }
                    NSMutableArray *blockednew = [[NSMutableArray alloc]init];
                    for(NSMutableDictionary *d in blocked)
                    {
                        [blockednew addObject:d];
                    }
            
                [informationHolder addObject:blockednew];
                [headers addObject:@"blocked"];
                 myContacts = contacts;
        }

        
        
        [self.settingsButton setUserInteractionEnabled:YES];
        [self.addButton setUserInteractionEnabled:YES];
        [self bringEmBack];
        [self.tableVIew reloadData];
        [self animateCells];
        [self hideHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self hideHud];
    }];
    
}


//take an array of letters and sorts them
- (NSArray*)sortAllKeys: (NSArray*)passedArray{
    NSArray* performSortOnKeys = [passedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return performSortOnKeys;
}



-(void)animateCells
{
    NSArray *ar = [self.tableVIew visibleCells];
    int i = 0;
    for(UIView *v in ar)
    {
        [v setAlpha:0];
        [UIView animateWithDuration:0.3
                              delay:0.05 * i
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [v setAlpha:1];
                         }completion:^(BOOL finished) {
                             
                         }];
        i++;
    }
    [self.tableVIew setScrollEnabled:YES];
    [self.view bringSubviewToFront:self.settingsButton];
    [self.view bringSubviewToFront:self.addButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//table view delegate methods
// Somewhere in your implementation file:
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self openButtons];
}

-(void)openButtons
{
    
    [NSOperationQueue cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.settingsButton.transform = CGAffineTransformMakeRotation(M_PI/2);
                         self.addButton.transform = CGAffineTransformMakeRotation(-M_PI/2);
                     }completion:^(BOOL finished) {
                         
                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  [self performClose];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self performClose];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    
    if(!decelerate)
    {
     
              [self performClose];
        
    
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger myint = self.tableVIew.contentOffset.y;
    
 /*  if (scrollView.contentOffset.y <= -100)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = -100;
        scrollView.contentOffset = offset;
        [self doRefreshTwo];
        
    }*/
    
    [self.refresh scrollViewMovedBounds:myint];
}


-(void)performClose
{
     [self performSelector:@selector(bringEmBack) withObject:nil afterDelay:0.4];
}

-(void)bringEmBack
{
  //  dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.9612);
  //  dispatch_after(delay, dispatch_get_main_queue(), ^(void){
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.settingsButton.transform = CGAffineTransformMakeRotation(0);
                         self.addButton.transform = CGAffineTransformMakeRotation(0);
                     }completion:^(BOOL finished) {
                         
                     }];
        
     //   });
}



//start table view functionns

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [informationHolder count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
///return [subCategories count];
    NSMutableArray *ar = [informationHolder objectAtIndex:section];
    return [ar count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MarcoPoloCell *cell = [self.tableVIew dequeueReusableCellWithIdentifier:@"cell"];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:80.0f];
    [cell setRightUtilityButtons:nil WithButtonWidth:80.0f];
    
    if (cell == nil)
    {
        cell = [[MarcoPoloCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     //   cell.leftUtilityButtons = [self leftButtons];
     //   cell.rightUtilityButtons = [self rightButtons];
       
    }
    
    cell.myPath = indexPath;
    NSMutableArray  *arr = [informationHolder objectAtIndex:indexPath.section];
    NSDictionary *dict = [arr objectAtIndex:indexPath.row];
    NSString *name = [dict objectForKey:@"username"];

     cell.delegate = self;
   
    [cell.mainLabel setText: name];
 
    [cell.distanceLabel  setText:@""];
   


    
    if(indexPath.section < 2)
    {
        if (indexPath.row  % 2)
        {
            [cell setBackgroundColor:[oddColors objectAtIndex:indexPath.section]];
        }
        else
        {
            [cell setBackgroundColor:[evenColors objectAtIndex:indexPath.section]];
        }
        
        if(indexPath.section == 0)
        {
            [cell.descriptionLabel setText:@"POLO"];
            [cell.distanceLabel setText:@""];
            cell.cellType = 0;
        }
        else
        {
            [cell.descriptionLabel setText:@"MARCO"];
            NSString *distance = [dict objectForKey:@"distance"];
            NSString *direction = [dict objectForKey:@"direction"];
              NSString *created = [dict objectForKey:@"created"];
            [cell.distanceLabel setText:[NSString stringWithFormat:@"%@ %@ %@",direction,distance,created]];
            cell.cellType = 1;
        }
         cell.cellType =indexPath.section;
    }
    else if(indexPath.section == [informationHolder count]-1)
    {
            [cell.descriptionLabel setText:@"UNBLOCK"];
            [cell.distanceLabel setText:@""];
            if (indexPath.row  % 2)
            {
                [cell setBackgroundColor:[oddColors objectAtIndex:3]];
            
            }
            else
            {
                [cell setBackgroundColor:[evenColors objectAtIndex:3]];
            }
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:80.0f];

        cell.cellType = 3;
    }
    
    
    else
    {
        cell.cellType = 2;
 
        
        NSUInteger row = indexPath.row;
        for (int i = 0; i < indexPath.section; i++) {
            row += [tableView numberOfRowsInSection:i];
        }
        BOOL isOdd = row % 2;
        
        [cell.descriptionLabel setText:@"MARCO"];
        //friends
         [cell.distanceLabel setText:@""];
        if (isOdd)
        {
            switcher = 0;
                    [cell setBackgroundColor:[evenColors objectAtIndex:2]];
        
        }
        else
        {
            switcher = 1;
                   [cell setBackgroundColor:[oddColors objectAtIndex:2]];

        }
        
  

    }
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellHeight:cell.frame.size.height];
    
    return cell;
    
}
/*
- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UIView *v;
    if(section == 2)
    {
        UIView *v  = [[UIView alloc]initWithFrame:CGRectMake(0,1, self.view.frame.size.width, 1)];
        [v setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [v setFrame:CGRectZero];
    }

    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        if(section == 1)
        {
            return 1;
        }
        else
        {
        
        }
    
        return 0;
    
}

*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
  //  fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
  //  fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
  //  fadeAnim.duration = 0.4;
  //  [cell.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    // Change the actual data value in the layer to the final value.
   // cell.layer.opacity = 1.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableArray *ar = [informationHolder objectAtIndex:section];
    if([ar count]==0)
    {
        return 0;
    }
    if((section > 1 && section < [ar count]-1) || section == [informationHolder count] -1)
    {
        return 0;
    }
    
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    if(section < 2)
    {
        [v setFrame:CGRectZero];
    }
    else if(section == [informationHolder count]-1)
    {
        
        [v setFrame:CGRectZero];
    }
    else
    {
        
        UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 50, 13)];
        [info setTextColor:[UIColor whiteColor]];
        [info setText:[headers objectAtIndex:section]];
        [info setTextAlignment:NSTextAlignmentLeft];
        info.font = [UIFont fontWithName:@"GillSans-Bold" size:11.0f];
       if(switcher == 1)
       {
           [v setBackgroundColor:[oddColors objectAtIndex:2]];
        }
        else
        {
            [v setBackgroundColor:[evenColors objectAtIndex:2]];
        }
        [v addSubview:info];
    }
    return v;
    
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
    return 80.0;
}



//tells me the current state of the buttons when they are switches
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
              [self openButtons];
            break;
        case 2:
            NSLog(@"right utility buttons open");
            [self openButtons];
            break;
        default:
            break;
    }
    
}

//one of the utility buttons on the left side was pressed on the cell
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *p = ((MarcoPoloCell *)cell).myPath;
    NSMutableArray  *arr = [informationHolder objectAtIndex:p.section];
    NSMutableDictionary *dict = [arr objectAtIndex:p.row];
    
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            ///moves the person to the blcoked section
            
            [self movePersonToBlocked:p];
            [((MarcoPoloCell *)cell) blockThisPerson:dict:YES];
            [self removeFromMarcoPolos:dict];
            [cell hideUtilityButtonsAnimated:NO];
            
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
    
    [cell hideUtilityButtonsAnimated:YES];
    
}

//one of the right ones was pressed
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableVIew indexPathForCell:cell];
            
            //   [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            //   [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
    
    [cell hideUtilityButtonsAnimated:YES];
}



- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    NSInteger pathOfCell = ((MarcoPoloCell *)cell).myPath.section;
    
    switch (state) {
        case 1:
            if(pathOfCell == [informationHolder count]-1 || pathOfCell < 2)
            {
                return NO;
            }
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            if(((MarcoPoloCell *)cell).myPath.section == [informationHolder count]-1)
            {
                return YES;
            }
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

//cell utility functions
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1] /*#e74c3c*/
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.204 green:0.286 blue:0.369 alpha:1] /*#34495e*/
                                                icon:[UIImage imageNamed:@"block"]];
    
    return leftUtilityButtons;
}
//end table view functions


//settings button was pressed and now we are going to go to the settings screen
- (IBAction)settingsButtonWasPressed:(id)sender
{
    NSLog(@"what the fuck");
    UIStoryboard *storyBoard = [self storyboard];
    SettingsViewController *sc  = [storyBoard instantiateViewControllerWithIdentifier:@"tsvc"];
    sc.delegate = self;
    sc.modalTransitionStyle = UIModalPresentationCustom;
    sc.transitioningDelegate = self;
    [sc setTransitioningDelegate:transitionController];
    [self presentViewController:sc animated:YES completion:nil];
    [sc setMarcoPoloCount:poloCount :marcoCount];
}
//add people  button was pressed and now we are going to go to the settings screen
- (IBAction)addPeopleButtonPressed:(id)sender
{
    UIStoryboard *storyBoard = [self storyboard];
    AddUserViewController *apc  = [storyBoard instantiateViewControllerWithIdentifier:@"auvc"];
    apc.contactsDictionary = myContacts;
    apc.delegate = self;
    apc.modalTransitionStyle = UIModalPresentationCustom;
    apc.transitioningDelegate = self;
    [apc setTransitioningDelegate:transitionController];
    [self presentViewController:apc animated:YES completion:nil];

}


//settings delegate
-(void)UserDoesWantToLogOut
{
    NSLog(@"@");
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate userHasLoggedout];
    }];
   
}





//get contacts function
-(void)getUserContacts
{
    c = [[GetContacts alloc]init];
    c.delegate = self;
    [c getContacts:1];
}


//get contacts delegate

-(void)returnPhoneNumbersAndNames:(NSMutableArray*)numbers:(NSMutableArray *)names
{
    peopleNames = names;

    peopleContacts = numbers;

   // NSLog(@"%@",numbers);
    [self doLocationStuff];

}
-(void)userMustEnableContacts
{
 
   BOOL didAlert = [self didAlertForEnableContacts];
    if(!didAlert)
    {
        [self showAlert:@"Go to Settings > Privacy to turn on Contacts"];
    }
    [self doLocationStuff];

}



//checks if we told the user to let us have access to his contacts
-(BOOL)didAlertForEnableContacts
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults objectForKey:@"alertedContacts"])
    {
        [defaults setObject:@"yes" forKey:@"alertedContacts"];
        [defaults synchronize];
        return NO;
    }
    
    return YES;
    
    

}
//end of contacts delegate



//showing

// add user delegate

-(void)userWasInvited :(NSMutableDictionary *)dict :(NSIndexPath*)path :(NSString *)key;
{
    NSMutableArray *ar = [myContacts objectForKey:key];
    //[ar replaceObjectAtIndex:path.row withObject:dict];
    NSLog(@"%@",ar);
}
//end adduser delegate




//moves cell to the blocked view
-(void)movePersonToBlocked:(NSIndexPath*)path
{
     NSInteger section = [informationHolder count]-1;
    [self.tableVIew setScrollEnabled:NO];
     NSMutableArray *ar = [informationHolder objectAtIndex:path.section];
     NSDictionary *dict = [ar objectAtIndex:path.row];
    
    NSMutableArray *arr = [informationHolder objectAtIndex:section];
    [ar removeObjectAtIndex:path.row];
    [arr insertObject:dict atIndex:0];
    
    
   
    //the newpath
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    
    //row to remove
    NSArray *deleteArray = [[NSArray alloc]init];
    deleteArray = @[path];
   
     //row to insert
     NSArray *insertArray = [[NSArray alloc]init];
     deleteArray = @[newPath];
    
     [self.tableVIew beginUpdates];
        [self.tableVIew moveRowAtIndexPath:path  toIndexPath:newPath];
    [self.tableVIew endUpdates];
    [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
}



//instead of moving the marco, we then add it to the list of marcos and keep it in the contacts
-(void)addContactToMarco:(NSIndexPath*)path
{
   
    [self.tableVIew setScrollEnabled:NO];
    NSMutableArray *ar = [informationHolder objectAtIndex:path.section];
   //the current dict of the object i am sending from the chose paat
    NSDictionary *dict = [ar objectAtIndex:path.row];
   //gets the username of the object we want to move to marcos.
    NSString *username = [dict objectForKey:@"username"];
    ///the index of that person in the marco array
    NSInteger mIndex = [self getmarcoAtIndex:username];
    //we do not exist in the marcos table already. but if we do we get the index creat a new path and just move the marco up
    //this now checks if we are in polos too because if we are we want to polo someone back and put them back in
    NSInteger poloIndex = [self getPoloAtIndex:username];
    
    //we will marco
    if(mIndex != -1)
    {
        //we already exist in marcos so lets just animate the current marco object to the top instead
        NSIndexPath *np = [NSIndexPath indexPathForRow:mIndex inSection:1];
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:path];
        [((MarcoPoloCell *)cell)  marcoWasTapped:dict];
        [self moveContactToMarco:np];
           NSLog(@"should marco");
    }
    //we will polo
    else if(poloIndex != -1)
    {
        NSMutableArray *ma = [informationHolder objectAtIndex:0];
        //the current dict of the object i am sending from the chose paat
        NSDictionary *pdict = [ma objectAtIndex:poloIndex];
        //we already exist in marcos so lets just animate the current marco object to the top instead
        NSIndexPath *np = [NSIndexPath indexPathForRow:poloIndex inSection:0];
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:path];
        [((MarcoPoloCell *)cell)  poloWasTapped:pdict];
        [self moveContactToMarco:np];
        
        NSLog(@"should polo");
    }
    else
    {

        NSMutableArray *arr = [informationHolder objectAtIndex:1];
        [arr insertObject:dict atIndex:0];
        
        [self.tableVIew beginUpdates];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *insertArray = [[NSArray alloc]init];
        insertArray = @ [newPath];
        
        
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:path];
        [((MarcoPoloCell *)cell)  marcoWasTapped:dict];
        
        [self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableVIew endUpdates];
            //sends the marco
   
        
        [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];

    }
        
    
  }



//moves some one to marcos from another path
-(void)moveContactToMarco:(NSIndexPath*)path
{
    [self.tableVIew setScrollEnabled:NO];
    NSMutableArray *ar = [informationHolder objectAtIndex:path.section];
    NSDictionary *dict = [ar objectAtIndex:path.row];
    
    NSMutableArray *arr = [informationHolder objectAtIndex:1];
    [ar removeObjectAtIndex:path.row];
    [arr insertObject:dict atIndex:0];
    
    
    [self.tableVIew beginUpdates];
    
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    NSArray *deleteArray = [[NSArray alloc]init];
    deleteArray = @[path];
    
    NSArray *insertArray = [[NSArray alloc]init];
    deleteArray = @[newPath];
    
    
    // [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationBottom];
    //[self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableVIew moveRowAtIndexPath:path  toIndexPath:newPath];
    [self.tableVIew endUpdates];
    [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
}




//gets  a marco from a push notification then looks through my friends to see if the username exists and if it does it will get the index of it and move it to the marcos field
-(void)moveToMarcosFromFriends:(NSString *)username:(NSDictionary *)object
{
   
    NSInteger mIndex = [self getmarcoAtIndex:username];
    NSInteger poloIndex = [self getPoloAtIndex:username];
    NSInteger friendIndex = [self getUserFromFriendsList:username];
    
    
    if(mIndex != -1)
    {
            //currently in the marcos
            NSLog(@"inmarcos %d",mIndex);
            NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:mIndex inSection:1];
           [self moveContactToPolo:myIndexPath];
        
    }
    else if(poloIndex != -1)
    {
        ///currently in the polos
        NSLog(@"inpolos %d",poloIndex);
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:poloIndex inSection:0];
        [self moveContactToPolo:myIndexPath];
        
    }
    else if(friendIndex != -1)
    {
        //exists in friends so lets get the friend index from the section to move it to send to the function
        
         NSInteger indexInSection =  [self getindexWithinFriendarray:friendIndex:username];
         NSLog(@"in friends %ld",(long)indexInSection);
         NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:indexInSection inSection:friendIndex];
         [self moveContactToPolo:myIndexPath];
    }
    else
    {
        //doesnt exist yet
    }
    
    
}

//I sent the user a marco and now he polo'd back so I should have locationa and last update
-(void)updateMarco:(NSDictionary *)object
{
    
    
}


//get poloatindex
-(NSInteger)getPoloAtIndex:(NSString *)stringToMatch
{
      NSMutableArray *currentPolos =[informationHolder objectAtIndex:0];
    if([currentPolos count]  >0)
    {
    
      int i = 0;
     for(NSDictionary *dict in currentPolos)
     {
         NSString *username = [dict objectForKey:@"username"];
         NSLog(@"the current username is %@",username);
         
         if([username isEqualToString:stringToMatch])
         {
             return i;
         }
         i++;
     }
    
    }

    return -1;
    
}
//get marco at index
-(NSInteger)getmarcoAtIndex:(NSString *)stringToMatch
{
    NSMutableArray *currentMarcos =[informationHolder objectAtIndex:1];
    if([currentMarcos count]  >0)
    {
    int i = 0;
    for(NSDictionary *dict in currentMarcos)
    {
        NSString *username = [dict objectForKey:@"username"];
        NSLog(@"the current username is %@",username);
        
        if([username isEqualToString:stringToMatch])
        {
            return i;
        }
        i++;
    }
    }
    return -1;
    
}

//looks for a user that might be in your friends list. IE if we have a user with the letter j it searches the main array for the index of J by usering index of object. will be true or false

-(NSInteger)getUserFromFriendsList:(NSString *)stringToMatch
{
   
    NSString *firstletter = [stringToMatch substringToIndex:1];
    NSString *str = [firstletter capitalizedString];
    NSInteger letterIndex = [headers indexOfObject:str];
    

    if(letterIndex == -1)
    {
        return -1;
    }
    else
    {
        return letterIndex;
    }


    return -1;
    
}
//it then searches this for the index of the user within the correct "letter" array to find the index of that person with in that array. IE if the array is from the J object, we then search by user name to find out what index that person is in.
-(NSInteger)getindexWithinFriendarray :(NSInteger)section :(NSString *)username
{
    NSMutableArray *currentMarcos =[informationHolder objectAtIndex:section];
    int i = 0;
    for(NSDictionary *dict in currentMarcos)
    {
        NSString *un = [dict objectForKey:@"username"];
        NSLog(@"the current username is %@",username);
        
        if([un isEqualToString:username])
        {
            return i;
        }
        i++;
    }
    
    return -1;

}

-(void)moveContactToPolo:(NSIndexPath*)path
{
    [self.tableVIew setScrollEnabled:NO];
    NSMutableArray *ar = [informationHolder objectAtIndex:path.section];
    NSDictionary *dict = [ar objectAtIndex:path.row];
    
    
    //removes the array from the current index and then switches it
     NSMutableArray *arr = [informationHolder objectAtIndex:0];
     [ar removeObjectAtIndex:path.row];
     [arr insertObject:dict atIndex:0];
    
    //begins the updates and then moves it
        [self.tableVIew beginUpdates];
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableVIew moveRowAtIndexPath:path  toIndexPath:newPath];
        [self.tableVIew endUpdates];
    
    [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
}






#pragma mark - SWTableViewDelegate


///marco polo cell delegate
//contacts was pressed so we send them to the marcos instead if the drawer is not open
-(void)contactWasTapped :(MarcoPoloCell *)myCell :(NSIndexPath*)cellPath
{
    if( [myCell isUtilityButtonsHidden])
    {
         marcoCount++;

            [self addContactToMarco:cellPath];
    }
    else
    {
         [myCell hideUtilityButtonsAnimated:YES];
    }
}

//i want to marco somebody. If the slider part is open we do not trigger the function but instead just close the drawer
-(void)cellForMarco :(MarcoPoloCell *)myCell :(NSIndexPath*)cellPath
{
    if( [myCell isUtilityButtonsHidden])
    {
        //adds another marco to the list
        marcoCount++;
        NSMutableArray *arr = [informationHolder objectAtIndex:cellPath.section];
        NSMutableDictionary *dict = [arr objectAtIndex:cellPath.row];
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:cellPath];
        [((MarcoPoloCell *)cell)  marcoWasTapped:dict];
        [self moveContactToMarco:cellPath];
    }
    else
    {
        [myCell hideUtilityButtonsAnimated:YES];
    }
    
}
//if the drawer is not open we send them a polo
-(void)cellForPolo :(MarcoPoloCell *)myCell :(NSIndexPath*)cellPath
{
    if( [myCell isUtilityButtonsHidden])
    {
        //adds another polo to the count
        poloCount++;
        NSMutableArray *arr = [informationHolder objectAtIndex:cellPath.section];
        NSMutableDictionary *dict = [arr objectAtIndex:cellPath.row];
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:cellPath];
        [((MarcoPoloCell *)cell)  poloWasTapped:dict];
        [self moveContactToMarco:cellPath];
    }
    else
    {
         [myCell hideUtilityButtonsAnimated:YES];
    }
}

//unblocks the person and brings them back into the friends list
-(void)unBlockPersonWasTapped:(MarcoPoloCell *)myCell:(NSIndexPath*)cellPath
{
    NSIndexPath *p = ((MarcoPoloCell *)myCell).myPath;
    NSMutableArray  *arr = [informationHolder objectAtIndex:p.section];
    NSMutableDictionary *dict = [arr objectAtIndex:p.row];
    [((MarcoPoloCell *)myCell) blockThisPerson:dict:NO];
    [self moveContactToFriends:p];


    
    
    
}


//-(BOOL)doesLetterAlreadyExist:(NSString *)letterToEvaluate;
//-(NSInteger)indexOfLetter:(NSString *)letterToEvaluate;
//-(NSMutableArray *)addLetterToArray:(NSString *)letterToAdd;


-(void)moveContactToFriends:(NSIndexPath*)path
{
    NSMutableArray *arr = [informationHolder objectAtIndex:[informationHolder count]-1];
    NSDictionary *dict = [arr objectAtIndex:path.row];
    NSString *username = [dict objectForKey:@"username"];
    NSLog(username);
    NSString *firstLetter = [username substringToIndex:1];
  
    resortHeaders *sorter = [[resortHeaders alloc]init];
    sorter.arrayToCheck  = headers;
    NSString *str = [firstLetter capitalizedString];
      NSLog(str);
    
   NSInteger doesArrayHeaderExist = [sorter doesLetterAlreadyExist:str];
   // NSInteger doesArrayHeaderExist = [headers indexOfObject:str];
   // NSLog(@"%ld",(long)doesArrayHeaderExist);
    if(doesArrayHeaderExist < 100)
    {
        NSLog(@"its there");
        
        
        //dictionary of blocked
        NSMutableArray *mA = [informationHolder objectAtIndex:path.section];
        NSMutableDictionary *origDict = [mA objectAtIndex:path.row];
        
        
        //inserts the object in the plo
        NSMutableArray *arr = [informationHolder objectAtIndex:doesArrayHeaderExist];
        [arr insertObject:origDict atIndex:0];
        
        
        //deleates the object in the marco
        NSMutableArray *oldarr = [informationHolder objectAtIndex:path.section];
        [oldarr removeObjectAtIndex:path.row];
        
        
        //the old path to go from
        NSIndexPath *origPath = [NSIndexPath indexPathForRow:path.row  inSection:path.section];
        NSArray *deleteArray = [[NSArray alloc]init];
        deleteArray = @ [origPath];
        
        //the new path to go into
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:doesArrayHeaderExist];
        NSArray *insertArray = [[NSArray alloc]init];
        insertArray = @ [newPath];
        
        //remove the old index bring in the new
        [self.tableVIew beginUpdates];
        [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableVIew endUpdates];
        [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
     
        
    }
    else
    {
        NSMutableArray *newHeaders = [sorter addLetterToArray:str];
        [headers removeAllObjects];
         headers = newHeaders;
        
        
        NSInteger ai = [headers indexOfObject:str];
  
        //what this does is creates an array because right now one does not exist so we can not properly place an item so we make a new one to accoutn for the new letter
        //crucia
        NSMutableArray *fakeArray = [[NSMutableArray alloc]init];
        [informationHolder insertObject:fakeArray atIndex:ai];
        [self.tableVIew reloadData];
        
        NSLog(@" the index is %ld",(long)informationHolder.count);
        
        //dictionary of blocked
        NSMutableArray *mA = [informationHolder objectAtIndex:[informationHolder count]-1];
        NSMutableDictionary *origDict = [mA objectAtIndex:path.row];
        
  
        
        //inserts the object in the plo
         NSMutableArray *arr = [informationHolder objectAtIndex:ai];
        [arr insertObject:origDict atIndex:0];
        
        
        
        //deleates the object in the marco
        NSMutableArray *oldarr = [informationHolder objectAtIndex:[informationHolder count]-1];
        [oldarr removeObjectAtIndex:path.row];
        
        
        //the old path to go from
        NSIndexPath *origPath = [NSIndexPath indexPathForRow:path.row  inSection:[informationHolder count]-1];
        NSArray *deleteArray = [[NSArray alloc]init];
        deleteArray = @ [origPath];
        
        //the new path to go into
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:ai];
        NSArray *insertArray = [[NSArray alloc]init];
        insertArray = @ [newPath];
        
        //remove the old index bring in the new
        [self.tableVIew beginUpdates];
        [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableVIew endUpdates];
 
           NSLog(@"%@",[informationHolder objectAtIndex:[informationHolder count]-2]);
           NSLog(@"%lu",(unsigned long)[informationHolder count]);
        [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
        
        [self.tableVIew setNeedsDisplay];
    }
    
    
    
    
    
}


//end marco polo cell delegate






-(void)doRefresh
{
    [self.refresh beginRefreshing];
    [self.refresh startAnimation];
    [self refreshMarcoPolos];
}

-(void)doRefreshTwo
{
     [self.refresh startAnimation];
        [self refreshMarcoPolos];
  
}



//instead of moving the marco we duplicate it from the push noti because we got one
-(void)duplicateMarco:(NSMutableDictionary *)dict
{
    [self.tableVIew setScrollEnabled:NO];
    //gets the username of the object we want to move to marcos.
    NSString *username = [dict objectForKey:@"username"];
    NSLog(username);
    ///the index of that person in the marco array
    NSInteger mIndex = [self getmarcoAtIndex:username];
    //we do not exist in the marcos table already. but if we do we get the index creat a new path and just move the marco up
    //this now checks if we are in polos too because if we are we want to polo someone back and put them back in
    NSInteger poloIndex = [self getPoloAtIndex:username];
    NSInteger friendIndex = [self getUserFromFriendsList:username];
    //yes in marco
    
  //if we have a match in the letters
    if(friendIndex != -1)
    {
        
        //THEY ARE IN OUR FRIENDS SO WE DO NOT HAVE TO DO THE "ADD FRIEND ALGORITHM. HOWEVER.WE DO HAVE TOCEHCK IF THEY ARE IN OUR MARCO/POLO LIST. IF THEY ARE... WE ARE GOING TO JUST MOVE THEM TO THE APPROPIATE SECTION
        //IF THEY ARE NTO WE ARE GOING TO FIND THEM IN THE FRIENDS AND THEN WE ARE GOING TO DUPLICATE THE OBJECT
        if(mIndex != -1)
        {
            //dictionary of marco
            NSMutableArray *mA = [informationHolder objectAtIndex:1];
            NSMutableDictionary *origDict = [mA objectAtIndex:mIndex];

      
            //inserts the object in the plo
            NSMutableArray *arr = [informationHolder objectAtIndex:0];
            [arr insertObject:origDict atIndex:0];
            
            
            //deleates the object in the marco
             NSMutableArray *oldarr = [informationHolder objectAtIndex:1];
            [oldarr removeObjectAtIndex:mIndex];

           
            //the old path to go from
            NSIndexPath *origPath = [NSIndexPath indexPathForRow:mIndex inSection:1];
            NSArray *deleteArray = [[NSArray alloc]init];
            deleteArray = @ [origPath];
            
            //the new path to go into
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *insertArray = [[NSArray alloc]init];
            insertArray = @ [newPath];
            
            //remove the old index bring in the new
            [self.tableVIew beginUpdates];
                [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
                [self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
            [self.tableVIew endUpdates];
          
            
            [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];

        }
        else if(poloIndex != -1)
        {
            //dictionary of marco
            NSMutableArray *mA = [informationHolder objectAtIndex:0];
            NSMutableDictionary *origDict = [mA objectAtIndex:poloIndex];
            
            
            NSIndexPath *np = [NSIndexPath indexPathForRow:poloIndex inSection:0];
 
            //since we are already at the correct section, lets just move it to the top and call it  aday
            [self moveContactToPolo:np];
            //from here i want to remove the current index cell and then add it to the last section so we want to do fade animation
       
            ///same has to be done for marcos
            
            ///after that make sure the polo stuff works from active in app
            
            //after that then do all blocking and delete operations
            
        }
        else
        {
            //THE FRIEND EXISTS SO NOW WE MOVE TO THE POLO SECTION BECAUSE SOMEONE MARCO'D US
            NSInteger indexInSection =  [self getindexWithinFriendarray:friendIndex:username];
            
            NSLog(@"%ld",(long)indexInSection);
            //the array of the friend
            NSMutableArray *mA = [informationHolder objectAtIndex:friendIndex];
            NSMutableDictionary *origDict = [mA objectAtIndex:indexInSection];
            //the dictionary of the laetter index
            
            //marco dict
            NSMutableArray *arr = [informationHolder objectAtIndex:0];
            [arr insertObject:origDict atIndex:0];
            //end marco dict
            
            [self.tableVIew beginUpdates];
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *insertArray = [[NSArray alloc]init];
            insertArray = @ [newPath];
            [self.tableVIew insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationFade];
            [self.tableVIew endUpdates];
            [self performSelector:@selector(fixTable) withObject:nil afterDelay:0.6];
        
          }
    }
    else
    {
        //goiung to have to add this user to friends TODO JAN 8
    }
    
    
    
    
 
}


//removes the person from the marcos and polos list because they are going to be blocked
-(void)removeFromMarcoPolos:(NSDictionary *)dict
{
    NSString *username = [dict objectForKey:@"username"];
    
    NSInteger mIndex = [self getmarcoAtIndex:username];
    //we do not exist in the marcos table already. but if we do we get the index creat a new path and just move the marco up
    //this now checks if we are in polos too because if we are we want to polo someone back and put them back in
    NSInteger poloIndex = [self getPoloAtIndex:username];
    
    if(poloIndex != -1)
    {
        NSMutableArray *arr = [informationHolder objectAtIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:poloIndex inSection:0];
        NSArray *deleteArray = [[NSArray alloc]init];
        deleteArray = @ [path];
        [arr removeObjectAtIndex:poloIndex];
        [self.tableVIew beginUpdates];
        [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableVIew endUpdates];

        
    }
    
    if(mIndex != -1)
    {
        NSMutableArray *arr = [informationHolder objectAtIndex:1];
        NSIndexPath *path = [NSIndexPath indexPathForRow:mIndex inSection:1];
        NSArray *deleteArray = [[NSArray alloc]init];
        deleteArray = @ [path];
        [arr removeObjectAtIndex:mIndex];
        [self.tableVIew beginUpdates];
        [self.tableVIew deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [self.tableVIew endUpdates];
        
        
        
    }
    
    
    
}





//pull to refresh functionality
-(void)refreshMarcoPolos
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id  = [defaults objectForKey:@"user_id"];
    
    //   NSLog([NSString stringWithFormat:@"%@",[peopleContacts componentsJoinedByString:@","]]);
    
    NSDictionary *params = @{
                             @"user_id": [NSString stringWithFormat:@"%@",user_id],
                             @"lat": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude]],
                             @"lng": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]],
                             };
    
    // NSLog([NSString stringWithFormat:@"%@",[peopleNames componentsJoinedByString:@","]]);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/updateList.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *results = responseObject[@"results"];
        
        [informationHolder removeAllObjects];
        [headers removeAllObjects];
        [headers addObject:@"polos"];
        [headers addObject:@"recent"];
        
        
        
        
        
        for(NSDictionary *dict in results)
        {
            //inits the placeholderarays
            NSMutableArray *polos = [dict objectForKey:@"polos"];
            NSMutableArray *marcos = [dict objectForKey:@"marcos"];
            NSMutableArray *blocked = [dict objectForKey:@"blocked"];
            
            
             //takes all the polos and puts them into a mutable arrayh
            NSMutableArray *polosNew = [[NSMutableArray alloc]init];
            for(NSMutableDictionary *dict in polos)
            {
                [polosNew addObject:dict];
            }
            
            
            //takes all the marcos and puts them into a mutable arrayh
            NSMutableArray *marcosNew = [[NSMutableArray alloc]init];
            for(NSMutableDictionary *dict in marcos)
            {
                [marcosNew addObject:dict];
            }
            
            
            //gets the amount of marcos and polos we made and sets them to our globals to pass to the settings obj.
            NSMutableDictionary *mpcount = [dict objectForKey:@"mp"];
            NSInteger mpCount = [[mpcount objectForKey:@"marcos"]intValue];
            NSInteger pc = [[mpcount objectForKey:@"polos"]intValue];
            marcoCount = mpCount;
            poloCount = pc;
            //end
            
            //the main array then holds all the new data
            [informationHolder addObject:polosNew];
            [informationHolder addObject:marcosNew];
            
            
            NSMutableDictionary *friends = [dict objectForKey:@"friends"];
            if(![friends objectForKey:@"empty"])
            {
                NSArray *arr =  [[friends allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
                
                int i = 0;
                for(NSString *key in arr)
                {
                    NSMutableArray *ar = [friends objectForKey:key];
                    NSMutableArray *temp = [[NSMutableArray alloc]init];
                    
                    for(NSDictionary *dict in ar)
                    {
                        [temp addObject:dict];
                    }
                    
                    [informationHolder addObject:temp];
                    [headers addObject:key];
                    i++;
                }
            }
            NSMutableArray *blockednew = [[NSMutableArray alloc]init];
            for(NSMutableDictionary *d in blocked)
            {
                [blockednew addObject:d];
            }
            
            [informationHolder addObject:blockednew];
            [headers addObject:@"blocked"];
         
        }
        
    
        [self.tableVIew reloadData];
        [self endTheRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endTheRefresh];
        [self hideHud];
    }];
    

}

//ends a refresh
-(void)endTheRefresh
{
    [self.refresh endRefreshing];
    [self.refresh stopAnimation];
}


//add user delegate

//checks if a random user from the search is some how alread in the marcos section. if it is it igores
//if it is not in it will add it in the first row and marco them

-(void)addRandomToMarcos:(NSMutableDictionary *)dict
{
    NSString *username = [dict objectForKey:@"username"];
    
     NSInteger mIndex = [self getmarcoAtIndex:username];
    
    if(mIndex == -1)
    {
        NSMutableArray *ar = [informationHolder objectAtIndex:1];
        [ar insertObject:dict atIndex:0];
        [self.tableVIew reloadData];
        
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:1];
        UITableViewCell   *cell = [self.tableVIew cellForRowAtIndexPath:newPath];
        [((MarcoPoloCell *)cell)  marcoWasTapped:dict];
        
    }
 
    else {
       
    }
}

//end add user delegate
//allows for multiple gesutre recgonizers
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleSize = 55.0f;
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
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


//app  delegate  delegate
-(void)sendData:(NSDictionary *)obj:(NSString * )alertType:(NSString *)message
{
    UIApplication *application = [UIApplication sharedApplication];
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        //if user marcos me
        if([alertType isEqualToString:@"marco"])
        {
      // [self.tableVIew setContentOffset:CGPointMake(0, 0) animated:YES];
            [self duplicateMarco:obj];
            
            
            //TODO NEXT  1-8 HAVE OT MAKE SURE IF THE USER IS ONLY A FRIEND WE MOVE TO THE RGHT POS
        }
        else if([alertType isEqualToString:@"polo"])
        {

            NSString *userSent = [obj objectForKey:@"username"];
            NSString *created= [obj objectForKey:@"date"];
            NSString *lat = [obj objectForKey:@"lat"];
            NSString *lng = [obj objectForKey:@"lng"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *mylat = [defaults objectForKey:@"lat"];
            NSString *mylng = [defaults objectForKey:@"lng"];
            //gets the marco at the index by username
            NSInteger mIndex = [self getmarcoAtIndex:userSent];
            if(mIndex != -1)
            {
                //if we find the user in the marco field we want to get the lat and long and get its distance so we can put it in the distance filed. we then want to
                //move it to the top of the cell.
                NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:mIndex inSection:1];
                UITableViewCell  *cell = [self.tableVIew cellForRowAtIndexPath:myIndexPath];
                //gets the distance and the direction
                CLLocation *myLoc = [[CLLocation alloc] initWithLatitude:[mylat doubleValue] longitude:[mylng doubleValue]];
                CLLocation *poloLoc = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
                getDistance *d = [[getDistance alloc]init];
                NSString *dist = [d getDistanceFromTwoPoints:myLoc:poloLoc];
                NSString *direction = [d getDirectionFromLocation:myLoc toCoordinate:poloLoc];
                //turns created string into date
                NSString *dateString = created;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // this is imporant - we set our input date format to match our input string
                // if format doesn't match you'll get nil from your string, so be careful
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dateFromString = [[NSDate alloc] init];
                // voila!
                dateFromString = [dateFormatter dateFromString:dateString];
                timeAgo *ta = [[timeAgo alloc]init];
                NSString *longAgo = [ta timeAgo:dateFromString];
                
                NSString *goesInDesc = [NSString stringWithFormat:@"%@ %@ Miles %@",direction,dist,longAgo];
                [((MarcoPoloCell *)cell).distanceLabel setText:goesInDesc];
                
                NSMutableArray *ar = [informationHolder objectAtIndex:1];
                NSMutableDictionary *dict = [ar objectAtIndex:mIndex];
                NSMutableDictionary  *mydict = [dict mutableCopy];
                [mydict setObject:[NSString stringWithFormat:@"%@ Miles",dist] forKey:@"distance"];
                [mydict setObject:direction forKey:@"direction"];
                [mydict setObject:longAgo forKey:@"created"];
                //replaces the object at the index so we can put the distance and direction dynamically.
                [ar replaceObjectAtIndex:mIndex withObject:mydict];
                
                //moves the user to the top of the marco
                [self moveContactToMarco:myIndexPath];
                
            }
            
            [self updateMarco:obj];
        }
        
    }
}
///

//reloads the data and lets you scroll
-(void)fixTable
{
    [self.tableVIew reloadData];
    [self.tableVIew setScrollEnabled:YES];
}



//shows alert

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


@end
