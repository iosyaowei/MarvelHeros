//
//  Extension.swift
//  MarvelHeroes
//
//  Created by 姚巍 on 2018/3/14.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import Foundation
import UIKit
extension Date {
    func timestamp() -> String {
        let tampStr = String(Int64(self.timeIntervalSince1970 * 1000))
        return tampStr
    }
}

extension String {
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        
        free(buffer)
        return md5String as String
    } 
}

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension UIColor {
    class func hexInt(hex : UInt32,alpha:CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000ff) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIImage {
    class func image(color: UIColor, rect: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)) -> UIImage{
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension Notification.Name {
    static let MHLikeHeroListChanged = Notification.Name("MHLikeHeroListChanged")
}

private var key: Void?
extension UIImageView {
    
    @IBInspectable var customTag: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setWebImage(URLStr: String?) {
        image = kPlaceHolderImage
        customTag = URLStr
        
        guard let URLStr = URLStr else {
            return
        }
        
        if let data = MHImageCacheManager.readCacheFrom(URLString: URLStr) {
            self.image = UIImage(data: data)
        }else {
            MHNetworkManager.shared.downloadImage(URLStr: URLStr, completion: { (data, isSuccess) in
                if let data = data {
                    MHImageCacheManager.writeCaheTo(URLString: URLStr, data: data)
                    if self.customTag == URLStr {
                        self.image = UIImage(data: data)
                    }
                }
            })
        }
    }
}

extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return MHCustomPushAnimation()
        }else if operation == .pop {
            return MHCustomPopAnimation()
        }
        
        return nil
    }
}
