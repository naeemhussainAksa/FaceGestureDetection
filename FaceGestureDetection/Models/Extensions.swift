//
//  Extensions.swift
//  FaceGestureDetection
//
//  Created by Naeem Hussain on 10/11/2022.
//

import Foundation
import UIKit

//extension CGPoint {
//    func scaled(to size: CGSize) -> CGPoint {
//        return CGPoint(x: self.x * size.width, y: self.y * size.height)
//    }
//}
//extension CGRect {
//    func scaled(to size: CGSize) -> CGRect {
//        return CGRect(
//            x: self.origin.x * size.width,
//            y: self.origin.y * size.height,
//            width: self.size.width * size.width,
//            height: self.size.height * size.height
//        )
//    }
//}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: {
        })
    }
}
