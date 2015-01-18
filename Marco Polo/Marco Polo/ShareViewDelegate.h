//
//  ShareViewDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/11/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareViewDelegate <NSObject>
-(void)facebookButtonwasPressed;
-(void)twitterButtonWasPressed;
-(void)textmessageButtonWasPressed;
-(void)emailButtonWasPressed;

@end
