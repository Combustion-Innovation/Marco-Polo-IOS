//
//  SpecialTextField.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "SpecialTextField.h"

@implementation SpecialTextField



-(void)setFields
{
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = YES;
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    [self setBorderStyle:UITextBorderStyleNone];
    
    [self setNeedsDisplay];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setTextColor:[UIColor whiteColor]];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 45)];
    
     self.clipsToBounds = YES;
    [self.layer addSublayer: [self addDashedBorderWithColor:[UIColor whiteColor].CGColor]];
    [self hideShapeLayer];
    
}
-(void)setWhitePlaceholder :(NSString *)placeholderText :(UIColor *)color
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
}




- (CAShapeLayer *) addDashedBorderWithColor: (CGColorRef) color {
    self.shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = CGSizeMake(self.frame.size.width,self.frame.size.height );
    
    CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [self.shapeLayer setBounds:shapeRect];
    [self.shapeLayer setPosition:CGPointMake( frameSize.width/2,frameSize.height/2)];
    
    [self.shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.shapeLayer setStrokeColor:color];
    [self.shapeLayer setLineWidth:10.0f];
    [self.shapeLayer setLineJoin:kCALineJoinRound];
    [self.shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:30],
      [NSNumber numberWithInt:10],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:0.0];
    [self.shapeLayer setPath:path.CGPath];
    
    return self.shapeLayer;
}



-(void)setSpecialBackground:(UIColor *)color
{
    self.backgroundColor = color;
}


-(void)hideShapeLayer
{
    [self.shapeLayer setLineWidth:0.0f];
    
}


-(void)showShapeLayer
{
    // [self.shapeLayer setLineWidth:10.0f];
}

@end
