//
//  LoginManager.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "LoginManager.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"

@implementation LoginManager






-(void)login:(NSString *)username:(NSString*)password
{
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *pkey = appDelegate.pushId;
    
    NSLog(@"awesome %@",pkey);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *p  = [defaults objectForKey:@"pushkey"];
    
    NSString *whatIUse = @"";
    if(!pkey)
    {
        whatIUse = p;
    }
    else
    {
        whatIUse = pkey;
    }
    
    
    
    NSDictionary *params = @{
                             @"username":[NSString stringWithFormat:@"%@",username],
                             @"password":[NSString stringWithFormat:@"%@",password],
                             @"push_key":[NSString stringWithFormat:@"%@",whatIUse],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/phoneLogin.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        NSString *fname = responseObject[@"fname"];
        NSString *lname = responseObject[@"lname"];
        NSString *email = responseObject[@"email"];
        NSString *pic = responseObject[@"picture"];
        NSString *user_id = responseObject[@"user_id"];
        NSString *username = responseObject[@"username"];
        NSString *phone_number = responseObject[@"phone_number"];
        NSString *overall_score = responseObject[@"allScore"];
        NSString *overall_time = responseObject[@"allTime"];
        NSString *highest_rank = responseObject[@"rank"];
        NSString *best_score = responseObject[@"best_score"];
        NSString *best_game_time = responseObject[@"time_passed"];
        NSString *total_games = responseObject[@"totalGames"];
        NSString *total_wins = responseObject[@"wins"];
        NSString *total_losses = responseObject[@"lost"];
        NSString *best_game_played_date = responseObject[@"best_game_played_date"];
        NSString *push_notification = responseObject[@"push_notification"];
        NSString *private = responseObject[@"private"];
        NSString *searchable = responseObject[@"search"];
        NSString *exact_location = responseObject[@"exact_location"];
        NSString *unit = responseObject[@"unit"];

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:password forKey:@"password"];
        [defaults setObject:fname forKey:@"firstname"];
        [defaults setObject:lname forKey:@"lastname"];
        [defaults setObject:exact_location forKey:@"exact_location"];
        [defaults setObject:unit forKey:@"unit"];
        
        [defaults setObject:email forKey:@"email"];
        [defaults setObject:phone_number forKey:@"phone_number"];
        [defaults setObject:@"PUSH" forKey:@"logintype"];
        [defaults setObject:pic forKey:@"picture"];
        [defaults setObject:user_id forKey:@"user_id"];
        [defaults setObject:overall_score forKey:@"overall_score"];
        [defaults setObject:overall_time forKey:@"overall_time"];
        [defaults setObject:highest_rank forKey:@"highest_rank"];
        [defaults setObject:best_score forKey:@"best_score"];
        [defaults setObject:best_game_time forKey:@"best_game_time"];
        [defaults setObject:total_games forKey:@"total_games"];
        [defaults setObject:total_wins forKey:@"total_wins"];
        [defaults setObject:total_losses forKey:@"total_losses"];
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:best_game_played_date forKey:@"best_game_played_date"];
        [defaults setObject:push_notification forKey:@"push_notification"];
        [defaults setObject:private forKey:@"private"];
         [defaults setObject:searchable forKey:@"searchable"];
        [defaults synchronize];
        
        
        if ([status isEqualToString:@"one"])
        {
            
            [self.delegate PushUpdatedLogin:nil];
        }
        else
            
        {
            [self.delegate PushLoginError];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        //      [self.delegate didLogin];
        
        [self.delegate PushLoginError];
        
    }];
    
    
    
}





@end
