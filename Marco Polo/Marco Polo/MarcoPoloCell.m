//
//  MarcoPoloCell.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/22/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "MarcoPoloCell.h"

@implementation MarcoPoloCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.width = [[UIScreen mainScreen] bounds].size.width;
             [self createSubviews];
        
     
        
    }
    return self;
}







-(void)createSubviews
{
    [self setClipsToBounds:YES];
    self.canCLick =YES;
    
   //main label
     self.mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 80)];
    [self.mainLabel setTextColor:[UIColor whiteColor]];
    [self.mainLabel setFont: [UIFont fontWithName:@"Avenir-Light" size:35.0f]];
    [self.contentView addSubview:self.mainLabel];
    [self.mainLabel setTextAlignment:NSTextAlignmentCenter];
    
   

    
    //sub label
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, self.width-5, 19)];
    [self.descriptionLabel setTextColor:[UIColor whiteColor]];
    [self.descriptionLabel setTextAlignment:NSTextAlignmentRight];
    [self.descriptionLabel setFont: [UIFont fontWithName:@"GillSans" size:13.0f]];
    [self.contentView addSubview:self.descriptionLabel];
    
    
    
    //distance
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, self.width-15, 17)];
    [self.distanceLabel setTextColor:[UIColor whiteColor]];
    [self.distanceLabel setFont: [UIFont fontWithName:@"GillSans" size:11.0f]];
    [self.contentView addSubview:self.distanceLabel];
    

    
  //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
  //  [self addGestureRecognizer:tap];
  //  tap.delegate = self;
    
    
    
    self.coverButton   = [[SBtwo alloc]initWithFrame:CGRectMake(0, 0, self.width, 80)];
    [self.coverButton addTarget:self
               action:@selector(viewWasTapped)
     forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.coverButton];

    
}





-(void)fixForContacts
{
     [self.mainLabel setFrame:CGRectMake(0, 0, self.width, 70)];
      [self.mainLabel setFont: [UIFont fontWithName:@"Avenir-Light" size:28.0f]];
    // [self.descriptionLabel setFrame:CGRectMake(0, 39, self.width-7, 30)];
     [self.distanceLabel setFrame:CGRectMake(10, 52, self.frame.size.width, 22)];
    // [self.distanceLabel setFont: [UIFont fontWithName:@"GillSans" size:11.0f]];
     [self.distanceLabel setFont: [UIFont fontWithName:@"GillSans" size:9.0f]];
     [self.descriptionLabel setFrame:CGRectMake(0, 52, self.width-17, 19)];
    [self.coverButton setFrame:   CGRectMake(0, 0, self.width, 70)];
}


-(void)viewWasTapped
{

    if(self.canCLick)
    {
    
    switch (self.cellType) {
        case 0:
            [self poloMe];
            break;
        case 1:
            [self marcoMe];
            break;
        case 2:
            [self addRowToMarcos];
            break;
        case 3:
            [self unBlockPerson];
            break;
        case 4:
            [self inviteUser];
            break;
        case 5:
            [self doRandomMarco];
            break;
        default:
            break;
    }
        self.canCLick = NO;
        [self performSelector:@selector(reEnableClicking) withObject:nil afterDelay:1.0];
    }

}



//polo me
-(void)poloMe
{
    [self.delegate cellForPolo:self :self.myPath];
}

//time to marco someone
-(void)marcoMe
{
    [self.delegate cellForMarco:self :self.myPath];
}


//the contacts cell has been pressed so it has to go to marcos cell
-(void)addRowToMarcos
{
    [self.delegate contactWasTapped:self :self.myPath];
}


//person is in the block list and now i want to block them
-(void)unBlockPerson
{
    [self.delegate unBlockPersonWasTapped:self: self.myPath];
}


// this is when we want to invite somebody from our phone book because they are in our phone book but do not have the app
-(void)inviteUser
{
    [self.delegate cellWasInvited:self :self.myPath];
}


//this is when we search somebody by username or phone number and we want to send them a marco
-(void)doRandomMarco
{
    [self.delegate cellWasRandomMarco:self :self.myPath];
}

//sends invitation status to server

-(void)sendInviteStatus:(NSMutableDictionary *)dict
{
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self setBackgroundColor:[UIColor grayColor]];
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options:UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              [self setBackgroundColor:self.myColor];
                                          }completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *phone = [dict objectForKey:@"phone"];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    
    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"phone":[NSString stringWithFormat:@"%@",phone],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/inviteFriend.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        //      [self.delegate didLogin];
        
    }];
    


}



-(void)marcoWasTapped:(NSDictionary *)dict
{
    [self performSelector:@selector(setTextToMarco) withObject:nil afterDelay:1.0];
    [self.descriptionLabel setText:@"MARCO SENT!"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sendee_id = [dict objectForKey:@"user_id"];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    NSString *lat = [defaults objectForKey:@"lat"];
    NSString *lng = [defaults objectForKey:@"lng"];
    
    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"sendee_id":[NSString stringWithFormat:@"%@",sendee_id],
                             @"lat":[NSString stringWithFormat:@"%@",lat],
                             @"lng":[NSString stringWithFormat:@"%@",lng],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/marcoWasClicked.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

 
        
    }];
    
   
}


-(void)poloWasTapped:(NSDictionary *)dict
{
    [self performSelector:@selector(setTextToMarco) withObject:nil afterDelay:1.0];
    [self.descriptionLabel setText:@"POLO SENT!"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sendee_id = [dict objectForKey:@"user_id"];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    NSString *lat = [defaults objectForKey:@"lat"];
    NSString *lng = [defaults objectForKey:@"lng"];
    NSString *m_id  = [dict objectForKey:@"marco_id"];
    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"sendee_id":[NSString stringWithFormat:@"%@",sendee_id],
                             @"lat":[NSString stringWithFormat:@"%@",lat],
                             @"lng":[NSString stringWithFormat:@"%@",lng],
                             @"marco_id":[NSString stringWithFormat:@"%@",m_id],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/poloWasClicked.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    
}


//blocks a person so they cannot send you marcos or polos
-(void)blockThisPerson:(NSMutableDictionary *)dict:(BOOL)isBlocking
{
    if(isBlocking)
    {
        [self performSelector:@selector(setTextToBlock) withObject:nil afterDelay:1.0];
        [self.descriptionLabel setText:@"BLOCKED!"];
    }
    else
    {
        [self performSelector:@selector(setTextToMarco) withObject:nil afterDelay:1.0];
        [self.descriptionLabel setText:@"UNBLOCKED!"];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sendee_id = [dict objectForKey:@"user_id"];
    NSString *user_id = [defaults objectForKey:@"user_id"];

    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"blocked":[NSString stringWithFormat:@"%@",sendee_id],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/blockUser.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}



//sets the text back to marco after we have marco'd someone
-(void)setTextToMarco
{
     [self.descriptionLabel setText:@"MARCO"];
}
-(void)setTextPolo
{
    [self.descriptionLabel setText:@"POLO"];
}
-(void)setTextToBlock
{
    [self.descriptionLabel setText:@"UNBLOCK"];
}

//sets the cell height
-(void)setCellHeight:(float)cellHeight
{
    CGRect rect = self.frame;
    rect.size.height = cellHeight;
    
    self.frame = rect;
}

//re-enables the ability to click on the cell again
-(void)reEnableClicking
{
    self.canCLick = YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
