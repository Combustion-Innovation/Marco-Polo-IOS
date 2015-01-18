//
//  SBtwo.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/14/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "SBtwo.h"

@implementation SBtwo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor *pressColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] /*#000000*/;
        [self setBackgroundImage:[self imageWithColor:pressColor] forState:UIControlStateHighlighted];

    }
    return self;
}


-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
