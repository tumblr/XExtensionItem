//
//  NSExtensionItem+XExtensionItem.m
//  XExtensionURL
//
//  Created by Bryan Irace on 10/20/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "NSExtensionItem+XExtensionItem.h"

static NSString * const XExtensionItemParameterKeyTags = @"x-extension-item-tags";

@implementation NSExtensionItem (XExtensionItem)

#pragma mark - Initialization

+ (NSExtensionItem *)xExtensionItemWithTitle:(NSString *)title
                                 contentText:(NSString *)contentText
                                 attachments:(NSArray *)attachments
                                        tags:(NSArray *)tags
                                    userInfo:(NSDictionary *)userInfo {
    NSAttributedString *(^nilSafeAttributedStringFromString)(NSString *) = ^(NSString *string) {
        return string ? [[NSAttributedString alloc] initWithString:string] : nil;
    };
    
    return [self xExtensionItemWithAttributedTitle:nilSafeAttributedStringFromString(attributedTitle)
                             attributedContentText:nilSafeAttributedStringFromString(attributedContentText)
                                       attachments:attachments
                                              tags:tags
                                          userInfo:userInfo];
}

+ (NSExtensionItem *)xExtensionItemWithAttributedTitle:(NSAttributedString *)attributedTitle
                                 attributedContentText:(NSAttributedString *)attributedContentText
                                           attachments:(NSArray *)attachments
                                                  tags:(NSArray *)tags
                                              userInfo:(NSDictionary *)userInfo {
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.userInfo = ({
        NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
        [mutableUserInfo setValue:tags forKey:XExtensionItemParameterKeyTags];
        [mutableUserInfo copy];
    });
    
    /*
     The `userInfo` setter *must* be called before the following three setters, which merely provide syntactic sugar for
     populating the `userInfo` dictionary with the following keys:
        * `NSExtensionItemAttributedTitleKey`,
        * `NSExtensionItemAttributedContentTextKey`
        * `NSExtensionItemAttributedAttachmentsKey`.
     */
    item.attachments = [attachments copy];
    item.attributedTitle = [attributedTitle copy];
    item.attributedContentText = [attributedContentText copy];
    
    return item;
}

#pragma mark - Accessors

- (NSArray *)xExtensionTags {
    return self.userInfo[XExtensionItemParameterKeyTags];
}

- (NSString *)xExtensionTitle {
    return [self.attributedTitle string];
}

- (NSString *)xExtensionContentText {
    return [self.attributedContentText string];
}

@end
