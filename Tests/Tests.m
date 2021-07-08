//
//  Tests.m
//  Tests
//
//  Created by Kam on 2021/7/8.
//

#import <XCTest/XCTest.h>
#import "CIRSearcher.h"

@interface TestSearchableObject : NSObject <CIRSearchable>
@property (nonatomic, strong) NSString *name;
@end
@implementation TestSearchableObject

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (BOOL)matchWithText:(NSString *)text {
    if (!text.length) return NO;
    return [_name containsString:text];
}

@end

@interface Tests : XCTestCase
@property (nonatomic, strong) CIRSearcher *searcher;
@property (nonatomic, strong) NSMutableArray<TestSearchableObject *> *objects;

@end

@implementation Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *nameFilePath = [[NSBundle bundleForClass:self.class] pathForResource:@"name" ofType:@"txt"];
    NSString *nameString = [[NSString alloc] initWithContentsOfFile:nameFilePath
                                                           encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray<TestSearchableObject *> *objects = [NSMutableArray new];
    NSArray<NSString *> *names = [nameString componentsSeparatedByString:@"\n"];

    [names enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        TestSearchableObject *obj = [[TestSearchableObject alloc] initWithName:name];
        [objects addObject:obj];
    }];

    CIRSearcher *searcher = [CIRSearcher new];
    [searcher setSearchableData:[objects copy]];
    _searcher = searcher;
    _objects = objects;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssert([_searcher searchWithText:@"F"].count == 74, @"");
    XCTAssert([_searcher searchWithText:@"Fr"].count == 20, @"");
    XCTAssert([_searcher searchWithText:@"Frw"].count == 0, @"");
    XCTAssert([_searcher searchWithText:@"Frwe"].count == 0, @"");
    XCTAssert([_searcher searchWithText:@"Frw"].count == 0, @"");
    XCTAssert([_searcher searchWithText:@"Fre"].count == 6, @"");
    XCTAssert([_searcher searchWithText:@"Frey"].count == 0, @"");
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        [_searcher searchWithText:@"F"];
        [_searcher searchWithText:@"Fr"];
        [_searcher searchWithText:@"Frw"];
        [_searcher searchWithText:@"Frwe"];
        [_searcher searchWithText:@"Frw"];
        [_searcher searchWithText:@"Fr"];
        [_searcher searchWithText:@"Fre"];
    }];
}

- (void)testNoCachingSearchExample {
    [self measureBlock:^{
        [self p_fullSearchWithText:@"F"];
        [self p_fullSearchWithText:@"Fr"];
        [self p_fullSearchWithText:@"Frw"];
        [self p_fullSearchWithText:@"Frwe"];
        [self p_fullSearchWithText:@"Frw"];
        [self p_fullSearchWithText:@"Fr"];
        [self p_fullSearchWithText:@"Fre"];
    }];
}

- (void)p_fullSearchWithText:(NSString *)text {
    NSMutableArray *result = [NSMutableArray new];
    [_objects enumerateObjectsUsingBlock:^(TestSearchableObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj matchWithText:text]) {
            [result addObject:obj];
        }
    }];
}

@end
