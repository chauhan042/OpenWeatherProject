//
//  UITableViewExtension.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import Foundation
import UIKit
extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}



extension UITableViewCell {
    class func tableCellReuseIdentifier() -> String {
        return className
    }
    
    class func getViewFromCellFor<T : UITableViewCell>(class : T.Type) -> UIView {
        let cell = Bundle.main.loadNibNamed(T.tableCellReuseIdentifier(), owner: self, options: nil)?[0] as! T
        return cell.contentView
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.tableCellReuseIdentifier())
    }
    
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let nib = T.nib()
        self.register(nib, forCellReuseIdentifier: T.tableCellReuseIdentifier())
    }
    
    func register(_ cellIdentifier: String) {
        self.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.tableCellReuseIdentifier(), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.tableCellReuseIdentifier())")
        }
        
        return cell
    }
}
