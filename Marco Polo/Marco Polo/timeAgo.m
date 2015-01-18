//
//  timeAgo.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/5/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "timeAgo.h"

@implementation timeAgo


- (NSString *)timeAgo:(NSDate *)compareDate{
    NSTimeInterval timeInterval = -[compareDate timeIntervalSinceNow];
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"now"];   //less than a minute
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%dm",temp];   //minutes ago
    }else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%dh",temp];   //hours ago
    }else{
        temp = temp / 24;
        result = [NSString stringWithFormat:@"%dd",temp];   //days ago
    }
    return  result;
}

@end
