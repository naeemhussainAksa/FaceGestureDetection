//
//  LoaderAnimation.swift
//  CarrierApp
//
//  Created by Phaedra Solutions  on 27/08/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import Lottie

class LoaderAnimation: NSObject {
    
    static var shared = LoaderAnimation()
    private var animationView: LottieAnimationView?
    private var superView: UIView!
    
//    private override init() {
//
//        superView = UIView(frame: LoaderAnimation.frame)
//
//        animationView = .init(name: LoaderAnimation.loaderString)
//        animationView!.frame = superView.bounds
//        animationView!.contentMode = .scaleAspectFit
//        animationView!.loopMode = .loop
//
//        superView.tag = 9000
//        superView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        superView.addSubview(animationView!)
//
//        super.init()
//
//    }
    
    private override init() {
        super.init()
    }
    
    func playAnimation(_ frame: CGRect, _ animatedString: String, _ fromClass: UIViewController) {
        
        superView = UIView(frame: frame)
        
        animationView = .init(name: animatedString)
        animationView!.frame = superView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        
        superView.tag = 9000
        superView.backgroundColor = nil//UIColor.black.withAlphaComponent(0.8)
        superView.addSubview(animationView!)
        
        DispatchQueue.main.async {
            self.animationView!.play()
            fromClass.view.addSubview(self.superView)

        }
    }
    
    func stopAnimation(_ fromClass: UIViewController){
        
        DispatchQueue.main.async {
            if let aniView = self.animationView {
                
                aniView.stop()
                
                if let activityView = fromClass.view.viewWithTag(9000) {
                    activityView.removeFromSuperview()
                }
            }
            
        }
    }
}
