declare module 'react-native-ecom-portmone' {

    interface SavingCard {
        token: string
    }

    export type PaymentType = 'account' | 'phone' | undefined

    class PortmoneCardModule {
        private lang: string;
        constructor(lang: string);
        initCardPayment(payeeId: string, phoneNumber: string, billAmount: number, type?: PaymentType): Promise<void>;
        initCardSaving(payeeId: string): Promise<SavingCard>;
    }
    export default PortmoneCardModule;
}
