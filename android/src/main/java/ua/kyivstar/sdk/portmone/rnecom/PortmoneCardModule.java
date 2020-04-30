package ua.kyivstar.sdk.portmone.rnecom;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.IllegalViewOperationException;
import com.portmone.ecomsdk.PortmoneSDK;
import com.portmone.ecomsdk.data.Bill;
import com.portmone.ecomsdk.data.CardPaymentParams;
import com.portmone.ecomsdk.data.SaveCardParams;
import com.portmone.ecomsdk.data.style.AppStyle;
import com.portmone.ecomsdk.ui.card.CardPaymentActivity;
import com.portmone.ecomsdk.ui.savecard.PreauthCardActivity;
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
    private static final String TOKEN_PROPERTY = "token";

    private ReactApplicationContext reactContext;
    private Promise promise;

    public PortmoneCardModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(mActivityEventListener);
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

    @ReactMethod
    public void invokePortmoneSdk(String lang, String type) {
        try {
            final AppStyle styles = APP_STYLE_FACTORY.createStyles(reactContext, getTypeUI(type));
            PortmoneSDK.setLanguage(getLanguage(lang));
            PortmoneSDK.setFingerprintPaymentEnable(true);
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
                Constants.ATTR_1,
                null,
                null,
                null,
                billAmount,
                phoneNumber
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

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
            switch (requestCode) {
                case Constants.REQUEST_CODE:
                    if (resultCode == RESULT_OK) {
                        Bundle bundle = intent.getExtras();
                        Bill bill = (Bill)bundle.get(Constants.BILL_KEY);
                        String token = bill.getToken();
                        WritableMap map = Arguments.createMap();
                        map.putString(TOKEN_PROPERTY, token);
                        promise.resolve(map);
                    } else {
                        promise.reject(Constants.PORTMONE_TAG, new Error("Result code: " + resultCode));
                    }
                    promise = null;
                    break;
            }
        }
    };
}
