//
//  FullScreenImageViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 27/10/2022.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    
    //MARK: declarations
    
    
    var mediumSizeImage             = UIImage()
    var panGestureRecognizer        : UIPanGestureRecognizer?
    var originalPosition            : CGPoint?
    var currentPositionTouched      : CGPoint?
    var donePressed                 : (() -> Void)?
    var cancelPressed               : (() -> Void)?

    /****************************************/
    //MARK: outlets
    /****************************************/
    
    @IBOutlet var fullScreenImageView: UIImageView!
    
    /****************************************/
    //MARK: controllers Lifecycle
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullScreenImageView.image = mediumSizeImage
        
        
        fullScreenImageView.frame = self.view.frame
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        fullScreenImageView.addGestureRecognizer(panGestureRecognizer!)
        fullScreenImageView.isUserInteractionEnabled = true
        
    }
    
   
  
    
    /****************************************/
    //MARK: Selectors
    /****************************************/
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            let velocity = panGesture.velocity(in: view)
            if velocity.y <= 0
            {
                self.view.center = self.originalPosition!
            }
            else
            {
                view.frame.origin = CGPoint(
                    x: originalPosition!.x - self.view.frame.width / 2,  //translation.x,
                    y: translation.y
                )
            }
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1000 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismissController(false)
                    }
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
    
    /****************************************/
    //MARK: custom methods
    /****************************************/
    
    func dismissController(_ isDone: Bool)
    {
        if isDone {
            self.donePressed?()
        } else {
            self.cancelPressed?()
        }
        dismiss(animated: true, completion: nil)
    }
    
    /****************************************/
    //MARK: Actions
    /****************************************/
    
    @IBAction func doneAction(_ sender: UIButton)
    {
        
        dismissController(true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton)
    {
        dismissController(false)
    }

}
