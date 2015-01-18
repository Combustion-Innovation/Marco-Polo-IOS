//
//  DashedView.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "DashedView.h"

@implementation DashedView

-(void)initMyView
{
    self.clipsToBounds = YES;
   [self.layer addSublayer: [self addDashedBorderWithColor:[UIColor whiteColor].CGColor]];
    self.myin = 0;
     self.mytimer = nil;
   
}

- (CAShapeLayer *) addDashedBorderWithColor: (CGColorRef) color {
    self.shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = CGSizeMake(self.frame.size.width,self.frame.size.height );
    
    CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [self.shapeLayer setBounds:shapeRect];
    [self.shapeLayer setPosition:CGPointMake( frameSize.width/2,frameSize.height/2)];
    
    [self.shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [self.shapeLayer setStrokeColor:color];
    [self.shapeLayer setLineWidth:15.0f];
    [self.shapeLayer setLineJoin:kCALineJoinRound];
    [self.shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
      [NSNumber numberWithInt:0],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:0.0];
    [self.shapeLayer setPath:path.CGPath];
    self.alpha = 0;
    
    return self.shapeLayer;
}



-(void)comeIn
{
    if([self.mytimer isValid])
    {
         [self.mytimer invalidate];
         self.mytimer = nil;
    }
    
    [self setAlpha:1];
    self.myin = 0;
    self.mytimer =  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(on:) userInfo:nil repeats:YES];
    
}


 - (void)on:(NSSet *)set
{
    self.myin++;
    [self.shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:self.myin],
      [NSNumber numberWithInt:20],
      nil]];
    
    if(self.myin == 40)
    {
        [self.mytimer invalidate];
    }
}




-(void)comeOut
{
        if([self.mytimer isValid])
    {
        [self.mytimer invalidate];
        self.mytimer = nil;
    }

    self.myin = 40;
    self.mytimer =  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(off:) userInfo:nil repeats:YES];
    
}

- (void)off:(NSSet *)set
{
    self.myin--;
    [self.shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:self.myin],
      [NSNumber numberWithInt:20],
      nil]];
    
    if(self.myin == 0)
    {
        [self.mytimer invalidate];
        [self setAlpha:0];
    }
}



@end
