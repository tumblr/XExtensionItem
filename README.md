# XExtensionItem

XExtensionItem is a tiny library allowing for easier sharing of structured data between iOS applications and share extensions. It is targeted at developers of both share extensions and apps that display a `UIActivityViewController`.

## Why?

Currently, share extensions have an [unfortunate limitation](https://github.com/tumblr/ios-extension-issues/issues/5) which causes only applications that explicitly accept *all* provided activity item types to show up in a `UIActivityViewController`. This makes it difficult to share multiple pieces of data without causing extensions that aren’t as flexible with their allowed inputs to not show up at all. Consider the following example:

* A developer wants their app’s users to be able to share a URL as well as some text to go along with it (perhaps the title of the page, or an excerpt from it). An extension for a read later service like Instapaper might only save the URL, but one for a social network like Tumblr or Twitter could incorporate both.
* The application displays a `UIActivityViewController` and puts both an `NSURL` and `NSString` in its activity items array.
* Only extensions that are explicitly defined to accept both URLs *and* strings will be displayed in the activity controller. To continue the examples from above, Tumblr would but Instapaper would not.

Rather than populating `activityItems` with multiple objects and losing support for inflexible extensions, its best to use a single `NSExtensionItem` with metadata added to it. XExtensionItem makes this easy by exposing an API that provides type-safe access to generic metadata parameters that applications and extensions can populate without needing to worry about the implementation details of the app or extension on the other side of the handshake.

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

Extension developers can also publicize support for custom parameters that apps can pass in a “user info” dictionary. For example, the Tumblr extension might allow an app to pass in a custom URL for a post by populating a user info dictionary like:

```objc
@{ @"tumblr-custom-url": @"/post/123/best-post-ever" }
```

Custom parameter keys should *not* start with `x-extension-item-`, as parameters with this prefix are reserved for use by this library internally.

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
