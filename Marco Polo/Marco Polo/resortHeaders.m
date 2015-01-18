//
//  resortHeaders.m
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import "resortHeaders.h"

@implementation resortHeaders


-(NSInteger)doesLetterAlreadyExist:(NSString *)letterToEvaluate;
{
    return [self.arrayToCheck indexOfObject:letterToEvaluate];

}


-(NSMutableArray *)addLetterToArray:(NSString *)letterToAdd;
{
    NSMutableArray *arrayToReturn = [[NSMutableArray alloc]init];
    
    
    [self.arrayToCheck removeLastObject];
    
    [self.arrayToCheck removeObjectAtIndex:0];
    [self.arrayToCheck removeObjectAtIndex:0];
    
    
    [self.arrayToCheck addObject:letterToAdd];
    
     arrayToReturn = [self sortAllKeys:self.arrayToCheck];
    [arrayToReturn insertObject:@"Recent" atIndex:0];
    [arrayToReturn insertObject:@"Polos" atIndex:0];
    [arrayToReturn addObject:@"Blocked"];
    [self.arrayToCheck insertObject:@"Recent" atIndex:0];
    [self.arrayToCheck insertObject:@"Polos" atIndex:0];
    [self.arrayToCheck addObject:@"Blocked"];
    
    NSLog(@"%@",arrayToReturn);
    
    return arrayToReturn;
}



- (NSMutableArray*)sortAllKeys: (NSMutableArray*)passedArray{
    NSArray* performSortOnKeys = [passedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [self cma:performSortOnKeys];
}

- (NSMutableArray *)cma:(NSArray *)array
{
    return [array mutableCopy];
}


@end
