//
//  loginDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol loginDelegate <NSObject>

-(void)loginWasSuccessful;
-(void)loginWasCanceled;


@end
