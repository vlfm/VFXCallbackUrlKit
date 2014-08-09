#import "AppDelegate.h"

#import "MainViewController.h"
#import "VFXCallbackUrlManager.h"

@implementation AppDelegate {
    VFXCallbackUrlManager *_xCallbackUrlManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _xCallbackUrlManager = [[VFXCallbackUrlManager alloc] initWithScheme:@"vf-x-callbackurl-kit"];
    
    /**
      * Register actions.
      * VFXCallbackUrlNotification will be sent only for registered actions.
      * Processing block can be nil.
    */
    
    [_xCallbackUrlManager registerAction:@"success" requirements:nil processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        NSLog(@"success callback processing block");
    }];
    
    [_xCallbackUrlManager registerAction:@"error" requirements:nil processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        NSLog(@"error callback processing block");
    }];
    
    [_xCallbackUrlManager registerAction:@"cancel" requirements:nil processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        NSLog(@"cancel callback processing block");
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSError *error = nil;
    
    BOOL result = [_xCallbackUrlManager handleUrl:url error:&error];
    
    if (error) {
        NSLog(@"url: %@, error: %@", url.absoluteString, error.localizedDescription);
    }
    
    return result;
}

@end
