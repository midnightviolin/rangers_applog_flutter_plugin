#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <RangersAppLog/BDAutoTrack.h>
#import <RangersAppLog/BDAutoTrackConfig.h>
#import <RangersAppLog/BDAutoTrackURLHostItemCN.h>
#import <RangersAppLog/BDAutoTrackDevTools.h>
#import <RangersAppLog/RangersAppLog.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    /* ！注意：如果在此处初始化了，就不要调用插件的initRangersAppLog进行初始化，以免重复初始化出现问题！
     * ! Note: Hereby we init SDK using native Objective-C. You might use `initRangersAppLog` to do the same (the native way is better in performance, though). But don't do both.
     */
    /* 初始化开始。请参考iOS原生接入文档。
     * Init SDK. Please refer to iOS integrate doc on the official website.
     */
//    BDAutoTrackConfig *config =[BDAutoTrackConfig configWithAppID:@"175128" launchOptions:launchOptions];
//    config.serviceVendor = BDAutoTrackServiceVendorCN;
//    config.autoTrackEnabled = NO;
//    config.channel = @"App Store";
//    config.showDebugLog = YES;
//    config.logNeedEncrypt = NO;
//    [BDAutoTrack startTrackWithConfig:config];
    
//    [BDAutoTrackDevTools showFloatingEntryButton];
    return YES;
}

@end
