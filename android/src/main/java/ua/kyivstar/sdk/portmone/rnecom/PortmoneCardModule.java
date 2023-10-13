package ua.kyivstar.sdk.portmone.rnecom;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.IllegalViewOperationException;
import com.portmone.ecomsdk.PortmoneSDK;
import com.portmone.ecomsdk.data.Bill;
import com.portmone.ecomsdk.data.CardPaymentParams;
import com.portmone.ecomsdk.data.SaveCardParams;
import com.portmone.ecomsdk.data.TokenPaymentParams;
import com.portmone.ecomsdk.data.style.AppStyle;
import com.portmone.ecomsdk.ui.card.CardPaymentActivity;
import com.portmone.ecomsdk.ui.savecard.PreauthCardActivity;
import com.portmone.ecomsdk.ui.token.payment.TokenPaymentActivity;
import com.portmone.ecomsdk.util.Constant$BillCurrency;

import com.portmone.ecomsdk.util.Constant$Language;
import com.portmone.ecomsdk.util.Constant$Type;

import java.util.Arrays;
import java.util.List;

import static android.app.Activity.RESULT_OK;

public class PortmoneCardModule extends ReactContextBaseJavaModule {

    private static final AppStyleFactory APP_STYLE_FACTORY = new AppStyleFactory();
    private static final List<String> AVAILABLE_LANGUAGES = Arrays.asList(
        Constant$Language.EN, Constant$Language.RU, Constant$Language.UK
    );

    private ReactApplicationContext reactContext;
    private Promise promise;
    private String numberType;

    public PortmoneCardModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    @MainThread
    public boolean sendEvent(String eventName, @Nullable Object value) {
        if (reactContext == null || !reactContext.hasActiveCatalystInstance()) {
            return false;
        }

        try {
            reactContext
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, value);
        } catch (Exception e) {
            Log.d(Constants.PORTMONE_TAG, "SendEvent Error: " + e.getMessage());

            return false;
        }

        return true;
    }

    @Override
    public String getName() {
        return "PortmoneCardModule";
    }

    private String getLanguage(String lang) {
        return AVAILABLE_LANGUAGES.contains(lang) ? lang : Constant$Language.SYSTEM;
    }

    private int getTypeUI(String type) {
        if (type.equals(Constants.PHONE_TYPE)) {
            return Constant$Type.PHONE;
        }
        if (type.equals(Constants.ACCOUNT_TYPE)) {
            return Constant$Type.ACCOUNT;
        }
        return Constant$Type.DEFAULT;
    }

    private String getAttribute(String type) {
        if (type.equals(Constants.ACCOUNT_TYPE)) {
            return Constants.ATTR_1_ACCOUNT;
        }
        return Constants.ATTR_1_PHONE;
    }

    @ReactMethod
    public void invokePortmoneSdk(String lang, String type, String uid) {
        try {
            this.numberType = type;
            final AppStyle styles = APP_STYLE_FACTORY.createStyles(reactContext, getTypeUI(type));
            PortmoneSDK.setLanguage(getLanguage(lang));
            PortmoneSDK.setUid(uid);
            PortmoneSDK.setAppStyle(styles);
        } catch (IllegalViewOperationException e) {
            Log.d(Constants.PORTMONE_TAG, "invokePortmoneSdk: ERROR", e);
        }
    }

    @ReactMethod
    public void initCardPayment(String payeeId, String phoneNumber, int billAmount, final Promise promise) {
        try {
            final CardPaymentParams params = new CardPaymentParams(
                payeeId,
                Constants.BILL_NUMBER,
                Constants.ALLOW_PRE_AUTH,
                Constant$BillCurrency.UAH,
                getAttribute(this.numberType),
                "",
                "",
                "",
                "",
                billAmount,
                phoneNumber,
                null
            );
            CardPaymentActivity.performTransaction(
                getCurrentActivity(),
                Constants.REQUEST_CODE,
                params
            );
            this.promise = promise;
        } catch (IllegalViewOperationException e) {
            Log.d(Constants.PORTMONE_TAG, "initCardPayment: ERROR", e);
        }
    }

    @ReactMethod
    public void initCardSaving(String payeeId, final Promise promise) {
        try {
            final SaveCardParams saveCardParams = new SaveCardParams(
                payeeId,
                null,
                Constants.BILL_NUMBER,
                ""
            );
            PreauthCardActivity.performTransaction(
                getCurrentActivity(),
                Constants.REQUEST_CODE,
                saveCardParams
            );
            this.promise = promise;
        } catch (IllegalViewOperationException e) {
            Log.d(Constants.PORTMONE_TAG, "initCardSaving: ERROR", e);
        }
    }

    @ReactMethod
    public void initCardPaymentByToken(
            String payeeId,
            String phoneNumber,
            int billAmount,
            String cardMask,
            String token,
            final Promise promise
    ) {
        try {
            final TokenPaymentParams params = new TokenPaymentParams(
                    payeeId,
                    Constants.BILL_NUMBER,
                    Constants.ALLOW_PRE_AUTH,
                    Constant$BillCurrency.UAH,
                    getAttribute(this.numberType),
                    null,
                    null,
                    null,
                    null,
                    billAmount,
                    cardMask,
                    token,
                    phoneNumber
            );
            TokenPaymentActivity.performTransaction(
                    getCurrentActivity(),
                    Constants.REQUEST_CODE,
                    params
            );
            this.promise = promise;
        } catch (IllegalViewOperationException e) {
            Log.d(Constants.PORTMONE_TAG, "initCardPaymentByToken: ERROR", e);
        }
    }

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
            switch (requestCode) {
                case Constants.REQUEST_CODE:
                    if (resultCode == RESULT_OK) {
                        Bundle bundle = intent.getExtras();
                        Bill bill = (Bill)bundle.get(Constants.BILL_KEY);
                        String token = bill.getToken();
                        String cardMask = bill.getCardMask();
                        WritableMap map = Arguments.createMap();
                        map.putString(Constants.TOKEN_PROPERTY, token);
                        map.putString(Constants.CARD_MASK_PROPERTY, cardMask);
                        promise.resolve(map);
                    } else {
                        promise.reject(Constants.PORTMONE_TAG, new Error("Result code: " + resultCode));
                    }
                    sendEvent(Constants.ON_FORM_DISMISS_EVENT, null);
                    promise = null;
                    break;
            }
        }
    };
}
