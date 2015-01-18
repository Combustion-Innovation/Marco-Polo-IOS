//
//  SpecialTextField.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTextField : UITextField

-(void)setFields;
-(void)showShapeLayer;
-(void)hideShapeLayer;

-(void)setSpecialBackground:(UIColor *)color;
-(void)setWhitePlaceholder :(NSString *)placeholderText :(UIColor *)color;
@property(nonatomic,strong)NSString *originalPlaceholder;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@end
