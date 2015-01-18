//
//  ChangePreferencesManager.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/1/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface ChangePreferencesManager : NSObject
-(void)changePreferences:(NSDictionary *)preferences;

@end
