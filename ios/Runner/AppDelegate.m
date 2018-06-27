#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>
#import "Runner-Bridging-Header.h"
#import "Runner-Swift.h"

@interface AppDelegate()
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation AppDelegate {
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    
    /// --------------------------------------------
    /// Navigation
    /// --------------------------------------------
    
    // embed FlutterViewController in container UINavigationController programmatically
    
    // init views
    
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    //MapViewController *nativeView = [[MapViewController alloc] init];
    
    // setup navigator
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.window makeKeyAndVisible];
    
    
    /// --------------------------------------------
    /// Communication Interface
    /// --------------------------------------------
    
    FlutterMethodChannel* nativeCallChannel = [FlutterMethodChannel
                                               methodChannelWithName:@"samples.flutter.io/battery"
                                               binaryMessenger:controller];
    [nativeCallChannel setMethodCallHandler:^(FlutterMethodCall* call,
                                              FlutterResult result) {
        
         NSLog(@"SITI");
       // NSLog([call arguments][@"siti"]);
        
            //result(@("push_pop_view"));
            
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            MapViewController *view_from_board = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            view_from_board.fr = result;
            view_from_board.json_siti = [call arguments][@"siti"] ;
            [self.navigationController pushViewController:view_from_board animated:true];
            
    
    }];
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



@end
