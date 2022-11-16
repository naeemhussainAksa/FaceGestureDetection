//
//  BaseViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 20/10/2022.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
 
    func fixOrientation(img: UIImage, completion :@escaping (UIImage)-> ()) {
        DispatchQueue.global(qos: .background).async {
            if (img.imageOrientation == .up) {
                completion(img)
            }
            
            UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
            let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            img.draw(in: rect)
            
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            completion(normalizedImage)
        }
    }
    
    
    func cropImage(image: UIImage, to aspectRatio: CGFloat,completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            
            let imageAspectRatio = image.size.height/image.size.width
            
            var newSize = image.size
            
            if imageAspectRatio > aspectRatio {
                newSize.height = image.size.width * aspectRatio
            } else if imageAspectRatio < aspectRatio {
                newSize.width = image.size.height / aspectRatio
            } else {
                completion (image)
            }
            
            let center = CGPoint(x: image.size.width/2, y: image.size.height/2)
            let origin = CGPoint(x: center.x - newSize.width/2, y: center.y - newSize.height/2)
            
            let cgCroppedImage = image.cgImage!.cropping(to: CGRect(origin: origin, size: CGSize(width: newSize.width, height: newSize.height)))!
            let croppedImage = UIImage(cgImage: cgCroppedImage, scale: image.scale, orientation: image.imageOrientation)
            
            completion(croppedImage)
        }
    }
    
    func showFullScreenImage(_ ofIMage: UIImage, _ compeletion : @escaping(Bool) -> ())
    {
        DispatchQueue.main.async {
            let fullScreenVc = FullScreenImageViewController(nibName: "FullScreenImageViewController", bundle: nil)
            fullScreenVc.mediumSizeImage = ofIMage
            fullScreenVc.modalPresentationStyle = .overFullScreen
            fullScreenVc.donePressed = {
                compeletion(true)
            }
            
            fullScreenVc.cancelPressed = {
                compeletion(false)
            }
            
            self.present(fullScreenVc, animated: false)
        }
    }
    
    func showToast(message : String = "", with doneimage: Bool = false) {

        let toastLabel = UILabel(frame: CGRect(x: 20 , y:UIScreen.main.bounds.height/2 + 25    , width: UIScreen.main.bounds.width - 40, height: 60))
        //toastLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        toastLabel.textColor = UIColor.appColor//UIColor.white
        let font = UIFont.poppinFont(withSize: 13)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines  =  2
        var imageView = UIImageView()
        if doneimage {
            imageView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 25, y: (UIScreen.main.bounds.height/2) - 25 , width: 50, height: 50))
            imageView.image = UIImage(named: "done")
            self.view.addSubview(imageView)
        }
        if message.count > 0{
            self.view.addSubview(toastLabel)
        }
        
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
            imageView .alpha = 0.0
        }, completion: {(isCompleted) in
        
            toastLabel.removeFromSuperview()
            imageView.removeFromSuperview()
        })
    }
}
