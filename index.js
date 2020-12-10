import { NativeModules, Platform, NativeEventEmitter } from "react-native";
const { PortmoneCardModule: RNModule } = NativeModules;

const ModuleEmitter = new NativeEventEmitter(RNModule);

export default class PortmoneCardModule {
  lang = 'uk';
  subscription = null;
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
      return RNModule.initCardPaymentByToken(payeeId, phoneNumber, billAmount, type, cardMask, token);
    }
    if (Platform.OS === 'android') {
      RNModule.invokePortmoneSdk(this.lang, type, uid);
      return RNModule.initCardPaymentByToken(payeeId, phoneNumber, billAmount, cardMask, token);
    }
    throw new Error('unsupported platform (only ios and android)');
  }

  initCardSaving = (payeeId, uid, type) => {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    if (Platform.OS === 'ios') {
      RNModule.invokePortmoneSdk(this.lang, uid);
      return RNModule.initCardSaving(payeeId);
    }
    if (Platform.OS === 'android') {
      RNModule.invokePortmoneSdk(this.lang, type, uid);
      return RNModule.initCardSaving(payeeId);
    }
    throw new Error('unsupported platform (only ios and android)');
  }

  addListener(eventType, callback) {
    this.subscription = ModuleEmitter.addListener(eventType, callback);
  }

  removeAllListeners(eventType) {
    this.subscription.remove();
  }
}

