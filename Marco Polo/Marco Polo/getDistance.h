//
//  getDistance.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/5/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface getDistance : NSObject

-(NSString *)getDistanceFromTwoPoints:(CLLocation *)loc1:(CLLocation *)loc2;
-(NSString *) getDirectionFromLocation:(CLLocation*)fromLoc toCoordinate:(CLLocation*)toLoc;
+ (double) distanceBetweenLat1:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2;
@end
