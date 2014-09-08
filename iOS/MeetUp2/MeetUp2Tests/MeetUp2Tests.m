//
//  MeetUp2Tests.m
//  MeetUp2Tests
//
//  Created by Kevin Frans on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MeetUp2Tests : XCTestCase

@end

@implementation MeetUp2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
