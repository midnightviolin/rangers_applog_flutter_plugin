#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <RangersAppLog/RangersAppLog.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
   
    // ！注意：如果在此处初始化了，就不要调用插件的initRangersAppLog进行初始化，以免重复初始化出现问题！
    /* 初始化开始 */
    BDAutoTrackConfig *config =[BDAutoTrackConfig configWithAppID:@"your appID"];// 如不清楚请联系专属客户成功经理
          
    /* 数据上报*/
    config.serviceVendor = BDAutoTrackServiceVendorCN;

    config.appName = @"your appName"; // 与您申请APPID时的app_name一致
    config.channel = @"App Store"; // iOS一般默认App Store
    
    config.showDebugLog = NO; // 是否在控制台输出日志，仅调试使用。release版本请设置为 NO
    config.logger = ^(NSString * _Nullable log) {
        NSLog(@"%@",log);
    };
    config.logNeedEncrypt = YES; // 是否加密日志，默认加密。release版本请设置为 YES

    [BDAutoTrack startTrackWithConfig:config];
    /* 初始化结束 */
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
