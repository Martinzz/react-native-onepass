import { NativeModules } from 'react-native';

type OnepassType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Onepass } = NativeModules;

export default Onepass as OnepassType;
