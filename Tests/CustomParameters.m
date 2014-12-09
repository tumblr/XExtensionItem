#import "CustomParameters.h"

static NSString * const CustomParameterKey = @"CustomParameterKey";

@implementation CustomParameters

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _customParameter = [dictionary valueForKey:CustomParameterKey];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setValue:self.customParameter forKey:CustomParameterKey];
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

@end
