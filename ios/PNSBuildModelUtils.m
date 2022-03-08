//
//  PNSBuildModelUtils.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import "PNSBuildModelUtils.h"

@implementation PNSBuildModelUtils

+ (TXCustomModel *)buildModelWithStyle:(PNSBuildModelStyle)style
                                layout:(NSDictionary*)layout
                          button1Title:(NSString *)button1Title
                               target1:(id)target1
                             selector1:(SEL)selector1
                          button2Title:(NSString *)button2Title
                               target2:(id)target2
                             selector2:(SEL)selector2 {
    TXCustomModel *model = nil;
    switch (style) {
        case PNSBuildModelStylePortrait:
            model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                                layout:layout
                                                               target1:target1
                                                             selector1:selector1
                                                          button2Title:button2Title
                                                               target2:target2
                                                             selector2:selector2];
            break;
        case PNSBuildModelStyleLandscape:
            model = [self buildFullScreenLandscapeModelWithButton1Title:button1Title
                                                                 layout:layout
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
            break;
        case PNSBuildModelStyleAlertPortrait:
            model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                          layout:layout
                                                         target1:target1
                                                       selector1:selector1
                                                    button2Title:button2Title
                                                         target2:target2
                                                       selector2:selector2];
            break;
        case PNSBuildModelStyleAlertLandscape:
            model = [self buildAlertLandscapeModeWithButton1Title:button1Title
                                                           layout:layout
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSBuildModelStyleSheetPortrait:
            model = [self buildSheetPortraitModelWithButton1Title:button1Title
                                                           layout:layout
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSDIYAlertPortraitFade:
            model = [self buildAlertFadeModelWithButton1Title:button1Title
                                                       layout:layout
                                                      target1:target1
                                                    selector1:selector1
                                                 button2Title:button2Title
                                                      target2:target2
                                                    selector2:selector2];
            break;
        case PNSDIYAlertPortraitBounce:
            model = [self buildAlertBounceModelWithButton1Title:button1Title
                                                         layout:layout
                                                        target1:target1
                                                      selector1:selector1
                                                   button2Title:button2Title
                                                        target2:target2
                                                      selector2:selector2];
            break;
        case PNSDIYAlertPortraitDropDown:
            model = [self buildAlertDropDownModelWithButton1Title:button1Title
                                                           layout:layout
                                                          target1:target1
                                                        selector1:selector1
                                                     button2Title:button2Title
                                                          target2:target2
                                                        selector2:selector2];
            break;
        case PNSDIYPortraitFade:
            model = [self buildFadeModelWithButton1Title:button1Title
                                                  layout:layout
                                                 target1:target1
                                               selector1:selector1
                                            button2Title:button2Title
                                                 target2:target2
                                               selector2:selector2];
            break;
        case PNSDIYPortraitScale:
            model = [self buildScaleModelWithButton1Title:button1Title
                                                   layout:layout
                                                  target1:target1
                                                selector1:selector1
                                             button2Title:button2Title
                                                  target2:target2
                                                selector2:selector2];
            break;
        default:
            break;
    }
    return model;
}

+(UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(PNSBuildFrameBlock)getFrameBlock:(NSDictionary*)dict
{
    return ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        NSString* width = [dict objectForKey:@"width"];
        NSString* height = [dict objectForKey:@"height"];
        NSString* x = [dict objectForKey:@"x"];
        NSString* y = [dict objectForKey:@"y"];
        if(width != nil)frame.size.width = [width floatValue];
        if(height != nil)frame.size.height = [height floatValue];
        if(x != nil)frame.origin.x = [x floatValue];
        if(y != nil)frame.origin.y = [y floatValue];
        return frame;
    };
}

+(void)setUILayout:(TXCustomModel*) model
      withLayout:(NSDictionary*)layout
        withFull:(BOOL)full
{
    // 全屏规范
    if(full){
        NSString* navIsHidden = [layout objectForKey: @"navIsHidden"];
        if(navIsHidden != nil)model.navIsHidden = [navIsHidden boolValue];
        
        NSString* navColor = [layout objectForKey: @"navColor"];
        if (navColor != nil)model.navColor = [self colorWithHexString: navColor];
        
        NSDictionary *navTitle = [layout objectForKey: @"navTitle"];
        if(navTitle != nil){
            NSDictionary *attributes = @{
                NSForegroundColorAttributeName : [self colorWithHexString: navTitle[@"color"]],
                NSFontAttributeName : [UIFont systemFontOfSize: [navTitle[@"size"] floatValue]]
            };
            model.navTitle = [[NSAttributedString alloc] initWithString:navTitle[@"text"] attributes:attributes];
        }
        
        NSString* navBackImage = [layout objectForKey: @"navBackImage"];
        if (navBackImage != nil)model.navBackImage = [UIImage imageNamed:navBackImage];
        NSString* hideNavBackItem = [layout objectForKey: @"hideNavBackItem"];
        if(hideNavBackItem != nil)model.hideNavBackItem = [hideNavBackItem boolValue];
        
        NSString* privacyNavColor = [layout objectForKey: @"privacyNavColor"];
        if(privacyNavColor != nil)model.privacyNavColor = [self colorWithHexString: privacyNavColor];
        NSString* privacyNavTitleColor = [layout objectForKey: @"privacyNavTitleColor"];
        if(privacyNavTitleColor != nil)model.privacyNavTitleColor = [self colorWithHexString: privacyNavTitleColor];
        NSString* privacyNavTitleSize = [layout objectForKey: @"privacyNavTitleSize"];
        if(privacyNavTitleSize != nil)model.privacyNavTitleFont = [UIFont systemFontOfSize:[privacyNavTitleSize floatValue]];
        NSString* privacyNavBackImage = [layout objectForKey: @"privacyNavBackImage"];
        if(privacyNavBackImage != nil)model.privacyNavBackImage = [UIImage imageNamed:privacyNavBackImage];
    }else{
        NSString* alertTitleBarColor = [layout objectForKey: @"alertTitleBarColor"];
        if(alertTitleBarColor != nil){
            model.alertTitleBarColor = [self colorWithHexString: alertTitleBarColor];
        }else{
            model.alertTitleBarColor = [self colorWithHexString: @"#ffffff"];
        }
        NSString* alertBarIsHidden = [layout objectForKey: @"alertBarIsHidden"];
        if(alertBarIsHidden != nil)model.alertBarIsHidden = [alertBarIsHidden boolValue];
        NSDictionary *alertTitle = [layout objectForKey: @"alertTitle"];
        if(alertTitle != nil){
            NSDictionary *attributes = @{
                NSForegroundColorAttributeName : [self colorWithHexString: alertTitle[@"color"]],
                NSFontAttributeName : [UIFont systemFontOfSize: [alertTitle[@"size"] floatValue]]
            };
            model.alertTitle = [[NSAttributedString alloc] initWithString:alertTitle[@"text"] attributes:attributes];
        }
        NSString* alertCloseImage = [layout objectForKey: @"alertCloseImage"];
        if(alertCloseImage != nil)model.alertCloseImage = [UIImage imageNamed:alertCloseImage];
        
        NSString* alertCloseItemIsHidden = [layout objectForKey: @"alertCloseItemIsHidden"];
        if(alertCloseItemIsHidden != nil)model.alertCloseItemIsHidden = [alertCloseItemIsHidden boolValue];
    }
    NSDictionary *sloganText = [layout objectForKey: @"sloganText"];
    if(sloganText != nil){
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName : [self colorWithHexString: sloganText[@"color"]],
            NSFontAttributeName : [UIFont systemFontOfSize: [sloganText[@"size"] floatValue]]
        };
        model.sloganText = [[NSAttributedString alloc] initWithString:sloganText[@"text"] attributes:attributes];
    }
    
    NSDictionary *loginBtnText = [layout objectForKey: @"loginBtnText"];
    if(loginBtnText != nil){
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName : [self colorWithHexString: loginBtnText[@"color"]],
            NSFontAttributeName : [UIFont systemFontOfSize: [loginBtnText[@"size"] floatValue]]
        };
        model.loginBtnText = [[NSAttributedString alloc] initWithString:loginBtnText[@"text"] attributes:attributes];
    }
    
    NSArray* loginBtns = [layout mutableArrayValueForKey: @"loginBtnBgImgs"];
    if(loginBtns != nil && loginBtns.count == 3)model.loginBtnBgImgs = [NSArray arrayWithObjects:[UIImage imageNamed:loginBtns[0]],[UIImage imageNamed:loginBtns[1]],[UIImage imageNamed:loginBtns[2]], nil];
    
    NSDictionary *changeBtnTitle = [layout objectForKey: @"changeBtnTitle"];
    if(changeBtnTitle != nil){
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName : [self colorWithHexString: changeBtnTitle[@"color"]],
            NSFontAttributeName : [UIFont systemFontOfSize: [changeBtnTitle[@"size"] floatValue]]
        };
        model.changeBtnTitle = [[NSAttributedString alloc] initWithString:changeBtnTitle[@"text"] attributes:attributes];
    }
    NSString *changeBtnIsHidden = [layout objectForKey: @"changeBtnIsHidden"];
    if(changeBtnIsHidden != nil)model.changeBtnIsHidden = [changeBtnIsHidden boolValue];
    
    NSString *prefersStatusBarHidden = [layout objectForKey: @"prefersStatusBarHidden"];
    if(prefersStatusBarHidden != nil)model.prefersStatusBarHidden = [prefersStatusBarHidden boolValue];
    
    NSString *preferredStatusBarStyle = [layout objectForKey: @"preferredStatusBarStyle"];
    if(preferredStatusBarStyle != nil)model.preferredStatusBarStyle = [preferredStatusBarStyle integerValue];
    
    NSString *logoImage = [layout objectForKey: @"logoImage"];
    if(logoImage != nil)model.logoImage = [UIImage imageNamed:logoImage];;
    
    NSString *logoIsHidden = [layout objectForKey: @"logoIsHidden"];
    if(logoIsHidden != nil)model.logoIsHidden = [logoIsHidden boolValue];;
    
    NSString* numberColor = [layout objectForKey: @"numberColor"];
    if(numberColor != nil)model.numberColor = [self colorWithHexString: numberColor];
    
    NSString* numberFontSize = [layout objectForKey: @"numberFontSize"];
    if(numberFontSize != nil)model.numberFont = [UIFont systemFontOfSize:[numberFontSize floatValue]];
    NSArray* checkBoxImages = [layout mutableArrayValueForKey: @"checkBoxImages"];
    if(checkBoxImages != nil && checkBoxImages.count == 2)model.checkBoxImages = [NSArray arrayWithObjects:[UIImage imageNamed:checkBoxImages[0]],[UIImage imageNamed:checkBoxImages[1]], nil];
    NSString* checkBoxIsChecked = [layout objectForKey: @"checkBoxIsChecked"];
    if(checkBoxIsChecked != nil)model.checkBoxIsChecked = [checkBoxIsChecked boolValue];
    NSString* checkBoxIsHidden = [layout objectForKey: @"checkBoxIsHidden"];
    if(checkBoxIsHidden != nil)model.checkBoxIsHidden = [checkBoxIsHidden boolValue];
    NSString* checkBoxWH = [layout objectForKey: @"checkBoxWH"];
    if(checkBoxWH != nil)model.checkBoxWH = [checkBoxWH floatValue];
    
    NSArray* privacyOne = [layout mutableArrayValueForKey: @"privacyOne"];
    if(privacyOne != nil && privacyOne.count == 2)model.privacyOne = privacyOne;
    NSArray* privacyTwo = [layout mutableArrayValueForKey: @"privacyTwo"];
    if(privacyTwo != nil && privacyTwo.count == 2)model.privacyTwo = privacyTwo;
    
    NSArray* privacyColors = [layout mutableArrayValueForKey: @"privacyColors"];
    if(privacyColors != nil && privacyColors.count == 2)model.privacyColors = @[[self colorWithHexString: privacyColors[0]], [self colorWithHexString: privacyColors[1]]];
    
    NSString* privacyAlignment = [layout objectForKey: @"privacyAlignment"];
    if(privacyAlignment != nil)model.privacyAlignment = [privacyAlignment integerValue];
    NSString* privacyPreText = [layout objectForKey: @"privacyPreText"];
    if(privacyPreText != nil)model.privacyPreText = privacyPreText;
    NSString* privacySufText = [layout objectForKey: @"privacySufText"];
    if(privacySufText != nil)model.privacySufText = privacySufText;
    NSString* privacyOperatorPreText = [layout objectForKey: @"privacyOperatorPreText"];
    if(privacyOperatorPreText != nil)model.privacyOperatorPreText = privacyOperatorPreText;
    NSString* privacyOperatorSufText = [layout objectForKey: @"privacyOperatorSufText"];
    if(privacyOperatorSufText != nil)model.privacyOperatorSufText = privacyOperatorSufText;
    
    NSString* privacyFontSize = [layout objectForKey: @"privacyFontSize"];
    if(privacyFontSize != nil)model.privacyFont = [UIFont systemFontOfSize:[privacyFontSize floatValue]];
    NSDictionary* logoFrameBlock = [layout objectForKey: @"logoFrameBlock"];
    if(logoFrameBlock != nil){
        model.logoFrameBlock = [self getFrameBlock:logoFrameBlock];
    }
    NSDictionary* numberFrameBlock = [layout objectForKey: @"numberFrameBlock"];
    if(numberFrameBlock != nil)model.numberFrameBlock = [self getFrameBlock:numberFrameBlock];
    NSDictionary* loginBtnFrameBlock = [layout objectForKey: @"loginBtnFrameBlock"];
    if(loginBtnFrameBlock != nil)model.loginBtnFrameBlock = [self getFrameBlock:loginBtnFrameBlock];
    
    NSDictionary* changeBtnFrameBlock = [layout objectForKey: @"changeBtnFrameBlock"];
    if(changeBtnFrameBlock != nil)model.changeBtnFrameBlock = [self getFrameBlock:changeBtnFrameBlock];
    NSDictionary* sloganFrameBlock = [layout objectForKey: @"sloganFrameBlock"];
    if(sloganFrameBlock != nil)model.sloganFrameBlock = [self getFrameBlock:sloganFrameBlock];
    
    NSDictionary* contentViewFrameBlock = [layout objectForKey: @"contentViewFrameBlock"];
    if(contentViewFrameBlock != nil)model.contentViewFrameBlock = [self getFrameBlock:contentViewFrameBlock];
}

#pragma mark - 全屏相关

+ (TXCustomModel *)buildFullScreenPortraitModelWithButton1Title:(NSString *)button1Title
                                                         layout:(NSDictionary*)layout
                                                        target1:(id)target1
                                                      selector1:(SEL)selector1
                                                   button2Title:(NSString *)button2Title
                                                        target2:(id)target2
                                                      selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    [self setUILayout:model withLayout:layout withFull:YES];
    return model;
}

+ (TXCustomModel *)buildFullScreenLandscapeModelWithButton1Title:(NSString *)button1Title
                                                          layout:(NSDictionary*)layout
                                                         target1:(id)target1
                                                       selector1:(SEL)selector1
                                                    button2Title:(NSString *)button2Title
                                                         target2:(id)target2
                                                       selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.sloganIsHidden = YES;
    model.changeBtnIsHidden = YES;
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 15;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 15 + 80 + 15;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20;
        frame.size.width = superViewSize.width * 0.6;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 110 + 30 + 20 + 70;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        return frame;
    };
    [self setUILayout:model withLayout:layout withFull:YES];
    return model;
}

#pragma mark - 弹窗

+ (TXCustomModel *)buildAlertPortraitModeWithButton1Title:(NSString *)button1Title
                                                   layout:(NSDictionary*)layout
                                                  target1:(id)target1
                                                selector1:(SEL)selector1
                                             button2Title:(NSString *)button2Title
                                                  target2:(id)target2
                                                selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width * 0.8;
        frame.size.height = frame.size.width / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30 + 60;
        return frame;
    };
    [self setUILayout:model withLayout:layout withFull:NO];
    return model;
}

+ (TXCustomModel *)buildAlertLandscapeModeWithButton1Title:(NSString *)button1Title
                                                    layout:(NSDictionary*)layout
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    model.alertCornerRadiusArray = @[@10, @10, @10, @10];
    
    model.logoIsHidden = YES;
    model.sloganIsHidden = YES;
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.height = superViewSize.height * 0.8;
        frame.size.width = frame.size.height / 0.618;
        frame.origin.x = (superViewSize.width - frame.size.width) * 0.5;
        frame.origin.y = (superViewSize.height - frame.size.height) * 0.5;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30 + 20 + 30;
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 30 + 20 + 30 + 60;
        return frame;
    };
    
    [self setUILayout:model withLayout:layout withFull:NO];
    return model;
}

#pragma mark - 底部弹窗

+ (TXCustomModel *)buildSheetPortraitModelWithButton1Title:(NSString *)button1Title
                                                    layout:(NSDictionary*)layout
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.alertCornerRadiusArray = @[@10, @0, @0, @10];
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = superViewSize.width;
        frame.size.height = 460;
        frame.origin.x = 0;
        frame.origin.y = superViewSize.height - frame.size.height;
        return frame;
    };
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width = 80;
        frame.size.height = 80;
        frame.origin.y = 20;
        frame.origin.x = (superViewSize.width - 80) * 0.5;
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 20 + 80 + 20;
        return frame;
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 120 + 20 + 15;
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30;
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = 155 + 20 + 30 + 60;
        return frame;
    };
    [self setUILayout:model withLayout:layout withFull:NO];
    return model;
}

#pragma mark - DIY 动画
+ (TXCustomModel *)buildAlertFadeModelWithButton1Title:(NSString *)button1Title
                                                layout:(NSDictionary*)layout
                                               target1:(id)target1
                                             selector1:(SEL)selector1
                                          button2Title:(NSString *)button2Title
                                               target2:(id)target2
                                             selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                 layout:layout
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @1.03;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    //背景本身就是渐变，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildAlertBounceModelWithButton1Title:(NSString *)button1Title
                                                  layout:(NSDictionary*)layout
                                                 target1:(id)target1
                                               selector1:(SEL)selector1
                                            button2Title:(NSString *)button2Title
                                                 target2:(id)target2
                                               selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                 layout:layout
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    CAKeyframeAnimation *entryAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.values = @[@0.01, @1.2, @0.9, @1];
    entryAnimation.keyTimes = @[@0, @0.4, @0.6, @1];
    entryAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    entryAnimation.duration = 0.25;
    model.entryAnimation = entryAnimation;
    
    CAKeyframeAnimation *exitAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.values = @[@1, @1.2, @0.01];
    exitAnimation.keyTimes = @[@0, @0.4, @1];
    exitAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    exitAnimation.duration = 0.25;
    model.exitAnimation = exitAnimation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildAlertDropDownModelWithButton1Title:(NSString *)button1Title
                                                    layout:(NSDictionary*)layout
                                                   target1:(id)target1
                                                 selector1:(SEL)selector1
                                              button2Title:(NSString *)button2Title
                                                   target2:(id)target2
                                                 selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildAlertPortraitModeWithButton1Title:button1Title
                                                                 layout:layout
                                                                target1:target1
                                                              selector1:selector1
                                                           button2Title:button2Title
                                                                target2:target2
                                                              selector2:selector2];
    
    //提前设置好弹窗大小，弹窗是依赖于全屏布局，所以其父视图大小即为屏幕大小
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.8;
    CGFloat height = width / 0.618;
    CGFloat x = (UIScreen.mainScreen.bounds.size.width - width) * 0.5;
    CGFloat y = (UIScreen.mainScreen.bounds.size.height - height) * 0.5;
    CGRect contentViewFrame = CGRectMake(x, y, width, height);
    
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return contentViewFrame;
    };
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.values = @[@(-CGRectGetMaxY(contentViewFrame)), @20, @-10, @0];
    animation.keyTimes = @[@0, @0.5, @0.75, @1];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.25;
    model.entryAnimation = animation;
    
    //背景使用默认的渐变效果，可以省略不写 model.bgEntryAnimation、model.bgExitAnimation
    return model;
}

+ (TXCustomModel *)buildFadeModelWithButton1Title:(NSString *)button1Title
                                           layout:(NSDictionary*)layout
                                          target1:(id)target1
                                        selector1:(SEL)selector1
                                     button2Title:(NSString *)button2Title
                                          target2:(id)target2
                                        selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                                       layout:layout
                                                                      target1:target1
                                                                    selector1:selector1
                                                                 button2Title:button2Title
                                                                      target2:target2
                                                                    selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    entryAnimation.fromValue = @0.5;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    model.exitAnimation = exitAnimation;
    
    return model;
}

+ (TXCustomModel *)buildScaleModelWithButton1Title:(NSString *)button1Title
                                            layout:(NSDictionary*)layout
                                           target1:(id)target1
                                         selector1:(SEL)selector1
                                      button2Title:(NSString *)button2Title
                                           target2:(id)target2
                                         selector2:(SEL)selector2 {
    
    TXCustomModel *model = [self buildFullScreenPortraitModelWithButton1Title:button1Title
                                                                       layout:layout
                                                                      target1:target1
                                                                    selector1:selector1
                                                                 button2Title:button2Title
                                                                      target2:target2
                                                                    selector2:selector2];
    
    CABasicAnimation *entryAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    entryAnimation.fromValue = @0;
    entryAnimation.toValue = @1;
    entryAnimation.duration = 0.25;
    entryAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    model.entryAnimation = entryAnimation;
    
    CABasicAnimation *exitAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    exitAnimation.fromValue = @1;
    exitAnimation.toValue = @0;
    exitAnimation.duration = 0.25;
    exitAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    model.exitAnimation = exitAnimation;
    
    return model;
}

@end
