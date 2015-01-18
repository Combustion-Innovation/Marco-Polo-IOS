//
//  CutoutDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CutoutDelegate <NSObject>
-(void)buttonSelectAnimationHasStarted:(NSInteger)index;
-(void)buttonDeselectAnimationHasStarted:(NSInteger)index;
-(void)buttonSelectAnimationHasEnded:(NSInteger)index;
-(void)buttonDeselectAnimationHasEnded:(NSInteger)index;



@end

