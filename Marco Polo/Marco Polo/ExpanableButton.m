//
//  ExpanableButton.m
//  Marco Polo
//
//  Created by Daniel Nasello on 12/19/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "ExpanableButton.h"

@implementation ExpanableButton


-(void)attach
{
    [self addTarget:self
               action:@selector(animateBig)
     forControlEvents:UIControlEventTouchDown];
  
   
    [self addTarget:self
             action:@selector(animateSmall)
   forControlEvents:UIControlEventTouchUpOutside];
    
    
    [self addTarget:self
             action:@selector(animateSmall)
   forControlEvents:UIControlEventTouchCancel];
    
    
    [self addTarget:self
             action:@selector(animateSmall)
   forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addTarget:self
             action:@selector(animateSmall)
   forControlEvents:UIControlEventTouchCancel];
}

-(void)animateBig
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.transform   = CGAffineTransformMakeScale(1.2, 1.2);
                     }completion:^(BOOL finished) {
                         
                     }];
}
-(void)animateSmall
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.transform   = CGAffineTransformMakeScale(1.0, 1.0);
                     }completion:^(BOOL finished) {
                         
                     }];
}



/*

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                     self.transform   = CGAffineTransformMakeScale(1.2, 1.2);
                     }completion:^(BOOL finished) {
                         
                     }];
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //what I should do ????
    NSLog(@"DD");
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                            self.transform   = CGAffineTransformMakeScale(1.0, 1.0);
                     }completion:^(BOOL finished) {
                         
                     }];
}


*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end
