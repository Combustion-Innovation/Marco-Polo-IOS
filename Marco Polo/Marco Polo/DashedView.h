///Users/danielnasello/Desktop/ios practice/Marco Polo/Ma/Users/danielnasello/Desktop/ios practice/Marco Polo/Marco Polo/DashedView.hrco Polo/DashedView.h
//  DashedView.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashedView : UIView
-(void)initMyView;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
-(void)toggleMarching;
@property(nonatomic,assign)NSInteger myin;
@property(nonatomic,strong)NSTimer *mytimer;
-(void)comeIn;
-(void)comeOut;
@end
