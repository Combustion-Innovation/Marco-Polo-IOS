//
//  AppDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    id<AppDelegateProtocol>delegate;
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,weak)id delegate;
@property(nonatomic,retain)NSString *pushId;

@end

