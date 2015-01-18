//
//  CutOutView.m
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "CutOutView.h"

@implementation CutOutView


//creates fourViews that will surround the bounds of the box
-(void)createSubViews
{
    
    [self setClipsToBounds:YES];
    
    self.isEnabled = YES;
    
    
    
    self.alternate = [[UIColor alloc]init];
    
    self.mainColor = self.backgroundColor;
    self.isOpen = NO;
    
    self.l= [[UILabel alloc]initWithFrame:self.bounds];
    [self.l setTextColor:[UIColor whiteColor]];
    [self.l setTextAlignment:NSTextAlignmentCenter];
    [self.l  setFont:[UIFont fontWithName:@"GillSans" size:80.0f]];
    [self addSubview:self.l];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedbutton)];
    singleTap.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:singleTap];
    
    
    
    self.topView = [[DashedView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.topView initMyView];
    [self addSubview:self.topView];
  //   self.topView.layer.anchorPoint = CGPointMake(.6,0);
    

   /* self.leftView = [[DashedView alloc]initWithFrame:CGRectMake(0, 0, 10,self.frame.size.height)];
    [self.leftView initMyView];
    [self addSubview:self.leftView];
     self.leftView.layer.anchorPoint = CGPointMake(.5,.5);
    
    
    self.rightView = [[DashedView alloc]initWithFrame:CGRectMake(self.frame.size.width-10, 0, 10,self.frame.size.height)];
    [self.rightView initMyView];
    [self addSubview:self.rightView];
     self.topView.layer.anchorPoint = CGPointMake(1,1);
    
    self.bottomView = [[DashedView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-10,self.frame.size.width,10)];
    [self.bottomView initMyView];
    [self addSubview:self.bottomView];
     self.topView.layer.anchorPoint = CGPointMake(0,0);*/
    
   // [self.topView setFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width,10)];
  //  [self.leftView setFrame:CGRectMake(0, -self.frame.size.height-10, 10,self.frame.size.height)];
  //  [self.rightView setFrame:CGRectMake(self.frame.size.width-10, self.frame.size.height+10, 10,self.frame.size.height)];
 //   [self.bottomView setFrame:CGRectMake(self.frame.size.width,self.frame.size.height-10,self.frame.size.width,10)];
    
    
    
   /* [self.topView setFrame:CGRectMake(0, 0, 0,10)];
    [self.leftView setFrame:CGRectMake(0,self.frame.size.height-10, 10,0)];
    [self.rightView setFrame:CGRectMake(self.frame.size.width-10, 0, 10,0)];
    [self.bottomView setFrame:CGRectMake(self.frame.size.width,self.frame.size.height-10,0,10)];
    
          [self.topView setFrame:CGRectMake(0, 0, self.frame.size.width,10)];
       [self.leftView setFrame:CGRectMake(0, 0, 10,self.frame.size.height)];
       [self.rightView setFrame:CGRectMake(self.frame.size.width-10, 0, 10,self.frame.size.height)];
       [self.bottomView setFrame:CGRectMake(0,self.frame.size.height-10,self.frame.size.width,10)];*/

    


     self.topView.shapeLayer.lineDashPhase = 022.0f;
}
//opens a scisscor effect on the views
-(void)selectBox
{
    
}

//closes the scissor effect on the view.
-(void)deselectBox
{
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //what I should do ????
    if(self.isEnabled)
    {
        [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                        [self setBackgroundColor:self.mainColor];
                     }completion:^(BOOL finished) {
                         
                         
                     }];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(self.isEnabled)
    {
        [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                       //  [self.l setTextColor:[UIColor whiteColor]];
                         [self setBackgroundColor:self.mainColor];
                     }completion:^(BOOL finished) {
                         
                     }];
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isEnabled)
    {
        [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                               [self setBackgroundColor:self.alternate];
                     }completion:^(BOOL finished) {
                         
                     }];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



-(void)tappedbutton
{
    if(self.isEnabled && !self.isOpen)
    {
        self.isOpen = YES;
        self.isEnabled = NO;
        [self.delegate buttonSelectAnimationHasStarted:self.tag];
        
       // [self.topView comeIn];
       // [self.leftView comeIn];
       // [self.rightView comeIn];
       // [self.bottomView comeIn];
        
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                        
                        

                             
                             
                       //      [self.topView setFrame:CGRectMake(0, 0, self.frame.size.width,10)];
                          //   [self.leftView setFrame:CGRectMake(0, 0, 10,self.frame.size.height)];
                          //   [self.rightView setFrame:CGRectMake(self.frame.size.width-10, 0, 10,self.frame.size.height)];
                          //   [self.bottomView setFrame:CGRectMake(0,self.frame.size.height-10,self.frame.size.width,10)];
                             self.alpha = 1;
                            
                         }completion:^(BOOL finished) {
                           
                        }];

        [self performSelector:@selector(selectHasEnded) withObject:nil afterDelay:0.2];
    }
      [self.l setTextColor:[UIColor whiteColor]];
    
    
}



-(void)resetButton
{
    if(self.isOpen)
    {
        
    
            self.isOpen = NO;
                    //      [self.delegate buttonDeselectAnimationHasStarted:self.tag];
        [UIView animateWithDuration:0.3
                              delay:0.5
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                                  [self setBackgroundColor:self.mainColor];
   
                             
                             self.alpha = 1;
                         }completion:^(BOOL finished) {
                            
                         }];

        
                [self performSelector:@selector(deselectHasEnded) withObject:nil afterDelay:0.2];

        
    }
    else
    {
        self.isEnabled = YES;
    }
    
    
    
    
    
}


-(void)deselectHasEnded
{
    
      [self performSelector:@selector(deselectHasEnded) withObject:nil afterDelay:0.5];
}


-(void)deselectReallyEnded
{
    [self.delegate buttonDeselectAnimationHasEnded:self.tag];
    self.isEnabled = YES;
}


-(void)selectHasEnded
{
      [self.delegate buttonSelectAnimationHasEnded:self.tag];
}

@end
