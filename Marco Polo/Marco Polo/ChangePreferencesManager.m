//
//  ChangePreferencesManager.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "ChangePreferencesManager.h"

@implementation ChangePreferencesManager


-(void)changePreferences:(NSDictionary *)preferences
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/marco/php/updateSettings.php" parameters:preferences success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}


@end
