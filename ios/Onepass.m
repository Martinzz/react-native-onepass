#import "Onepass.h"
#import <React/RCTUtils.h>

#define onAuthUIControlClick @"onAuthUIControlClick"

@interface Onepass()

@property (nonatomic, assign) BOOL isCanUseOneKeyLogin;

@end

@implementation Onepass
{
    bool hasListeners;
}

RCT_EXPORT_MODULE()

+(BOOL)requiresMainQueueSetup {
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#pragma mark - 事件配置
- (NSArray<NSString *> *)supportedEvents {
    // 事件注册
    return @[
        onAuthUIControlClick,
    ];
}

// 发送事件
- (void)sendEvent:(NSString *)name params:(id)params {
 if (hasListeners) {
    [self sendEventWithName:name body:params];
 }
}

- (void) startObserving {
  hasListeners = YES;
}

- (void) stopObserving {
  hasListeners = NO;
}

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}

RCT_REMAP_METHOD(setAuthSDKInfo, initWithKey:(nonnull NSString*)key
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:key
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        resolve(@{
            @"code": [resultDic objectForKey:@"resultCode"],
            @"msg": [resultDic objectForKey:@"msg"]
        });
    }];
}

RCT_REMAP_METHOD(checkAndPrepareEnv,
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    //环境检查，异步返回
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken
                                                           complete:^(NSDictionary * _Nullable resultDic) {
        NSString* code = [resultDic objectForKey:@"resultCode"];
        resolve(@{
            @"code": code,
            @"msg": [resultDic objectForKey:@"msg"]
        });
        if ([PNSCodeSuccess isEqualToString:code]) {
            // 检测成功直接预取号，不需要等待响应
            [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
                NSLog(@"为后面授权页拉起加个速，加速结果：%@", resultDic);
            }];
        }
    }];
}

- (void)gotoSmsControllerAndShowNavBar {

}

- (void)gotoSmsControllerAndHiddenNavBar {

}

RCT_REMAP_METHOD(buildWithStyleGetToken, withStyle:(NSUInteger)style
                 withLayout:(NSDictionary*)layout
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    TXCustomModel *model = [PNSBuildModelUtils buildModelWithStyle:style
                                                            layout: layout
                                                      button1Title:@"短信登录（使用系统导航栏）"
                                                           target1:self
                                                         selector1:@selector(gotoSmsControllerAndShowNavBar)
                                                      button2Title:@"短信登录（隐藏系统导航栏）"
                                                           target2:self
                                                         selector2:@selector(gotoSmsControllerAndHiddenNavBar)];
    __weak typeof(self) weakSelf = self;
    UIViewController* vc = RCTPresentedViewController();
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:vc
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
            // 切换其它登录方式
            if([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]){
                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
            }
            [weakSelf sendEvent:onAuthUIControlClick params:resultDic];
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
            resolve(@{
                @"code": resultCode,
                @"msg": [resultDic objectForKey:@"msg"],
                @"token": [resultDic objectForKey:@"token"]
            });
        } else {
            resolve(@{
                @"code": resultCode,
                @"msg": [resultDic objectForKey:@"msg"]
            });
        }
    }];

}

@end
