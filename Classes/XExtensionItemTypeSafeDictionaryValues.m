#import "XExtensionItemTypeSafeDictionaryValues.h"

@interface XExtensionItemTypeSafeDictionaryValues()

@property (nonatomic, copy) NSDictionary *dictionary;

@end

@implementation XExtensionItemTypeSafeDictionaryValues

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _dictionary = [dictionary copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}

#pragma mark - Type-safe accessors

- (NSString *)stringForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSString class]];
}

- (NSNumber *)numberForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSNumber class]];
}

- (NSURL *)URLForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSURL class]];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSDictionary class]];
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSArray class]];
}

- (NSData *)dataForKey:(NSString *)key {
    return [self valueForKey:key ofType:[NSData class]];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key {
    NSNumber *number = [self numberForKey:key];
    
    if (number) {
        return number.unsignedIntegerValue;
    }
    else {
        return NSNotFound;
    }
}

#pragma mark - Private

- (id)valueForKey:(NSString *)key ofType:(Class)class {
    id value = [self.dictionary valueForKey:key];
    
    if ([value isKindOfClass:class]) {
        return value;
    }
    else {
        return nil;
    }
}

@end
