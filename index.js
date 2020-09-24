import { NativeModules, Platform } from "react-native";
const { PortmoneCardModule: RNModule } = NativeModules;

export default class PortmoneCardModule {
  lang = 'uk';
  constructor(lang) {
    this.lang = lang;
  }

  initCardPayment = (payeeId, phoneNumber, billAmount, uid, type) => {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    if (Platform.OS === 'ios') {
      RNModule.invokePortmoneSdk(this.lang, uid);
      return RNModule.initCardPayment(payeeId, phoneNumber, billAmount, type);
    }
    if (Platform.OS === 'android') {
      RNModule.invokePortmoneSdk(this.lang, type, uid);
      return RNModule.initCardPayment(payeeId, phoneNumber, billAmount);
    }
    throw new Error('unsupported platform (only ios and android)');
  }

  initCardPaymentByToken = (payeeId, phoneNumber, billAmount, uid, cardMask, token, type) => {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    if (Platform.OS === 'ios') {
      RNModule.invokePortmoneSdk(this.lang, uid);
      return RNModule.initCardPaymentByToken(payeeId, phoneNumber, billAmount, cardMask, token, type);
    }
    if (Platform.OS === 'android') {
      RNModule.invokePortmoneSdk(this.lang, type, uid);
      return RNModule.initCardPaymentByToken(payeeId, phoneNumber, billAmount, cardMask, token);
    }
    throw new Error('unsupported platform (only ios and android)');
  }

  initCardSaving = (payeeId) => {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    RNModule.invokePortmoneSdk(this.lang);
    return RNModule.initCardSaving(payeeId);
  }
}

