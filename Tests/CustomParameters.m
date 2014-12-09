#import "CustomParameters.h"

@implementation CustomParameters

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _customParameter = [dictionary valueForKey:[[self class] customParameterKey]];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setValue:self.customParameter forKey:[[self class] customParameterKey]];
    return [mutableDictionary copy];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [self.customParameter isEqualToString:((CustomParameters *)object).customParameter];
}

- (NSUInteger)hash {
    NSUInteger hash = 17;
    hash += self.customParameter.hash;
    return hash * 39;
}

#pragma mark - Private

+ (NSString *)customParameterKey {
    return @"customParameterKey";
}

@end
