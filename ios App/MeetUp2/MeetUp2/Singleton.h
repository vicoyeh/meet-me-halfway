//
//  Singleton.h
//  MeetUp2
//
//  Created by Wilson Zhao on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (Singleton *)sharedInstance;

@property (nonatomic,readwrite) int test;
@end
