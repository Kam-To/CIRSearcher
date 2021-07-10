//
//  CIRSearcher.m
//  CIRSearcher
//
//  Created by Kam on 2021/7/8.
//

#import "CIRSearcher.h"
#import "CIRBitArray.h"

@interface CIRSearchResult : CIRBitArray {
@public
    NSString *_keyword;
}
@end
@implementation CIRSearchResult
@end


@interface CIRSearcher () {
    NSArray<id<CIRSearchable>> *_totalData;
    NSMutableDictionary<NSString *, CIRSearchResult *> *_textResultMap;
    NSMutableArray<NSString *> *_keywordSequence;
}
@end
@implementation CIRSearcher
- (instancetype)init {
    if (self = [super init]) {
        _textResultMap = [NSMutableDictionary new];
        _keywordSequence = [NSMutableArray new];
    }
    return self;
}

- (void)setSearchableData:(NSArray<id<CIRSearchable>> *)data {
    if (_totalData == data) return;
    _totalData = data;
    [_textResultMap removeAllObjects];
    [_keywordSequence removeAllObjects];
}

- (NSArray<id<CIRSearchable>> *)searchWithText:(NSString *)text {
    
    if (!text.length) {
        [_textResultMap removeAllObjects];
        [_keywordSequence removeAllObjects];
        return (NSArray<id<CIRSearchable>> *)@[];
    }
    
    NSInteger lastIndex = text.length;
    NSInteger cursor = lastIndex;
    CIRSearchResult *cache = nil;
    while (cursor > 0) {
        NSString *subKeyword = [text substringToIndex:cursor];
        cache = _textResultMap[subKeyword];
        if (cache) {
            NSInteger idx = [_keywordSequence indexOfObject:subKeyword];
            NSInteger keywordCount = _keywordSequence.count;
            NSInteger toRemoveCount = keywordCount - (idx + 1);
            // remove discardable caches
            if (idx != NSNotFound && toRemoveCount > 0) {
                NSRange range = NSMakeRange(idx + 1, toRemoveCount);
                NSArray<NSString *> *toRemove = [_keywordSequence subarrayWithRange:range];
                [_textResultMap removeObjectsForKeys:toRemove];
                [_keywordSequence removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            }
            break;
        }
        cursor--;
    }
    
    NSMutableArray<id<CIRSearchable>> *result = (NSMutableArray<id<CIRSearchable>> *)[NSMutableArray new];
    
    BOOL hit = cache && [cache->_keyword isEqual:text];
    if (hit) {
        [_totalData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([cache valueAtIndex:idx]) {
                [result addObject:obj];
            }
        }];
    } else {
        CIRSearchResult *thisSearchCache = [[CIRSearchResult alloc] initWithBitCount:_totalData.count];
        thisSearchCache->_keyword = text;
        if (cache) {
            NSUInteger readCount = 0;
            NSUInteger count = cache.count;
            NSUInteger trueCount = cache.trueCount;
            for (NSUInteger i = 0; i < count; i++) {
                if (![cache valueAtIndex:i]) continue;
                id<CIRSearchable> obj = _totalData[i];
                readCount++;
                if ([obj matchWithText:text]) {
                    [thisSearchCache setValue:true atIndex:i];
                    [result addObject:obj];
                }
                if (readCount == trueCount) break;
            }
        } else {
            [_totalData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj matchWithText:text]) {
                    [thisSearchCache setValue:true atIndex:idx];
                    [result addObject:obj];
                }
            }];
        }
        [_textResultMap setObject:thisSearchCache forKey:text];
        [_keywordSequence addObject:text];
    }
    return result;
}

@end
