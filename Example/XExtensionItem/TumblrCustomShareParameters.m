#import "TumblrCustomShareParameters.h"

static NSString * const CustomURLSlugParameterKey = @"tumblr-custom-url-slug";

@implementation TumblrCustomShareParameters

#pragma mark - Initialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        id slugValue = [dictionary valueForKey:CustomURLSlugParameterKey];
        
        if ([slugValue isKindOfClass:[NSString class]]) {
            _customURLSlug = [slugValue copy];
        }
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}

#pragma mark - XExtensionItemDictionarySerializing

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setValue:self.customURLSlug forKey:CustomURLSlugParameterKey];
    return [mutableDictionary copy];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    TumblrCustomShareParameters *other = (TumblrCustomShareParameters *)object;
    
    return [self.customURLSlug isEqualToString:other.customURLSlug];
}

- (NSUInteger)hash {
    NSUInteger hash = 17;
    hash += self.customURLSlug.hash;
    
    return hash * 39;
}

@end
