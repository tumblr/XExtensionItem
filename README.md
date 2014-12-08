# XExtensionItem

XExtensionItem is a tiny library allowing for easier sharing of structured data between iOS applications and share extensions. It is targeted at developers of both share extensions and apps that display a `UIActivityViewController`.

We’d love your [thoughts](/issues) on how XExtensionItem could better achieve its goal of allowing apps to provide generically useful metadata parameters to share extensions. This library’s value comes from how useful it is for *all* apps and extensions. Having been developed by a single contributor thus far, your feedback will be hugely beneficial to me.

:warning::warning::warning: ***XExtensionItem is very much a rough work in progress. We’d love to incorporate feedback from app and extension developers alike, but I’d warn against shipping any code that depends on it until 1.0 is released, signifying that the API has stabilized.*** :warning::warning::warning:

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
* [Contact](#contact)
* [License](#license)

## Why?

Currently, share extensions have an [unfortunate limitation](https://github.com/tumblr/ios-extension-issues/issues/5) which causes only applications that explicitly accept *all* provided activity item types to show up in a `UIActivityViewController`. This makes it difficult to share multiple pieces of data without causing extensions that aren’t as flexible with their allowed inputs to not show up at all. Consider the following example:

* A developer wants their app’s users to be able to share a URL as well as some text to go along with it (perhaps the title of the page, or an excerpt from it). An extension for a read later service like Instapaper might only save the URL, but one for a social network like Tumblr or Twitter could incorporate both.
* The application displays a `UIActivityViewController` and puts both an `NSURL` and `NSString` in its activity items array.
* Only extensions that are explicitly defined to accept both URLs *and* strings will be displayed in the activity controller. To continue the examples from above, Tumblr would be displayed in the activity controller but Instapaper would not.

Rather than populating `activityItems` with multiple objects and losing support for inflexible extensions, its best to use a single `NSExtensionItem` with metadata added to it. XExtensionItem makes this easy by exposing an API that provides type-safe access to generic metadata parameters that applications and extensions can populate without needing to worry about the implementation details of the app or extension on the other side of the handshake.

## Getting started

XExtensionItem will be available via [CocoaPods](http://cocoapods.org) once it gets closer to 1.0 (since who knows, maybe the [name will change](https://github.com/tumblr/XExtensionItem/issues/2) before then).

## Usage

### Generic parameters

XExtensionItem currently supports the following generic parameters (more information on each parameter can be found in the `XExtensionItemParameters` [header documentation](XExtensionItem/XExtensionItemParameters.h)):

* Tags
* Source URL
* Image URL
* Source application
    * Name
    * App store URL
    * Icon URL
* MIME types mapped to alternative content representations

If you have an idea for a parameter that would be broadly useful (e.g. not specific to a specific share extension or service), please create an [issue](/issues) or open a [pull request](/pulls).

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
TumblrExtensionItemParameters *tumblrParams = [[TumblrExtensionItemParameters alloc] initWithCustomURLSlug:@"new-years-resolutions"];

XExtensionItemMutableParameters *mutableParameters = …;
[mutableParameters addEntriesToUserInfo:tumblrParams];
```

We’ll likely include custom parameter classes in this repository in the future, made available in the form of CocoaPods [subspecs](http://guides.cocoapods.org/syntax/podspec.html#group_subspecs).

### Examples

#### Applications

Application developers can use an `XExtensionItemParameters` object when presenting a `UIActivityViewController`:

```objc
XExtensionItemMutableParameters *parameters = [[XExtensionItemMutableParameters alloc] init];
parameters.attachments = @[[[NSItemProvider alloc] initWithItem:[NSURL URLWithString:@"http://apple.com"]
                                                 typeIdentifier:(__bridge NSString *)kUTTypeURL]];
parameters.attributedTitle = [[NSAttributedString alloc] initWithString:@"Apple"];
parameters.attributedContentText = [[NSAttributedString alloc] initWithString:@"iPad Air 2. Change is in the air"];

UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[parameters extensionItemRepresentation]
                                                                         applicationActivities:nil];
```

#### Extensions

Convert incoming `NSExtensionItem` instances retrieved from an extension context into `XExtensionItemParameters` 
objects:

```objc
[self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *item, NSUInteger idx, BOOL *stop) {
    XExtensionItemParameters *parameters = [XExtensionItemParameters parametersFromExtensionItem:item];
    NSAttributedString *title = parameters.attributedTitle;
    NSAttributedString *contentText = parameters.attributedContentText;
    NSArray *tags = parameters.tags;
    NSString *customTumblrURL = parameters.userInfo[@"tumblr-custom-url"];
}];
```

## Apps that use XExtensionItem

Please create a [pull request](/pulls) or [let us know](#contact) if you're using XExtensionItem in either your application or your extension.

## Contact

[Bryan Irace](bryan@tumblr.com)

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
