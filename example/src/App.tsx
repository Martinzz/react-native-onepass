import * as React from 'react';

import { Button, Platform, StyleSheet, Text, View } from 'react-native';
import Onepass, {
  BuildModelStyle,
  PrivacyAlignment,
  StatusBarStyle,
} from 'react-native-onepass';

import keys from './keys'; // 阿里云认证密钥

export default function App() {
  const [result, setResult] = React.useState<any>();
  // 预取号，加速取号
  const preload = async () => {
    // 设置秘钥
    await Onepass.setAuthSDKInfo(
      Platform.OS === 'ios' ? keys.iosKey : keys.androidKey
    );
    // 非进入app就需要登录场景，可调用该方法加速取号
    const res = await Onepass.checkAndPrepareEnv();
    // ios 和 android SDK返回码不一致
    if (res.code === '600000' || res.code === '600024') {
      console.log('终端环境检查⽀持认证');
    }
    setResult(res);
  };
  // 设置授权页样式并获取token
  const buildWithStyleGetToken = async (style: BuildModelStyle) => {
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
  };
  React.useEffect(() => {
    // 授权页各点击事件回调
    Onepass.addAuthUIControlClickListener((args) => {
      console.log(args);
    });
    preload();
    return () => {
      Onepass.removeAuthUIControlClickListener();
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text>环境检测预取号: {JSON.stringify(result)}</Text>
      <Button
        onPress={() => buildWithStyleGetToken(BuildModelStyle.Portrait)}
        title="全屏（竖屏）"
      />
      <Button
        onPress={() => buildWithStyleGetToken(BuildModelStyle.Landscape)}
        title="全屏（横屏）"
      />
      <Button
        onPress={() => buildWithStyleGetToken(BuildModelStyle.AlertPortrait)}
        title="弹窗（竖屏）"
      />
      <Button
        onPress={() => buildWithStyleGetToken(BuildModelStyle.AlertLandscape)}
        title="弹窗（横屏）"
      />
      <Button
        onPress={() => buildWithStyleGetToken(BuildModelStyle.SheetPortrait)}
        title="底部弹窗（竖屏）"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
