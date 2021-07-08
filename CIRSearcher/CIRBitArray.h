//
//  CIRBitArray.h
//  CIRSearcher
//
//  Created by Kam on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIRBitArray : NSObject
- (nullable instancetype)initWithBitCount:(NSUInteger)bitCount;
- (NSUInteger)count;
- (NSUInteger)trueCount;
- (NSUInteger)falseCount;
- (BOOL)valueAtIndex:(NSUInteger)index;
- (void)setValue:(BOOL)value atIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
