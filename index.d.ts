declare module 'react-native-ecom-portmone' {

    interface SavingCard {
        token: string
    }

    interface InvokePortmoneSdk {
        initCardPayment(payeeId: string, phoneNumber: string, billAmount: number): Promise<void>;
        initCardSaving(payeeId: string): Promise<SavingCard>;
    }

    class PortmoneCardModule {
        static invokePortmoneSdk(lang: string): InvokePortmoneSdk;
    }
    export default PortmoneCardModule;
}
