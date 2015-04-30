#import "XExtensionItemAttachment.h"

@interface XExtensionItemAttachment ()

@property (nonatomic) id <NSSecureCoding> item;
@property (nonatomic) NSString *typeIdentifier;

@end

@implementation XExtensionItemAttachment

- (nullable instancetype)initWithItem:(id <NSSecureCoding> __nullable)item
                       typeIdentifier:(NSString  * __nullable)typeIdentifier {
    NSParameterAssert(item);
    NSParameterAssert(typeIdentifier);
    
    self = [super init];
    if (self) {
        _item = item;
        _typeIdentifier = [typeIdentifier copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithItem:nil typeIdentifier:nil];
}

@end
