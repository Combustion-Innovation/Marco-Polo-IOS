//
//  CustomControl.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/7/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>
#import "CustomControl.h"

@implementation CustomControl


-(void)addSpecial
{
    
 
    UIImageView *fakeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sc"]];
    
    [self.animationView setFrame:CGRectMake(0, 0, 40, 40)];
    
    fakeView.center = self.center;
    
    [self addSubview:fakeView];
    
    
    self.animationView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dline"]];
    
    [self.animationView setFrame:CGRectMake(0, 0, 40, 40)];
    
    self.animationView.center = self.center;
    
  //  [self addSubview:self.animationView];
    
    
   // [self addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    self.animateViews = [[NSMutableArray alloc]init];
    self.animateHolder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*2)];
    [self addSubview:self.animateHolder];
            [self.animateHolder setFrame:CGRectMake(-self.frame.size.width, 0,self.frame.size.width , self.animateHolder.frame.size.height)];
    [self createLittleViews];
    
}

-(void)createLittleViews
{
    NSArray *viewColors = [[NSArray alloc]init];
    viewColors = @[
                    [UIColor colorWithRed:0.204 green:0.282 blue:0.349 alpha:1] /*#344859*/,
                    [UIColor colorWithRed:0.247 green:0.329 blue:0.4 alpha:1] /*#3f5466*/,
                    [UIColor colorWithRed:0.259 green:0.784 blue:0.443 alpha:1] /*#42c871*/,
                    [UIColor colorWithRed:0.302 green:0.902 blue:0.518 alpha:1] /*#4de684*/,
                    [UIColor colorWithRed:0.239 green:0.573 blue:0.745 alpha:1] /*#3d92be*/,
                    [UIColor colorWithRed:0.29 green:0.663 blue:0.855 alpha:1] /*#4aa9da*/,
                    [UIColor colorWithRed:0.737 green:0.204 blue:0.216 alpha:1] /*#bc3437*/,
                    [UIColor colorWithRed:0.871 green:0.282 blue:0.294 alpha:1] /*#de484b*/,
                 
        
                 
                
                 
               
                  
                   ];
    
    NSInteger wid = self.frame.size.width / [viewColors count];
    NSInteger h = self.frame.size.height;
    int i = 0;
    for(UIColor *color in viewColors)
    {
        UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(-wid * i, 0, wid, h)];
        [smallView setBackgroundColor:color];
        [self.animateViews addObject:smallView];
        [self.animateHolder addSubview:smallView];
        i++;
        
    }
    
    [self bringSubviewToFront:self.animateHolder];
    
    
}


-(void)startAnimation
{
   /* if ([self.animationView.layer animationForKey:@"SpinAnimation"] == nil) {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 3.0f;
        animation.repeatCount = INFINITY;
        [self.animationView.layer addAnimation:animation forKey:@"SpinAnimation"];
    }*/
    
    [self showHud];
}


-(void)stopAnimation
{
     // [self.animationView.layer removeAnimationForKey:@"SpinAnimation"];
    [self hideHud];
}



-(void)showHud
{
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleSize = 35.0f;
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    
    [KVNProgress showWithParameters:
     @{KVNProgressViewParameterFullScreen: @(YES),
       KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
       KVNProgressViewParameterStatus: @"",
       KVNProgressViewParameterSuperview: self
       }];
    
}

-(void)hideHud
{
    [KVNProgress dismiss];
    
}

-(void)scrollViewMovedBounds:(NSInteger)pointOfView
{
    //NSInteger maxWidth = self.frame.size.width;
    
    float wid = self.frame.size.width / 8;
    if(pointOfView <= 0)
    {
      
        NSInteger offset  =-self.frame.size.width + (-pointOfView *6);
     //   UIView *myv = [self.animateViews objectAtIndex:7];
       
  
        if(offset <= 0)
        {
            [self.animateHolder setFrame:CGRectMake(offset, 0,self.frame.size.width , self.animateHolder.frame.size.height)];
            
        }
            else
            {
                 NSInteger j = [self.animateViews count]-1;
                for(UIView *v in self.animateViews)
                {
                    
                    [v setFrame:CGRectMake(wid * j, 0, wid , 100)];
                    
                    
                    j--;
                }

            }

        
        int i = 0;
        NSInteger framewidth = self.frame.size.width;
        //NSInteger offset2  =offset+62;
        NSInteger  myOther = 0;
        if(framewidth<  321)
        {
            myOther = 63;
        }
        else if(framewidth > 321 && framewidth < 376)
        {
            myOther = 75;
        }
        else
        {
            myOther = 87;
        }
        
        
            NSInteger offset2 = offset + myOther;
        

        if(offset2 <=0)
        {
            for(UIView *v in self.animateViews)
            {
                
                [v setFrame:CGRectMake((-wid * i + (-wid * i * 2) ) +  (-pointOfView *8)  - i  * (pointOfView*1.855) , 0, wid , 100)];
                
                
                i++;
            }

            
        }
        else
        {
           
            [self.animateHolder setFrame:CGRectMake(0, 0,self.frame.size.width , self.animateHolder.frame.size.height)];
            
            NSInteger i = [self.animateViews count]-1;
            for(UIView *v in self.animateViews)
            {
                
                [v setFrame:CGRectMake(wid * i, 0, wid , 100)];
                
                
                i--;
            }

        }

        
     }
     else
     {
         [self.animateHolder setFrame:CGRectMake(-self.frame.size.width , 0,self.frame.size.width , self.animateHolder.frame.size.height)];
     }
    
    
}



@end
