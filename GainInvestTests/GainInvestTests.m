//
//  GainInvestTests.m
//  GainInvestTests
//
//  Created by 苏沫离 on 17/2/7.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GainInvestTests : XCTestCase

@end

@implementation GainInvestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //Setup是在所有测试用例运行之前运行的函数，在这个测试用例里进行一些通用的初始化工作
    

}

- (void)tearDown
{
    // tearDown是在所有的测试用例都执行完毕后执行的

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
}

- (void)testExample
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^
    {
        // Put the code you want to measure the time of here.
    }];
}

@end
