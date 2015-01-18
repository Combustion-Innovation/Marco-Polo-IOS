//
//  CutOutView.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CutoutDelegate.h"
#import "DashedView.h"

@interface CutOutView : UIView{
    id<CutoutDelegate>delegate;
}

@property(weak,nonatomic)id delegate;
-(void)createSubViews;
-(void)selectBox;
-(void)deselectBox;
@property(nonatomic,strong)UILabel *l;
@property(nonatomic,assign)BOOL isEnabled;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)DashedView *topView;
@property(nonatomic,strong)DashedView *leftView;
@property(nonatomic,strong)DashedView *rightView;
@property(nonatomic,strong)DashedView *bottomView;
@property(nonatomic,retain)UIColor *alternate;
@property(nonatomic,retain)UIColor *mainColor;

-(void)resetButton;
@end
