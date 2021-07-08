//
//  CIRBitArray.m
//  CIRSearcher
//
//  Created by Kam on 2021/7/8.
//

#import "CIRBitArray.h"


@interface CIRBitArray() {
    Byte *_region;
    NSUInteger _bitCount;
    NSUInteger _trueCount;
}
@end

static const size_t byteSize = 8;
@implementation CIRBitArray
- (instancetype)initWithBitCount:(NSUInteger)bitCount {
    if (self = [super init]) {
        _bitCount = bitCount;
        size_t byteRequired = bitCount / byteSize + ((bitCount % byteSize) > 0 ? 1 : 0);
        _region = calloc(1, byteRequired);
        if (_region == NULL) return nil;
    }
    return self;
}

- (NSUInteger)count {
    return _bitCount;
}

- (NSUInteger)trueCount {
    return _trueCount;
}

- (NSUInteger)falseCount {
    return _bitCount - _trueCount;
}

- (BOOL)valueAtIndex:(NSUInteger)index {
    if (index >= _bitCount) @throw [self p_outOfBoundsExcpetion:index];
    NSUInteger byteIdx = index / byteSize;
    Byte byte = _region[byteIdx];
    int shift = (index % byteSize);
    BOOL result = (byte & (1 << shift)) >> shift;
    return result;
}

- (void)setValue:(BOOL)value atIndex:(NSUInteger)index {
    if (index >= _bitCount) @throw [self p_outOfBoundsExcpetion:index];
    NSUInteger byteIdx = index / byteSize;
    Byte byte = _region[byteIdx];
    
    BOOL oldValue = [self valueAtIndex:index];
    if (value && !oldValue) {
        _trueCount++;
    } else if (!value && oldValue) {
        _trueCount--;
    }
    
    int shift = (index % byteSize);
    Byte newByte = (~(1 << shift) & byte) | (value << shift);
    _region[byteIdx] = newByte;
}

- (void)dealloc {
    if (_region) {
        free(_region);
        _region = NULL;
        _bitCount = 0;
    }
}

- (NSException *)p_outOfBoundsExcpetion:(NSUInteger)index {
    NSString *reason = [NSString stringWithFormat:@"index %zd beyond bounds for empty", index];
    return [NSException exceptionWithName:@"CIRBitArrayException" reason:reason userInfo:nil];
}

@end
