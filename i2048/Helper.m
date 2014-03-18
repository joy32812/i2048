//
//  Helper.m
//  i2048
//
//  Created by xiaoyuan wang on 3/18/14.
//  Copyright (c) 2014 1010.am. All rights reserved.
//

#import "Helper.h"

@implementation Helper


+ (int)bestScore
{
    NSString *theKey = @"JOY_2048_BEST_SCORE";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger bestScore = [userDefault integerForKey:theKey];
    
    return bestScore;
}

+ (void)setBestScore:(int)bestScore
{
    NSString *theKey = @"JOY_2048_BEST_SCORE";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:bestScore forKey:theKey];
    [userDefault synchronize];
}

@end
