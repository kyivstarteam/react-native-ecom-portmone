
import UIKit
import Foundation

@objc(PortmoneCardModule)
class PortmoneCardModule: RCTEventEmitter {
    private var hasRegisteredEvents: Bool = false
    private var portmoneCardViewController: PortmoneCardViewController?
    private var rootViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!

    override static func moduleName() -> String! {
        return Constants.moduleName
    }

    @objc(invokePortmoneSdk:uid:)
    public func invokePortmoneSdk(lang: String, uid: String) -> Void {
        self.portmoneCardViewController = PortmoneCardViewController()

        self.portmoneCardViewController?.delegate = self
        self.portmoneCardViewController?.invokePortmoneSdk(lang: lang, uid: uid)
        self.rootViewController.present(self.portmoneCardViewController!, animated: true)
    }

    @objc(initCardPayment:phoneNumber:billAmount:type:resolve:rejecter:)
    public func initCardPayment(payeeId: String,
                                phoneNumber: String,
                                billAmount: Int,
                                type: String,
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        self.portmoneCardViewController?.initCardPayment(
            payeeId: payeeId,
            phoneNumber: phoneNumber,
            billAmount: Double(billAmount),
            type: type
        ) {(result, error) in
            if (result != nil) {
                resolve(result.dictionary)
                return
            }

            if (error != nil) {
                reject("PaymentError", error?.localizedDescription, error)
                return
            }

            resolve("")
            return

        }
    }

    @objc(initCardSaving:resolve:rejecter:)
    public func initCardSaving(payeeId: String, _ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        self.portmoneCardViewController?.initCardSaving(payeeId: payeeId) {(result, error) in
            if (result != nil) {
                resolve(result.dictionary)
                return
            }

            if (error != nil) {
                reject("PaymentError", error?.localizedDescription, error)
                return
            }

            resolve("")
            return
        }
    }

    @objc(initCardPaymentByToken:phoneNumber:billAmount:type:cardMask:token:resolve:rejecter:)
    public func initCardPaymentByToken(payeeId: String,
                                phoneNumber: String,
                                billAmount: Int,
                                type: String,
                                cardMask: String,
                                token: String,
                                _ resolve: @escaping RCTPromiseResolveBlock,
                                rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        self.portmoneCardViewController?.initCardPaymentByToken(
            payeeId: payeeId,
            phoneNumber: phoneNumber,
            billAmount: Double(billAmount),
            type: type,
            cardMask: cardMask,
            token: token
        ) {(result, error) in
            if (result != nil) {
                resolve(result.dictionary)
                return
            }

            if (error != nil) {
                reject("PaymentError", error?.localizedDescription, error)
                return
            }

            resolve("")
            return

        }
    }
}

extension PortmoneCardModule {
  override func startObserving() {
    self.hasRegisteredEvents = true
  }

  override func stopObserving() {
    self.hasRegisteredEvents = false
  }

  override func sendEvent(withName name: String!, body: Any!) {
    if (hasRegisteredEvents) {
      super.sendEvent(withName: name, body: body)
    }
  }
}

extension PortmoneCardModule: PortmoneCardModuleDelegate {
  func onDismissView() {
    self.sendEvent(withName: Constants.onFormViewDismissed, body: nil)
   }
}
