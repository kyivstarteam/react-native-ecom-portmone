package ua.kyivstar.sdk.portmone.rnecom;

import androidx.core.content.ContextCompat;

import com.facebook.react.bridge.ReactContext;
import ua.kyivstar.sdk.portmone.rnecom.R;
import com.portmone.ecomsdk.data.style.AppStyle;
import com.portmone.ecomsdk.data.style.ButtonStyle;
import com.portmone.ecomsdk.data.style.TextStyle;

public final class AppStyleFactory {
      private ButtonStyle createButtonStyles(ReactContext reactContext) {
            ButtonStyle buttonStyles = new ButtonStyle();
            buttonStyles.setCornerRadius(Constants.CORNER_RADIUS);
            buttonStyles.setBackgroundColor(ContextCompat.getColor(reactContext, R.color.colorYellowButton));
            buttonStyles.setTextColor(ContextCompat.getColor(reactContext, R.color.colorLinesDark));
            return buttonStyles;
      }

      private TextStyle createTextStyles(ReactContext reactContext) {
            TextStyle titleTextStyles = new TextStyle();
            titleTextStyles.setTextColor(ContextCompat.getColor(reactContext, R.color.colorWhite));
            return titleTextStyles;
      }

      public AppStyle createStyles(ReactContext reactContext, int type) {
            AppStyle styles = new AppStyle();
            ButtonStyle buttonStyles = createButtonStyles(reactContext);
            TextStyle titleTextStyles = createTextStyles(reactContext);

            styles.setToolbarColor(ContextCompat.getColor(reactContext, R.color.clearBlue));
            styles.setButtonStyle(buttonStyles);
            styles.setTitleTextStyle(titleTextStyles);

            styles.setType(type);

            return styles;
      }
}
