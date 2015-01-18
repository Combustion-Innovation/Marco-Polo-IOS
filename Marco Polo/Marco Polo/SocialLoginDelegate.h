//
//  SocialLoginDelegate.h
//  Marco Polo
//
//  Created by Daniel Nasello on 11/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
//
//  SocialLoginDelegate.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialLoginDelegate <NSObject>

-(void)PushLoginError;
-(void)PushUpdatedLogin:(NSDictionary *)extraData;
@end
