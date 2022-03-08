# react-native-onepass

[![](https://img.shields.io/npm/v/react-native-onepass.svg?style=flat-square)][npm]
[![](https://img.shields.io/npm/l/react-native-onepass.svg?style=flat-square)][npm]

[npm]: https://www.npmjs.com/package/react-native-onepass

阿里云号码认证一键登录，同时支持IOS和Android

预设5种授权画面风格，可快速集成使用

Portrait 竖屏（全屏模式）

Landscape 横屏（全屏模式）

AlertPortrait 竖屏（弹窗模式）

AlertLandscape 横屏（弹窗模式）

SheetPortrait 竖屏（底部弹窗模式）



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

* [阿里云号码认证及各响应状态码文档](https://help.aliyun.com/document_detail/144231.html)

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
