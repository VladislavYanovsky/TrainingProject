
import Foundation
import UIKit

fileprivate var aView: UIView?
var customActivityIndicator =  UIActivityIndicatorView()

extension UIViewController {

    func showActivityIndicator() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        customActivityIndicator.center = self.view.center
        customActivityIndicator.hidesWhenStopped = true
        customActivityIndicator.style = .large
        customActivityIndicator.startAnimating()
        aView?.addSubview(customActivityIndicator)
        self.view.addSubview(aView!)
    }
    
    func hideActivityIndicator() {
        aView?.removeFromSuperview()
    }
}
