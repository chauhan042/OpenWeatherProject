

import UIKit.UINavigationController

extension UINavigationBar {
  
 func style(withBarTintColor barTintColor: UIColor, tintColor: UIColor) {
    isTranslucent = false
    
    self.barTintColor = barTintColor
    self.tintColor = tintColor
    titleTextAttributes = [.foregroundColor: tintColor]
    barStyle = .default
  }
}
