import { NativeModules } from "react-native";
const { PortmoneCardModule: RNModule } = NativeModules;

function initCardPayment(payeeId, phoneNumber, billAmount) {
  try {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    return RNModule.initCardPayment(payeeId, phoneNumber, billAmount);
  } catch (e) {
    console.info(`JS => PortmoneCardModule => initCardPayment => ${e}`)
  }
}

function initCardSaving(payeeId) {
  try {
    if (typeof payeeId !== 'string') {
      throw new Error('payeeId must be string');
    }
    return RNModule.initCardSaving(payeeId);
  } catch (e) {
    console.info(`JS => PortmoneCardModule => initCardSaving => ${e}`)
  }
}

export default class PortmoneCardModule {
  static invokePortmoneSdk(lang) {
    if (typeof lang !== 'string') {
      throw new Error('lang must be string');
    }
    RNModule.invokePortmoneSdk(lang);
    return {
      initCardPayment,
      initCardSaving,
    }
  }
};
