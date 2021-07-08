//
//  CIRSearcher.h
//  CIRSearcher
//
//  Created by Kam on 2021/7/8.
//

#import <Foundation/Foundation.h>

@protocol CIRSearchable <NSObject>
- (BOOL)matchWithText:(NSString *)text;
@end

@interface CIRSearcher : NSObject
- (void)setSearchableData:(NSArray<CIRSearchable> *)data;
- (NSArray<CIRSearchable> *)searchWithText:(NSString *)text;
@end
