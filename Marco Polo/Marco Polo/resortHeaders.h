//
//  resortHeaders.h
//  Marco Polo
//
//  Created by Daniel Nasello on 1/12/15.
//  Copyright (c) 2015 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface resortHeaders : NSObject
@property(nonatomic,strong)NSMutableArray *arrayToCheck;
-(NSInteger)doesLetterAlreadyExist:(NSString *)letterToEvaluate;
-(NSInteger)indexOfLetter:(NSString *)letterToEvaluate;
-(NSMutableArray *)addLetterToArray:(NSString *)letterToAdd;


@end
