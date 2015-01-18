//
//  getDistance.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/5/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "getDistance.h"

@implementation getDistance



//takes two CLL Locations and gets the distance. then formats it so its only two decimal places over.
-(NSString *)getDistanceFromTwoPoints :(CLLocation *)loc1 :(CLLocation *)loc2
{
    CLLocation *loc12 = [[CLLocation alloc] initWithLatitude:loc1.coordinate.latitude longitude:loc1.coordinate.longitude];
    
    CLLocation *loc22 = [[CLLocation alloc] initWithLatitude:loc2.coordinate.latitude longitude:loc2.coordinate.longitude];
    
    double distance = [loc12 distanceFromLocation: loc22];
    double lat1rad = loc1.coordinate.latitude * M_PI/180;
    double lon1rad = loc1.coordinate.longitude * M_PI/180;
    double lat2rad = loc2.coordinate.latitude * M_PI/180;
    double lon2rad = loc2.coordinate.longitude * M_PI/180;
    
    //deltas
    double dLat = lat2rad - lat1rad;
    double dLon = lon2rad - lon1rad;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad);
    double c = 2 * asin(sqrt(a));
    double R = 6372.8;
    double d = R * c;
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    [format setMaximumFractionDigits:2];
    NSString *temp = [format stringFromNumber:[NSNumber numberWithDouble:d]];
    
 //   return [NSString stringWithFormat:@"%f",distance];
        return temp;
}

double DegreesToRadians(double degrees) {return degrees * M_PI / 180;};
double RadiansToDegrees(double radians) {return radians * (180/M_PI);};

//takes the to and from coords and then gets the degrees in radians. We will then evaluate the degrees to return the direction of two .
-(NSString *) getDirectionFromLocation:(CLLocation*)fromLoc toCoordinate:(CLLocation*)toLoc
{
    double lat1 = DegreesToRadians(fromLoc.coordinate.latitude);
    double lon1 = DegreesToRadians(fromLoc.coordinate.longitude);
    
    double lat2 = DegreesToRadians(toLoc.coordinate.latitude);
    double lon2 = DegreesToRadians(toLoc.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    
    

    return [self degreesToDirection:RadiansToDegrees(radiansBearing)];
}


//takes the degrees and finds the Friendly direction of the distance of coordinates

-(NSString *)degreesToDirection:(double)degrees
{
    NSString *direction = @"";
    if(degrees == 0 || degrees == 360)
    {
        direction = @"N";
    }
    else if(degrees > 0 && degrees < 90)
    {
        direction = @"NW";
    }
    else if (degrees == 90)
    {
        direction = @"W";
    }
    else if(degrees > 90 && degrees < 180)
    {
        direction = @"SW";
    }
    else if(degrees == 180)
    {
        direction = @"S";
    }
    else if(degrees > 180 && degrees < 270)
    {
        direction = @"SE";
    }
    else if(degrees == 270)
    {
        direction = @"E";
    }
    else if(degrees> 270 && degrees < 360)
    {
        direction = @"NE";
    }
    else
    {
        direction =@"";
    }
    
    return direction;
}


+ (double) distanceBetweenLat1:(double)lat1 lon1:(double)lon1
                          lat2:(double)lat2 lon2:(double)lon2 {
    //degrees to radians
    double lat1rad = lat1 * M_PI/180;
    double lon1rad = lon1 * M_PI/180;
    double lat2rad = lat2 * M_PI/180;
    double lon2rad = lon2 * M_PI/180;
    
    //deltas
    double dLat = lat2rad - lat1rad;
    double dLon = lon2rad - lon1rad;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad);
    double c = 2 * asin(sqrt(a));
    double R = 6372.8;
    return R * c;
}

@end
