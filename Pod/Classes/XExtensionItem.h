#import "XExtensionItemReferrer.h"
#import "XExtensionItemDictionarySerializing.h"

typedef id (^XExtensionItemProvidingBlock)();
typedef UIImage *(^XExtensionItemThumbnailProvidingBlock)(CGSize suggestedSize);

@interface XExtensionItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedContentText;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSURL *sourceURL;
@property (nonatomic) XExtensionItemReferrer *referrer;
@property (nonatomic, copy) NSDictionary *userInfo;

- (instancetype)initWithPlaceholderItem:(id)placeholderItem attachments:(NSArray/*<NSItemProvider>*/ *)attachments NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithPlaceholderData:(id)placeholderData dataTypeIdentifier:(NSString *)dataTypeIdentifier attachments:(NSArray/*<NSItemProvider>*/ *)attachments;

- (void)addEntriesToUserInfo:(id <XExtensionItemDictionarySerializing>)dictionarySerializable;

- (void)registerItemProvidingBlock:(XExtensionItemProvidingBlock)itemBlock forActivityType:(NSString *)activityType;
- (void)registerSubject:(NSString *)subject forActivityType:(NSString *)activityType;
- (void)registerThumbnailProvidingBlock:(XExtensionItemThumbnailProvidingBlock)thumbnailBlock forActivityType:(NSString *)activityType;

@end

@interface XExtensionItem : NSObject

@property (nonatomic, readonly) NSArray/*<NSItemProvider>*/ *attachments;
@property (nonatomic, readonly) NSAttributedString *attributedTitle;
@property (nonatomic, readonly) NSAttributedString *attributedContentText;
@property (nonatomic, readonly) NSArray/*<NSString>*/ *tags;
@property (nonatomic, readonly) NSURL *sourceURL;
@property (nonatomic, readonly) XExtensionItemReferrer *referrer;
@property (nonatomic, readonly) NSDictionary *userInfo;

- (instancetype)initWithExtensionItem:(NSExtensionItem *)extensionItem NS_DESIGNATED_INITIALIZER;

@end
