import {
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
} from 'react-native';

type Response = {
  code: string;
  msg: string;
};

type Font = {
  text: string;
  color: string;
  size: number;
};

type FrameBlock = {
  width?: number;
  height?: number;
  x?: number;
  y?: number;
};

type Position = {
  x?: number;
  y?: number;
};

type BuildLayout = {
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
  logBtnToastHidden?: boolean; // 登录默认toast提示，android
  loginBtnText?: Font; // 登录按钮文字
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
};

export enum StatusBarStyle {
  UIStatusBarStyleDarkContent = 0,
  UIStatusBarStyleLightContent,
}

export enum PrivacyAlignment {
  AlignmentLeft = 0,
  AlignmentCenter,
  AlignmentRight,
}

/**
 * 授权页/弹框预设选项选项
 */
export enum BuildModelStyle {
  Portrait = 0,
  Landscape,
  AlertPortrait,
  AlertLandscape,
  SheetPortrait,
}

const { Onepass } = NativeModules;
const OnePassEmitter = new NativeEventEmitter(Onepass);

export default class AliOnePass {
  private static _authUIControlClickListener: EmitterSubscription | null = null;

  /**
   * 设置密钥
   * @param key 阿里云控制台获取一键登录秘钥，区分iOS 和 android
   */
  static setAuthSDKInfo(key: string): Promise<Response> {
    return Onepass.setAuthSDKInfo(key);
  }
  /**
   * 环境检测并且加速预取号
   */
  static checkAndPrepareEnv(): Promise<Response> {
    return Onepass.checkAndPrepareEnv();
  }
  /**
   * 设置授权页样式
   * @param style
   * @param layout
   */
  static buildWithStyleGetToken(
    style: BuildModelStyle,
    layout?: BuildLayout
  ): Promise<Response> {
    return Onepass.buildWithStyleGetToken(style, layout || {});
  }
  /**
   * 绑定授权页各种点击事件
   * @param callback
   */
  static addAuthUIControlClickListener(callback: (...args: any[]) => any) {
    this._authUIControlClickListener = OnePassEmitter.addListener(
      'onAuthUIControlClick',
      callback
    );
  }

  /**
   * 移除事件
   */
  static removeAuthUIControlClickListener() {
    if (!this._authUIControlClickListener) return;
    this._authUIControlClickListener.remove();
    this._authUIControlClickListener = null;
  }
}
