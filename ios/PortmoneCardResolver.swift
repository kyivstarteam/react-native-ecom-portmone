import Foundation

class PortmoneCardResolver {
  var onPaymentFinish: (_ : FinishPaymentsData?, _ : Error?) -> Void
    
  init(resolver:@escaping (_ : FinishPaymentsData?, _ : Error?) -> Void) {
        self.onPaymentFinish = resolver
    }
}
