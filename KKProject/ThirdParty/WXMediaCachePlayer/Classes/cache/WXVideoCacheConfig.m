//
//  WXVideoCacheConfig.m
//  -
//
//  Created by zk on 2021/7/27.
//


#import "WXVideoCacheConfig.h"

static NSString *kFilePathKey = @"kFilePath";
static NSString *kContentInfoKey = @"kContentInfo";
static NSString *kFragmentKey = @"kFragmentKey";

@interface WXVideoCacheConfig ()

@property (nonatomic, strong, readwrite) NSString *filePath;
@property (nonatomic, strong) NSMutableArray<NSValue*> *fragmentArray;

@end

@implementation WXVideoCacheConfig

+ (instancetype)configurationForFilePath:(NSString *)filePath {
    filePath = [self configurationFilePathForFilePath:filePath];
    
    WXVideoCacheConfig *config = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!config) {
        config = [[WXVideoCacheConfig alloc] init];
        config.fragmentArray = [NSMutableArray array];
    }
    config.filePath = filePath;
    
    return config;
}

+ (NSString *)configurationFilePathForFilePath:(NSString *)filePath {
    return [filePath stringByAppendingPathExtension:@"media_cfg"];
}

- (void)save {
    @synchronized (self.fragmentArray) {
        [NSKeyedArchiver archiveRootObject:self toFile:self.filePath];
    }
}

- (void)addCacheFragment:(NSRange)fragment {
    @synchronized (self.fragmentArray) {

        NSMutableArray<NSValue *> *rangeArray = self.fragmentArray.mutableCopy;
        
        NSInteger count = rangeArray.count;
        if (count == 0) {
            [rangeArray addObject:[NSValue valueWithRange:fragment]];
        } else {
            //1-3   2-5  4-8  = > 1-8
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet]; //存储有交集的range
            
            __block NSInteger endIdx = -1;
            [rangeArray enumerateObjectsUsingBlock:^(NSValue*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  
                NSRange range = obj.rangeValue;
                
                if (fragment.location + fragment.length < range.location) { //在当前片段左侧 停止遍历
                    endIdx = idx;
                    *stop = YES;
                    
                
                //记录可以合并的片段range
                //例如0-2,2-5 这种片段应该合并成0-5 。如果使用NSIntersectionRange得到range为(0,0)
                } else if (fragment.location <= (range.location + range.length) && (fragment.location + fragment.length) >= range.location) { //有交集
                    
                    [indexSet addIndex:idx];
                    
                }
            }];
            
            /*
             
             <__NSArrayM 0x6000005c7d20>(
             NSRange: {0, 15878},
             NSRange: {15878, 3993},
             NSRange: {13369344, 18980},
             NSRange: {13388324, 66635}
             )
             */
            
            if (indexSet.count == 0) { //和当前片段没有交集，插入到对应顺序的位置
                
                if (endIdx >= 0) {
                    [rangeArray insertObject:[NSValue valueWithRange:fragment] atIndex:endIdx];
                } else {
                    [rangeArray addObject:[NSValue valueWithRange:fragment]];
                }
                
            } else { //将相交的所有片段合成一个  leftRange -- rightRange  合成后的range保持升序
                NSRange firstRange = rangeArray[indexSet.firstIndex].rangeValue;
                NSRange lastRange = rangeArray[indexSet.lastIndex].rangeValue;
                
                NSInteger location = MIN(firstRange.location, fragment.location);
                NSInteger endOffset = MAX(lastRange.location + lastRange.length, fragment.location + fragment.length);
                NSRange combineRange = NSMakeRange(location, endOffset - location);
                
                //移除旧的碎片段
                [rangeArray removeObjectsAtIndexes:indexSet];
                
                //插入新的合成片段
                [rangeArray insertObject:[NSValue valueWithRange:combineRange] atIndex:indexSet.firstIndex];
            }
            
            /*
            if (indexSet.count == 1) {
                
                NSRange range = rangeArray[indexSet.firstIndex].rangeValue;
                
                NSInteger location = MIN(range.location, fragment.location);
                NSInteger endOffset = MAX(fragment.location+fragment.length, range.location+range.length);
                
                NSRange combineRange = NSMakeRange(location, endOffset-location);
                [rangeArray removeObjectsAtIndexes:indexSet];
                [rangeArray insertObject:[NSValue valueWithRange:combineRange] atIndex:indexSet.firstIndex];
                
            } else if (indexSet.count > 1) {
                
                NSRange firstRange = rangeArray[indexSet.firstIndex].rangeValue;
                NSRange lastRange = rangeArray[indexSet.lastIndex].rangeValue;
                
                NSInteger location = MIN(firstRange.location, fragment.location);
                NSInteger endOffset = MAX(lastRange.location + lastRange.length, fragment.location + fragment.length);
                NSRange combineRange = NSMakeRange(location, endOffset - location);
                
                [rangeArray removeObjectsAtIndexes:indexSet];
                [rangeArray insertObject:[NSValue valueWithRange:combineRange] atIndex:indexSet.firstIndex];
                
            } else if (indexSet.count == 0) { //和当前片段没有交集
                
                if (endIdx >= 0) {
                    [rangeArray insertObject:[NSValue valueWithRange:fragment] atIndex:endIdx];
                } else {
                    [rangeArray addObject:[NSValue valueWithRange:fragment]];
                }
                
            }
             */
               
        }
        
        
        self.fragmentArray = rangeArray.mutableCopy;
    }
}

- (NSArray<NSValue*> *)allFragments {
    @synchronized (self.fragmentArray) {
        return [self.fragmentArray copy];
    }
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.contentInfo forKey:kContentInfoKey];
    [coder encodeObject:self.filePath forKey:kFilePathKey];
    [coder encodeObject:self.fragmentArray forKey:kFragmentKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        
        _filePath = [coder decodeObjectForKey:kFilePathKey];
        _contentInfo = [coder decodeObjectForKey:kContentInfoKey];
        _fragmentArray = [[coder decodeObjectForKey:kFragmentKey] mutableCopy];
        if (!_fragmentArray) {
            _fragmentArray = [NSMutableArray array];
        }
    }
    return self;
}

@end
