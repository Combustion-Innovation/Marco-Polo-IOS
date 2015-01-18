//
//  AddUserDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/19/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddUserDelegate <NSObject>

-(void)userWasInvited:(NSMutableDictionary *)dict:(NSIndexPath*)path:(NSString *)key;
-(void)addRandomToMarcos:(NSMutableDictionary *)dict;
@end
