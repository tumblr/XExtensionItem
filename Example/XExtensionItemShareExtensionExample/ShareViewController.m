//
//  ShareViewController.m
//  XExtensionItemShareExtensionExample
//
//  Created by Bryan Irace on 12/8/14.
//  Copyright (c) 2014 Bryan Irace. All rights reserved.
//

#import "ShareViewController.h"
#import "TumblrCustomShareParameters.h"
#import <XExtensionItem/XExtensionItemParameters.h>

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *item, NSUInteger itemIndex, BOOL *stop) {
        XExtensionItemParameters *parameters = [XExtensionItemParameters parametersFromExtensionItem:item];
        
        [parameters.attachments enumerateObjectsUsingBlock:^(NSItemProvider *itemProvider, NSUInteger attachmentIndex, BOOL *stop) {
            [itemProvider.registeredTypeIdentifiers enumerateObjectsUsingBlock:^(NSString *typeIdentifier, NSUInteger typeIndex, BOOL *stop) {
                [itemProvider loadItemForTypeIdentifier:typeIdentifier options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    NSLog(@"Attachment item: %@", item);
                }];
            }];
        }];
        
        NSLog(@"XExtensionItemParamters: %@", parameters);
        
        UIImage *thumbnail = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:parameters.imageURL]];
        
        if (thumbnail) {
            NSLog(@"Was able to read thumbnail data from URL: %@", parameters.imageURL);
        }
        
        TumblrCustomShareParameters *tumblrParameters = [[TumblrCustomShareParameters alloc] initWithDictionary:parameters.userInfo];
        NSLog(@"Tumblr custom URL slug: %@", tumblrParameters.customURLSlug);
    }];
}

- (BOOL)isContentValid {
    return YES;
}

- (void)didSelectPost {
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    return @[];
}

@end
