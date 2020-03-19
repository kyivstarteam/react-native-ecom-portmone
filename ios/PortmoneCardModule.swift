
import UIKit
import Foundation

@objc(PortmoneCardModule)
class PortmoneCardModule: NSObject, RCTBridgeModule, PortmoneCardDelegate {
  private var portmoneCardViewController: PortmoneCardViewController?
  private var rootViewController: UIViewController?
  
  static func moduleName() -> String! {
    return "PortmoneCardModule"
  }
    
  @objc(invokePortmoneSdk:)
  public func invokePortmoneSdk(lang: String) -> Void {
    self.portmoneCardViewController = PortmoneCardViewController.init()
    self.portmoneCardViewController?.delegate = self
    self.rootViewController = UIApplication.shared.keyWindow!.rootViewController
    self.rootViewController?.present(self.portmoneCardViewController!, animated: true, completion: nil)
    self.portmoneCardViewController?.invokePortmoneSdk(lang: lang)
  }
    
  @objc(initCardPayment:phoneNumber:billAmount:)
  public func initCardPayment(payeeId: String, phoneNumber: String, billAmount: Int) {
    self.portmoneCardViewController?.initCardPayment(
      payeeId: payeeId,
      phoneNumber: phoneNumber,
      billAmount: Double(billAmount)
    )
  }
  
  func dismissView() {
    self.portmoneCardViewController?.dismiss(
      animated: true,
      completion: self.removeViewFromParent
    )
  }
  
  private func removeViewFromParent() {
    self.portmoneCardViewController?.removeFromParent()
  }
}
