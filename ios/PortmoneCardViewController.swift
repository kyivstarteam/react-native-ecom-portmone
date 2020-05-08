import Foundation
import UIKit
import PortmoneSDKEcom

struct FinishPaymentsData: Codable {
    let token: String
}

struct ErrorPaymentsData: Codable {
    let token: String
}

struct JSON {
    static let encoder = JSONEncoder()
}

class PortmoneCardViewController: UIViewController {
    private let closeModalCode = 0
    private let mobilePaymentType: PaymentType = .mobilePayment
    private let accountPaymentType: PaymentType = .account
    private let defaultPaymentType: PaymentType = .payment
    private let paymentFlowType: PaymentFlowType = .byCard
    private let billAmountWcvv: Double = 8000
    
    private var lang: String?
    private var paymentPresenter: PaymentPresenter?
    private var cardStyle: PortmoneCardStyle?
    private var resolver: PortmoneCardResolver?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.cardStyle = PortmoneCardStyle.init()
    }
    
    public func invokePortmoneSdk(lang: String?) {
        self.paymentPresenter = PaymentPresenter(
            delegate: self,
            styleSource: cardStyle,
            language: Language(rawValue: lang!) ?? Language.ukrainian)
    }
    
    public func initCardPayment(payeeId: String,
                                phoneNumber: String,
                                billAmount: Double,
                                type: String,
                                competition: @escaping (_ result: FinishPaymentsData?, _ error: Error?) -> Void
    ) {
        self.resolver = PortmoneCardResolver(resolver: competition)
        let paymentParams = self.getCardPaymentParams(
            payeeId: payeeId,
            phoneNumber: phoneNumber,
            billAmount: billAmount,
            type: type
        )
        
        self.paymentPresenter?.presentPaymentByCard(
            on: self,
            params: paymentParams,
            showReceiptScreen: true
        )
    }
    
    public func initCardSaving(payeeId: String, competition: @escaping (_ result: FinishPaymentsData?, _ error: Error?) -> Void) {
        self.resolver = PortmoneCardResolver(resolver: competition)
        let savingParams = self.getCardSavingParams(payeeId: payeeId)
        
        self.paymentPresenter?.presentPreauthCard(on: self, params: savingParams)
    }
    
    private func getTypeUI(type: String) -> PaymentType {
        if (type == "phone") {
            return mobilePaymentType
        }
        if (type == "account") {
            return accountPaymentType
        }
        return defaultPaymentType
    }

    private func getAttribute(type: String) -> String {
        if (type == "account") {
            return "A"
        }
        return "P"
    }

    private func getCardPaymentParams(
        payeeId: String,
        phoneNumber: String,
        billAmount: Double,
        type: String
    ) -> PaymentParams {
        return PaymentParams(
            description: phoneNumber,
            attribute1: self.getAttribute(type: type),
            preauthFlag: false,
            billAmount: billAmount,
            billAmountWcvv: billAmountWcvv,
            payeeId: payeeId,
            type: self.getTypeUI(type: type),
            paymentFlowType: paymentFlowType
            
        )
    }
    
    private func getCardSavingParams(
        payeeId: String
    ) -> PreauthParams {
        return PreauthParams(
            payeeId: payeeId
        )
    }
    
    private func dismissView() -> Void {
        self.dismiss(
            animated: true,
            completion: self.removeFromParent
        )
    }
}

extension PortmoneCardViewController: PortmonePaymentPresenterDelegate {
    func didFinishPayment(bill: Bill?, error: Error?) {
        if error != nil {
            self.resolver?.onPaymentFinish(nil, error)
            self.resolver = nil
        }
        
        if bill != nil {
            let token = bill?.token ?? ""
            let data = FinishPaymentsData(token: token)
            self.resolver?.onPaymentFinish(data, nil)
            self.resolver = nil
        }
    }
    
    func dismissedSDK() {
        let error = NSError(domain: "Result code: \(closeModalCode)", code: closeModalCode, userInfo: nil)
        self.resolver?.onPaymentFinish(nil, error)
        self.resolver = nil
        self.dismissView()
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

