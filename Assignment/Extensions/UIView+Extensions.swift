

import UIKit.UIView

extension UIView {
    
    class func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
    func addDropShadow(with color: UIColor = UIColor.black, opacity: Float = 0.75, offset: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 1, scale: Bool = true, shouldRasterize: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = shouldRasterize
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func animatePulse(withAnimationDelegate delegate: CAAnimationDelegate) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.delegate = delegate
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.duration = 0.25
        animation.toValue = 1.5
        animation.repeatCount = 2.0
        animation.autoreverses = true
        layer.add(animation, forKey: "pulse")
    }
}
