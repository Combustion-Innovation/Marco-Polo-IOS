//
//  MarcoPoloCell.h
//  Marco Polo
//
//  Created by Daniel Nasello on 12/22/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SWTableViewCell.h"
#import "SBtwo.h"
@interface MarcoPoloCell : SWTableViewCell


@property(nonatomic,strong)UILabel *mainLabel;
@property(nonatomic,strong)UILabel *descriptionLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)NSIndexPath *myPath;
@property(nonatomic,assign)NSInteger cellType;
@property(nonatomic,strong)UIColor *myColor;
@property(nonatomic,assign)NSInteger width;
-(void)fixForContacts;
-(void)sendInviteStatus:(NSMutableDictionary *)dict;
-(void)marcoWasTapped:(NSDictionary *)dict;
-(void)poloWasTapped:(NSDictionary *)dict;
-(void)setCellHeight:(float)cellHeight;
-(void)blockThisPerson:(NSMutableDictionary *)dict:(BOOL)isBlocking;
@property(nonatomic,assign)BOOL canCLick;
@property(nonatomic,strong) SBtwo *coverButton;
@end
