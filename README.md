# react-native-onepass

[![](https://img.shields.io/npm/v/react-native-onepass.svg?style=flat-square)][npm]
[![](https://img.shields.io/npm/l/react-native-onepass.svg?style=flat-square)][npm]

[npm]: https://www.npmjs.com/package/react-native-onepass

阿里云号码认证一键登录，同时支持IOS和Android

预设5种授权画面风格，可快速集成使用

BuildModelStyle.Portrait 竖屏（全屏模式）

BuildModelStyle.Landscape 横屏（全屏模式）

BuildModelStyle.AlertPortrait 竖屏（弹窗模式）

BuildModelStyle.AlertLandscape 横屏（弹窗模式）

BuildModelStyle.SheetPortrait 竖屏（底部弹窗模式）



## 安装（React Native >= 0.60.0）

```sh
npm install react-native-onepass
```
打开ios目录运行

```sh
pod install
```

## 使用

```js
import Onepass from "react-native-onepass";

// ...

// 1.设置秘钥，阿里云生成，区分ios/android
await Onepass.setAuthSDKInfo(
  Platform.OS === 'ios' ? keys.iosKey : keys.androidKey
);

// 2.非进入app就需要登录场景，可调用该方法加速取号
const res = await Onepass.checkAndPrepareEnv();

// ios 和 android SDK返回码不一致，参考官方文档
if (res.code === '600000' || res.code === '600024') {
  console.log('终端环境检查⽀持认证');
}

// ...

// 3.授权页各点击事件回调
Onepass.addAuthUIControlClickListener((args) => {
  console.log(args);
});

// 移除事件
Onepass.removeAuthUIControlClickListener();


// 4.设置授权页样式并弹出授权页获取token
const res = await Onepass.buildWithStyleGetToken(style, {
      navColor: '#263a97',
      navTitle: {
        text: '一键登录/注册',
        size: 20,
        color: '#ffffff',
      },
      privacyAlignment: PrivacyAlignment.AlignmentLeft,
      privacyNavColor: '#263a97',
      alertTitle: {
        text: '一键登录/注册',
        size: 16,
        color: '#000000',
      },
      changeBtnTitle: {
        text: '其它登录方式',
        size: 16,
        color: '#263a97',
      },
      privacyColors: ['#000000', '#263a97'],
      preferredStatusBarStyle: StatusBarStyle.UIStatusBarStyleLightContent,
      navBackImage: 'icon_nav_back_light',
      logoImage: 'taobao',
      privacyOne: ['协议1', 'https://www.taobao.com'],
    });
    // 获取token成功
    if (res.code === '600000') {
      console.log(res);
    } else {
      console.log(res);
    }
```
## 布局参数
```js
{
  navIsHidden?: boolean; // 全屏模式导航栏是否隐藏
  navColor?: string; // 导航栏主题色
  navTitle?: Font; // 导航栏标题文字
  navBackImage?: string; // 导航返回按钮图片名
  hideNavBackItem?: boolean; // 隐藏返回按钮
  privacyNavColor?: string; // 协议详情页导航栏背景色
  privacyNavTitleColor?: string; // 协议详情页导航栏标题文字颜色
  privacyNavTitleSize?: number; // 协议详情页导航栏标题文字大小
  privacyNavBackImage?: string; // 协议详情页导航栏返回图片
  sloganText?: Font; // slogan文案文字
  loginBtnText?: Font; // slogan文案文字
  loginBtnBgImgs?: [string, string, string]; // 登录按钮图片组 @[激活状态的图片,失效状态的图片,高亮状态的图片]
  changeBtnTitle?: Font; // 切换按钮文字
  changeBtnIsHidden?: boolean; // 切换按钮是否隐藏
  prefersStatusBarHidden?: boolean; // 状态栏是否隐藏
  preferredStatusBarStyle?: StatusBarStyle; // 状态栏主题风格，默认黑色
  logoImage?: string; // logo图片
  logoIsHidden?: boolean; // logo是否隐藏
  numberColor?: string; // 掩码颜色
  numberFontSize?: number; // 号码字体大小设置，大小小于16则不生效
  checkBoxImages?: [string, string]; // checkBox图片组，[uncheckedImg,checkedImg]
  checkBoxIsChecked?: boolean; // checkBox是否勾选，默认NO
  checkBoxIsHidden?: boolean; // checkBox是否隐藏，默认NO
  checkBoxWH?: number; // checkBox大小，高宽一样，必须大于0
  privacyOne?: [string, string]; // 协议1，[协议名称,协议Url]，注：三个协议名称不能相同
  privacyTwo?: [string, string]; // 协议2，[协议名称,协议Url]，注：三个协议名称不能相同
  privacyColors?: [string, string]; // 协议内容颜色数组，[非点击文案颜色，点击文案颜色]
  privacyAlignment?: PrivacyAlignment; // 协议文案支持居中、居左设置，默认居左
  privacyPreText?: string; // 协议整体文案，前缀部分文案
  privacySufText?: string; // 协议整体文案，后缀部分文案
  privacyOperatorPreText?: string; // 运营商协议名称前缀文案，仅支持 <([《（【『
  privacyOperatorSufText?: string; // 运营商协议名称后缀文案，仅支持 >)]》）】』
  privacyFontSize?: number; // 协议整体文案字体大小，小于12.0不生效
  // 弹窗样式
  alertTitleBarColor?: string; // 弹窗标题栏背景颜色
  alertBarIsHidden?: boolean; // 弹窗标题栏是否隐藏，默认NO
  // 文字，颜色，大小同时设置才生效
  alertTitle?: Font;
  alertCloseImage?: string; // 标题栏右侧关闭按钮图片设
  alertCloseItemIsHidden?: boolean; // 标题栏右侧关闭按钮是否显示，默认NO
  logoFrameBlock?: FrameBlock; // logo 位置大小
  numberFrameBlock?: Position; // 掩码位置大小
  loginBtnFrameBlock?: FrameBlock; // 登录按钮位置大小
  changeBtnFrameBlock?: Position; // 切换按钮位置大小
  sloganFrameBlock?: Position; // slogan位置大小
  contentViewFrameBlock?: FrameBlock; // contentView位置大小
}
```

* [阿里云号码认证及各响应状态码文档](https://help.aliyun.com/document_detail/144231.html)

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
