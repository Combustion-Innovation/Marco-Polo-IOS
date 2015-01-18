//
//  LoginManager.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialLoginDelegate.h"

@interface LoginManager : UIView{
    id<SocialLoginDelegate>delegate;
}
@property(nonatomic,strong)id delegate;
-(void)login:(NSString*)username:(NSString *)password;



@end
