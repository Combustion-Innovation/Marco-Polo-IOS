//
//  CustomControl.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/7/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomControl : UIRefreshControl



-(void)addSpecial;
-(void)startAnimation;
-(void)stopAnimation;
-(void)scrollViewMovedBounds:(NSInteger)pointOfView;

@property(nonatomic,retain)NSMutableArray *animateViews;
@property(nonatomic,retain)UIView *animateHolder;

@property(nonatomic,strong)UIImageView *animationView;


@end
