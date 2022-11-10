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
}
