
import Foundation
import PortmoneSDKEcom

class PortmoneCardStyle: StyleSource {
    private static let buttonCornerRadius = CGFloat(25)
    private static let defaultFont = UIFont.systemFont(ofSize: 1)
    private static let whiteColor = UIColor.white
    private static let blackColor = UIColor.black
    private static let grayColor = UIColor(red: 0.713, green: 0.713, blue: 0.713, alpha: 1.0)
    private static let darkGrayColor = UIColor(red: 0.964, green: 0.964, blue: 0.964, alpha: 1.0)
    private static let redColor = UIColor(red: 0.886, green: 0.341, blue: 0.356, alpha: 1.0)
    private static let blueColor = UIColor(red: 0.133, green: 0.623, blue: 1, alpha: 1)
    private static let yellowColor = UIColor(red: 0.972, green: 0.843, blue: 0.184, alpha: 1.0)
    
    func backgroundColor() -> UIColor {
        return PortmoneCardStyle.whiteColor
    }
    
    func textsColor() -> UIColor {
        return PortmoneCardStyle.blackColor
    }
    
    func infoTextsColor() -> UIColor {
        return PortmoneCardStyle.blueColor
    }
    
    func errorsColor() -> UIColor {
        return PortmoneCardStyle.redColor
    }
    
    func placeholdersColor() -> UIColor {
        return PortmoneCardStyle.grayColor
    }
    
    func titleBackgroundColor() -> UIColor {
        return PortmoneCardStyle.blueColor
    }
    
    func titleFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func titleColor() -> UIColor {
        return PortmoneCardStyle.whiteColor
    }
    
    func headersFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func headersColor() -> UIColor {
        return PortmoneCardStyle.blackColor
    }
    
    func headersBackgroundColor() -> UIColor {
        return PortmoneCardStyle.darkGrayColor
    }
    
    func buttonTitleColor() -> UIColor {
        return PortmoneCardStyle.blackColor
    }
    
    func buttonCornerRadius() -> CGFloat {
        return PortmoneCardStyle.buttonCornerRadius
    }
    
    func buttonTitleFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func buttonColor() -> UIColor {
        return PortmoneCardStyle.yellowColor
    }
    
    func successImage() -> UIImage? {
        nil
    }
    
    func failureImage() -> UIImage? {
        nil
    }
    
    func textsFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    func infoTextsFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func errorsFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func placeholdersFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func resultSaveReceiptColor() -> UIColor {
        return PortmoneCardStyle.blackColor
    }
    
    func biometricButtonColor() -> UIColor {
        return PortmoneCardStyle.blueColor
    }
    
    func resultMessageFont() -> UIFont {
        return PortmoneCardStyle.defaultFont
    }
    
    func resultMessageColor() -> UIColor {
        return PortmoneCardStyle.blackColor
    }
}
