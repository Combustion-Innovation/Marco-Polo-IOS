//
//  toggleButtons.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "toggleButtonDelegate.h"

@interface toggleButtons : UIView{
    id<toggleButtonDelegate>delegate;
}

@property (nonatomic,weak)id delegate;
@property(nonatomic,retain)NSMutableArray *toggleButtons;
@property(nonatomic,assign)int currentSelected;
-(void)toggleMyButton:(NSInteger)selectedValue;

@end
