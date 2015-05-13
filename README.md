![XExtensionItem](https://github.com/tumblr/XExtensionItem/blob/master/Assets/logo.png)

# XExtensionItem

[![Build Status](https://img.shields.io/travis/tumblr/XExtensionItem.svg?style=flat)](https://travis-ci.org/tumblr/XExtensionItem)
[![Version](http://img.shields.io/cocoapods/v/XExtensionItem.svg?style=flat)](http://cocoapods.org/?q=XExtensionItem)
[![Platform](http://img.shields.io/cocoapods/p/XExtensionItem.svg?style=flat)]()
[![License](http://img.shields.io/cocoapods/l/XExtensionItem.svg?style=flat)](https://github.com/tumblr/XExtensionItem/blob/master/LICENSE)

XExtensionItem is a tiny library allowing for easier sharing of structured data between iOS applications and share extensions. It is targeted at developers of both share extensions and apps that display a [`UIActivityViewController`](https://developer.apple.com/library/ios/documentation/Uikit/reference/UIActivityViewController_Class/index.html).

We’d love your [thoughts](https://github.com/tumblr/XExtensionItem/issues) on how XExtensionItem could be made more useful. This library’s value comes from how useful it is for apps and extensions of all shapes and sizes.

* [Why?](#why)
* [Getting started](#getting-started)
* [Usage](#usage)
    * [Generic parameters](#generic-parameters)
    * [Custom parameters](#custom-parameters)
        * [Custom parameter classes](#custom-parameter-classes)
    * [Examples](#examples)
        * [Applications](#applications)
        * [Extensions](#extensions)
* [Apps that use XExtensionItem](#apps-that-use-xextensionitem)
* [Contributing](#contributing)
* [Contact](#contact)
* [License](#license)

## Why?

Currently, share extensions have an [unfortunate limitation](https://github.com/tumblr/ios-extension-issues/issues/5) which causes only applications that explicitly accept *all* provided activity item types to show up in a `UIActivityViewController`. This makes it difficult to share multiple pieces of data without causing extensions that aren’t as flexible with their allowed inputs to not show up at all. Consider the following example:

* A developer wants their app’s users to be able to share a URL as well as some text to go along with it (perhaps the title of the page, or an excerpt from it). An extension for a read later service like Instapaper might only save the URL, but one for a social network like Tumblr or Twitter could incorporate both.
* The application displays a `UIActivityViewController` and puts both an `NSURL` and `NSString` in its activity items array.
* Only extensions that are explicitly defined to accept both URLs *and* strings will be displayed in the activity controller. To continue the examples from above, Tumblr would be displayed in the activity controller but Instapaper would not.

Rather than passing in multiple activity items and losing support for inflexible extensions, its best to use a single `NSExtensionItem` that encapsulates multiple attachments and additional metadata as well. This can be difficult to get exactly right, however. XExtensionItem makes this easy by providing a layer of abstraction on these compmlicated APIs, dealing with all of their intricacies so you don’t have to.

Apps should be able to pass rich, structured attachments and metadata to extensions without worrying about the implementation details on the other end of the handshake. XExtensionItem facilitates exactly this.

## Getting started

XExtensionItem is available through your Objective-C package manager of choice:

### CocoaPods

Simply add the following to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```
pod 'XExtensionItem'
```

### Carthage

Simply add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "tumblr/XExtensionItem"
```

## Usage

You may currently be initializing your `UIActivityViewController` instances like this:

```objc
[[UIActivityViewController alloc] initWithActivityItems:@[URL, string, image] applicationActivities:nil];
```

As outlined above, this is problematic because your users will only be presented with extensions that explicitly accept URLs _and_ strings _and_ images. XExtensionItem provides a better way.

```objc
XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithURL:URL];
itemSource.additionalAttachments = @[string, image];

[[UIActivityViewController alloc] initWithActivityItems:@[itemSource] applicationActivities:nil];
```

Now, all extensions and system activities that at least accept URLs will be displayed, but all three attachments will be passed to the one that the user selects.








Simply populate an `XExtensionItemSource` with a placeholder item and an array of attachments. The placeholder’s type will determine which system activities and share extensions are available for the user to choose from, while the whole array of attachments will be passed to whichever one the user ends up selecting.

### Generic parameters

XExtensionItem currently supports the following generic parameters (more information on each parameter can be found in the `XExtensionItemParameters` [header documentation](XExtensionItem/XExtensionItemParameters.h)):

* Tags
* Source URL
* Source application
    * Name
    * App store ID

If you have an idea for a parameter that would be broadly useful (e.g. not specific to a specific share extension or service), please create an [issue](https://github.com/tumblr/XExtensionItem/issues) or open a [pull request](https://github.com/tumblr/XExtensionItem/pulls).

### Custom parameters

Extension developers can also publicize support for custom parameters that apps can pass in an extension item’s “user info” dictionary. For example, the Tumblr extension might allow an app to pass in a custom URL using a user info dictionary that looks as follows:

```objc
@{ @"tumblr-custom-url": @"/post/123/best-post-ever" }
```

Custom parameter keys *should* be name-spaced and *should not* start with `x-extension-item-`, as parameters with this prefix are reserved for use by this library internally.

Have a look at the [apps that use XExtensionItem](#apps-that-use-xextensionitem) section for a list of the supported custom parameters that we know about.

#### Custom parameter classes

Extension developers can provide concrete implementations of classes that conform to `XExtensionItemDictionarySerializing` to make it even easier for application developers to add support for their custom parameters.

```objc
// Provided by Tumblr. Allows app developers to avoid hardcoding key names
TumblrExtensionItemParameters *tumblrParameters = [[TumblrExtensionItemParameters alloc] initWithCustomURLSlug:@"new-years-resolutions"];

XExtensionItemSource *itemSource = …;
[itemSource addEntriesToUserInfo:tumblrParameters];
```

We’ll likely include custom parameter classes in this repository in the future, made available in the form of CocoaPods [subspecs](http://guides.cocoapods.org/syntax/podspec.html#group_subspecs).

### Examples

This repository includes a [sample project](https://github.com/tumblr/XExtensionItem/tree/master/Example) which may help explain how the library is to be used. It has targets for both a share extension and an application; you can run the former using the latter as the host application and see [the data from the application](https://github.com/tumblr/XExtensionItem/blob/master/Example/XExtensionItemExample/ViewController.m#L23) get [passed through to the extension](https://github.com/tumblr/XExtensionItem/blob/master/Example/XExtensionItemShareExtensionExample/ShareViewController.m#L10).

Here’s a [hypothetical example](https://github.com/tumblr/XExtensionItem/wiki/Hypothetical-Tumblr-XExtensionItem-integration-documentation) of how XExtensionItem’s parameters could map to values that the Tumblr iOS share extension would consume.

#### Applications

Application developers can use an `XExtensionItemParameters` object when presenting a `UIActivityViewController`:

```objc
/*
 At the very least, we want to share a URL outwards. We’ll also send a photo and some other metadata in case the 
receiving app knows to look for those, but this URL will be what activities and extensions receive by default.
*/
 
NSURL *URL = [NSURL URLWithString:@"http://apple.com/featured"];
UIImage *image = [UIImage imageNamed:@"tumblr-featured-on-apple-homepage.png"];

XExtensionItemSource *itemSource = [[XExtensionItemSource alloc] initWithPlaceholder:URL
                                                                         attachments:@[
   [[NSItemProvider alloc] initWithItem:URL typeIdentifier:(__bridge NSString *)kUTTypeURL],
   [[NSItemProvider alloc] initWithItem:image typeIdentifier:(__bridge NSString *)kUTTypeImage],
]];

itemSource.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tumblr featured on Apple.com!"];
itemSource.tags = @[@"tumblr", @"featured", @"so cool"];

UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[itemSource]
                                                                         applicationActivities:nil];
```

#### Extensions

Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItemParameters` 
objects:

```objc
 for (NSExtensionItem *inputItem in self.extensionContext.inputItems) {
    XExtensionItem *extensionItem = [[XExtensionItem alloc] initWithExtensionItem:inputItem];
    NSAttributedString *title = extensionItem.attributedTitle;
    NSAttributedString *contentText = extensionItem.attributedContentText;
    NSArray *tags = extensionItem.tags;
    NSString *customTumblrURL = extensionItem.userInfo[@"tumblr-custom-url"];
 }
```

## Apps that use XExtensionItem

Please create a [pull request](https://github.com/tumblr/XExtensionItem/pulls) or [let us know](#contact) if you're using XExtensionItem in either your application or your extension.

## Contributing

Please see [CONTRIBUTING.md](https://github.com/tumblr/XExtensionItem/blob/master/CONTRIBUTING.md) for information on how to help out.

## Contact

[Bryan Irace](mailto:bryan@tumblr.com)

## License

Copyright 2014 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the “License”); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
> WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
> License for the specific language governing permissions and limitations under
> the License.
