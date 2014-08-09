VFXCallbackUrlKit
=================

A library for iOs interapp communication using [x-callback-url](http://x-callback-url.com) specification.

How to send request
=

Create ```VFXCallbackUrlRequest``` object:
```objective-c
VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                   action:@"action"
                                                               parameters:@"action parameters"
                                                                   source:@"x-source here"
                                                          successCallback:@"x-success here"
                                                            errorCallback:@"x-error here"
                                                           cancelCallback:@"x-cancel here"];
```
Get and open ```NSURL``` from request object:
```objective-c
[[UIApplication sharedApplication] openURL:request.asUrl];
```

How to handle request
=
* Create and configure a ```VFXCallbackUrlManager``` object.
   This object will handle incoming requests.

```objective-c
xCallbackUrlManager = [[VFXCallbackUrlManager alloc] initWithScheme:@"your scheme"];
```

* Register a processing block for each action withing a scheme you want to handle

```objective-c
[xCallbackUrlManager registerAction:@"an action" requirements:nil
                    processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
    // here you receive a request object constructed from incoming url
}];
```

* You can define requirements for incoming url with given scheme and action
```objective-c
[xCallbackUrlManager registerAction:@"an action" requirements:^(VFXCallbackUrlRequirements **requirements) {
    (*requirements).sourceRequired = YES;
    (*requirements).successCallbackRequired = YES;
    (*requirements).errorCallbackRequired = YES;
    (*requirements).cancelCallbackRequired = YES;
    (*requirements).requiredParameters = @[@"some parameter"];
        
    } processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        // for each requirement that is not met there is an error in errors array
}];
```

* In AppDelegate tell ```VFXCallbackUrlManager``` to handle an url
```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
    NSError *error = nil;
    
    BOOL result = [xCallbackUrlManager handleUrl:url error:&error];
    
    if (error) {
        //
    }
    
    return result;
}
```

* ```VFXCallbackUrlNotification``` is posted for any handled action.
   After an url was handled (after processing block finishes), this notification is posted
```objective-c
// somewhere, maybe in UIViewController

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xCallbackUrlNotification:)
                                             name:VFXCallbackUrlNotification object:nil];

// notification's object is VFXCallbackUrlRequest instance

- (void)xCallbackUrlNotification:(NSNotification *)n {
    VFXCallbackUrlRequest *request = n.object;
    //
}

```

Simplied incoming requests handling
=

If you support only one action, or sure about what action is going to be handled, you can process url without action registration:
```objective-c
BOOL result = [xCallbackUrlManager handleUrl:url action:@"an action"
                                requirements:nil
                             processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
    // called if action in url mathes with provided action
} error:&error];
```

```VFXCallbackUrlNotification``` is also posted in case of successful handling (after processing block finishes).
