//
//  SuccessViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 24/10/2022.
//

import UIKit

class SuccessViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Actions -
    
    @IBAction func viewDetailAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: false)
    }
    
    @IBAction func backAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
