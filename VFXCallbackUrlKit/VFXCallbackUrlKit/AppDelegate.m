#import "AppDelegate.h"

#import "MainViewController.h"
#import "VFXCallbackUrlManager.h"

@implementation AppDelegate {
    VFXCallbackUrlManager *_xCallbackUrlManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _xCallbackUrlManager = [[VFXCallbackUrlManager alloc] initWithScheme:@"vf-x-callbackurl-kit"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}

//- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

//- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSError *error = nil;
    
    BOOL result = [_xCallbackUrlManager handleUrl:url action:@"123" requirements:nil processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        NSLog(@"Processing block: after it completes, notification is posted");
        
    } error:&error];
    
    if (error) {
        NSLog(@"url: %@, error: %@", url.absoluteString, error.localizedDescription);
    }
    
    return result;
}

@end
