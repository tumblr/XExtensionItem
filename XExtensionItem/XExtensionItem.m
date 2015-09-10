#import "XExtensionItem.h"
#import "XExtensionItemReferrer.h"
#import "XExtensionItemTypeSafeDictionaryValues.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString * const ParameterKeyXExtensionItem = @"x-extension-item";
static NSString * const ParameterKeyTags = @"tags";
static NSString * const ActivityTypeCatchAll = @"*";

@interface XExtensionItemSource ()

@property (nonatomic) NSMutableDictionary *customParameters;

@end

@implementation XExtensionItemSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _customParameters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - XExtensionItemSource

- (void)addCustomParameters:(id<XExtensionItemCustomParameters>)customParameters {
    [self.customParameters addEntriesFromDictionary:customParameters.dictionaryRepresentation];
}

#pragma mark - UIActivityItemSource

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return (NSString *)kUTTypePropertyList;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @{};
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if (isExtensionItemInputAcceptedByActivityType(activityType)) {
        /*
         Share extensions take `NSExtensionItem` instances as input, and *some* system activities do as well, but some 
         do not. Unfortunately we need to maintain a hardcoded list of which system activities we can pass extension 
         items to.
         
         Trying to pass an extension item into a system activity that doesn’t know how to process it will result in no 
         data making it’s way through. In these cases, we’ll pass the placeholder item that this instance was 
         initialized with instead.
         */
        
        NSExtensionItem *item = [[NSExtensionItem alloc] init];
        item.userInfo = ({
            NSMutableDictionary *mutableUserInfo = [[NSMutableDictionary alloc] init];
            [mutableUserInfo addEntriesFromDictionary:self.customParameters];
            [mutableUserInfo addEntriesFromDictionary:self.userInfo];
            
            NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
            [mutableParameters setValue:self.tags forKey:ParameterKeyTags];
            [mutableParameters addEntriesFromDictionary:self.referrer.dictionaryRepresentation];
            
            mutableUserInfo[ParameterKeyXExtensionItem] = [mutableParameters copy];
            
            mutableUserInfo;
        });
        
        /*
         The `userInfo` setter *must* be called before the following three setters, which merely provide syntactic sugar for
         populating the `userInfo` dictionary with the following keys:
         
         * `NSExtensionItemAttributedTitleKey`,
         * `NSExtensionItemAttributedContentTextKey`
         * `NSExtensionItemAttachmentsKey`.
         
         */
        
        return item;
    }
    else {
        return nil;
    }
}

#pragma mark - Private

static BOOL isExtensionItemInputAcceptedByActivityType(NSString *activityType) {
    if (![NSExtensionItem class])
        return NO;
    
    NSSet *unacceptingTypes = [[NSSet alloc] initWithArray:@[
                                                             UIActivityTypeMessage,
                                                             UIActivityTypeMail,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypeAirDrop,
                                                             ]];
    
    /*
     The following activities are capable of taking `NSExtensionItem` instances as input. They display system share 
     sheets that consume the extension item’s `attributedContentText` value.
     */
    NSSet *acceptingTypes = [[NSSet alloc] initWithArray:@[
                                                           UIActivityTypePostToTwitter,
                                                           UIActivityTypePostToVimeo,
                                                           UIActivityTypePostToWeibo,
                                                           UIActivityTypePostToTencentWeibo,
                                                           
                                                           /*
                                                            If the official Facebook or Flickr apps are installed, they 
                                                            take precedent over the system sheets and do *not* consume 
                                                            `attributedContentText`.
                                                            */
                                                           UIActivityTypePostToFacebook,
                                                           UIActivityTypePostToFlickr,
                                                           ]];
    
    if ([unacceptingTypes containsObject:activityType]) {
        return NO;
    }
    else if ([acceptingTypes containsObject:activityType]) {
        return YES;
    }
    else {
        return YES;
    }
}

@end


@interface XExtensionItemContext ()

@property (nonatomic) NSArray *inputItems;
@property (nonatomic) NSDictionary *userInfo;

@end

@implementation XExtensionItemContext

#pragma mark - Initialization

- (instancetype)initWithExtensionContext:(NSExtensionContext *)extensionContext {
    NSParameterAssert(extensionContext);
    
    self = [super init];
    if (self) {
        _inputItems = extensionContext.inputItems;
        
        NSExtensionItem *xExtensionItem = [[self class] xExtensionItemFromContext:extensionContext];

        NSDictionary *dictionary = [[[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:xExtensionItem.userInfo]
                                    dictionaryForKey:ParameterKeyXExtensionItem];
        
        XExtensionItemTypeSafeDictionaryValues *dictionaryValues = [[XExtensionItemTypeSafeDictionaryValues alloc] initWithDictionary:dictionary];
        
        _tags = [[dictionaryValues arrayForKey:ParameterKeyTags] copy];
        
        _referrer = [[XExtensionItemReferrer alloc] initWithDictionary:dictionary];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithExtensionContext:nil];
}

#pragma mark - XExtensionItem detection

+ (NSExtensionItem *)xExtensionItemFromContext:(NSExtensionContext *)context {
    NSArray *inputItems = context.inputItems;
    
    NSUInteger index = [inputItems indexOfObjectPassingTest:^BOOL(NSExtensionItem * __nonnull item, NSUInteger idx, BOOL * __nonnull stop) {
        return [[self class] isXExtensionItem:item];
    }];
    
    if (index == NSNotFound) {
        return nil;
    }
    else {
        return inputItems[index];
    }
}

+ (BOOL)isXExtensionItem:(NSExtensionItem *)extensionItem {
    return extensionItem.userInfo[ParameterKeyXExtensionItem] != nil;
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *mutableDescription = [[NSMutableString alloc] initWithFormat:@"%@ { inputItems: %@",
                                           [super description], self.inputItems];
    
    if (self.tags) {
        [mutableDescription appendFormat:@", tags: %@", self.tags];
    }
    
    if (self.referrer) {
        [mutableDescription appendFormat:@", sourceApplication: %@", self.referrer];
    }
    
    if (self.userInfo) {
        [mutableDescription appendFormat:@", userInfo: %@", ({
            NSMutableDictionary *mutableUserInfo = [self.userInfo mutableCopy];
            
            for (NSString *key in @[NSExtensionItemAttributedTitleKey, NSExtensionItemAttributedContentTextKey, NSExtensionItemAttachmentsKey]) {
                [mutableUserInfo removeObjectForKey:key];
            }
            
            // Remove values used internally by this class
            [mutableUserInfo removeObjectForKey:ParameterKeyXExtensionItem];
            
            [mutableUserInfo copy];
        })];
    }
    
    [mutableDescription appendFormat:@" }"];
    
    return [mutableDescription copy];
}

@end
