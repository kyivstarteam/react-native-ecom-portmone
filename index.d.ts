declare module '@kyivstarteam/react-native-ecom-portmone' {

    export interface PaymentsParams {
        token: string
        cardMask: string
    }

    export type PaymentType = 'account' | 'phone' | undefined

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
          phoneNumber: string,
          type?: PaymentType,
        ): Promise<PaymentsParams>;
    }

    export default PortmoneCardModule;
}
