declare module '@kyivstarteam/react-native-ecom-portmone' {
    import {EmitterSubscription} from 'react-native';

    export interface PaymentsParams {
        token: string
        cardMask: string
    }

    export type PaymentType = 'account' | 'phone' | undefined

    interface SupportedEvents {
        onFormViewDismissed: (token: String) => void;
    }

    type SupportedEventTypes = keyof SupportedEvents;

    class PortmoneCardModule {
        private lang: string;
        constructor(lang: string);

        initCardPayment(
          payeeId: string,
          phoneNumber: string,
          billAmount: number,
          uid: string,
          type?: PaymentType
        ): Promise<PaymentsParams>;

        initCardPaymentByToken(
          payeeId: string,
          phoneNumber: string,
          billAmount: number,
          uid: string,
          cardMask: string,
          token: string,
          type?: PaymentType
        ): Promise<void>;

        initCardSaving(
          payeeId: string,
          uid: string,
          type?: PaymentType
        ): Promise<PaymentsParams>;

        addListener<K extends SupportedEventTypes>(
          eventType: K,
          callback?: SupportedEvents[K],
        ): EmitterSubscription;

        removeAllListeners(eventType?: SupportedEventTypes): void;

    }

    export default PortmoneCardModule;
}
