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
- (void)setSearchableData:(NSArray<id<CIRSearchable>> *)data;
- (NSArray<id<CIRSearchable>> *)searchWithText:(NSString *)text;
@end
