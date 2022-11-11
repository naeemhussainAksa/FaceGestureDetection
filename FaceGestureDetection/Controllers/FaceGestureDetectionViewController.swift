//
//  FaceGestureDetectionViewController.swift
//  FaceGestureDetection
//
//  Created by Naeem Hussain on 11/11/2022.
//

import UIKit

class FaceGestureDetectionViewController: BaseViewController {
    
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    // MARK: - Actions -
    
    @IBAction func nextAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
