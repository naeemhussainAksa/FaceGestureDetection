//
//  IntroViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 20/10/2022.
//

import UIKit

class IntroViewController: BaseViewController {

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Actions -
    
    @IBAction func nextAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
