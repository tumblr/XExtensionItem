//
//  NSExtensionItem+XExtensionItem.h
//  XExtensionURL
//
//  Created by Bryan Irace on 10/20/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

@import Foundation;

/**
 *  A few small additions to `NSExtensionItem` aimed at making it easier for developers to pass well-defined data 
 *  structures from iOS applications into iOS 8 extensions.
 *
 *  These additions:
 *
 *  A) Encourage a common extension item format. App developers may be inclined to add instances of classes like `NSURL`, 
 *     `NSString`, or `UIImage` to their `UIActivityViewController`s' extension item arrays. This is problematic because 
 *     only extensions that explicitly accept *all* of the provided item types will be displayed in the controller. A 
 *     better way to provide extensions with as much data as possible is to configure `UIActivityViewController` with a 
 *     single `NSExtensionItem` instance, with metadata added to its `userInfo` dictionary.
 *
 *  B) Provide accessors for broadly useful metadata, such as tags. Apps and extensions should be able to output and
 *     input these values without knowing the implementation details of the app/extension on the other side of the 
 *     handshake, in order to hardcode `userInfo` parameter keys.
 *
 *  C) Make it easier to use the `NSExtensionItem` API. The `userInfo` dictionary actually backs the rest of an extension
 *     item's properties, which can lead to subtle bugs if `NSExtensionItem` setters are called in the wrong order.
 */
@interface NSExtensionItem (XExtensionItem)

/**
 *  Tag metadata, like on Twitter, Instagram, or Tumblr.
 */
@property (nonatomic, readonly) NSArray *xExtensionTags;

/**
 *  Convenience method for getting a non-attributed version of this item's `attributedTitle`.
 */
@property (nonatomic, readonly) NSString *xExtensionTitle;

/**
 *  Convenience method for getting a non-attributed version of this item's `attributedContentText`.
 */
@property (nonatomic, readonly) NSString *xExtensionContentText;

/**
 *  @param attributedTitle       An optional title for the item.
 *  @param attributedContentText An optional string describing the extension item content.
 *  @param attachments           An optional array of media data associated with the extension item. These items are 
                                 always typed NSItemProvider. See `NSExtensionItem.h` for more details.
 *  @param tags                  Tag metadata, like on Twitter/Instagram/Tumblr.
 *  @param userInfo              An optional dictionary of keys and values. Individual applications can add advertise
 *                               whatever custom parameters they want, and extension developers can add values for those 
 *                               parameters in this dictionary. Custom user info keys should *not* start with 
 *                               `x-extension-item-`, as those will be used internally by this library.
 */
+ (NSExtensionItem *)xExtensionItemWithAttributedTitle:(NSAttributedString *)attributedTitle
                                 attributedContentText:(NSAttributedString *)attributedContentText
                                           attachments:(NSArray *)attachments
                                                  tags:(NSArray *)tags
                                              userInfo:(NSDictionary *)userInfo;

/**
 *  Convenience method for providing non-attributed title and content text strings.
 */
+ (NSExtensionItem *)xExtensionItemWithTitle:(NSString *)title
                                 contentText:(NSString *)contentText
                                 attachments:(NSArray *)attachments
                                        tags:(NSArray *)tags
                                    userInfo:(NSDictionary *)userInfo;

@end
