//
//  toggleButtonDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol toggleButtonDelegate <NSObject>
-(void)tabWasChanged:(NSInteger)index;
@end
