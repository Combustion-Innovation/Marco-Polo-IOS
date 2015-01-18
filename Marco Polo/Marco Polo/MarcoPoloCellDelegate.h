//
//  MarcoPoloCellDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/22/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
@class  MarcoPoloCell;
#import <Foundation/Foundation.h>
@protocol MarcoPoloCellDelegate <NSObject>
-(void)cellWasTapped:(MarcoPoloCell*)myCell:(NSIndexPath*)cellsPath;
-(void)cellWasInvited:(MarcoPoloCell *)myCell:(NSIndexPath *)cellPath;
-(void)cellWasRandomMarco:(MarcoPoloCell *)myCell:(NSIndexPath *)cellPath;
-(void)contactWasTapped:(MarcoPoloCell *)myCell:(NSIndexPath*)cellPath;
-(void)cellForMarco:(MarcoPoloCell *)myCell:(NSIndexPath*)cellPath;
-(void)cellForPolo:(MarcoPoloCell *)myCell:(NSIndexPath*)cellPath;
-(void)unBlockPersonWasTapped:(MarcoPoloCell *)myCell:(NSIndexPath*)cellPath;

@end
