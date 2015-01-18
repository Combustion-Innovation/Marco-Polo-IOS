//
//  SignupDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignupDelegate <NSObject>

-(void)signupWasSuccessful:(NSString*)username:(NSString *)password;

-(void)signupWasCanceled;


@end
