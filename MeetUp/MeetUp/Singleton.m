//
//  Singleton.m
//  MeetUp
//
//  Created by Wilson Zhao on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (Singleton *)sharedInstance
{
    static Singleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Singleton alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end
