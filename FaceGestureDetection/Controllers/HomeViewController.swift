//
//  HomeViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 21/10/2022.
//

import UIKit
import AVFoundation

class HomeViewController: BaseViewController {

    
    // MARK: - Outlet -
    
    @IBOutlet weak var idCardHolderView: UIView!
    @IBOutlet weak var idCardLabel: UILabel!
    @IBOutlet weak var passportHolderView: UIView!
    @IBOutlet weak var passportLabel: UILabel!
    @IBOutlet weak var bottomDescription: UILabel!
    
    // MARK: - Controller's Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK: - Custom Methods -
    
    fileprivate func setupUI()
    {
        bottomDescription.setAttributedTextInLable("By tapping start button, you accept your", "#000000", 12, " Consent to Personal Data Processing", "#1F979A", 12)
    }
    
    fileprivate func onSelectionUIHandlings(_ isIdViewSelected: Bool)
    {
        idCardHolderView.borderColor = UIColor(named: "default_border")
        idCardHolderView.backgroundColor = UIColor.white
        idCardLabel.textColor = UIColor.black
        
        passportHolderView.borderColor = UIColor(named: "default_border")
        passportHolderView.backgroundColor = UIColor.white
        passportLabel.textColor = UIColor.black
        
        if isIdViewSelected {
            idCardHolderView.borderColor = UIColor.appColor
            idCardHolderView.backgroundColor = UIColor.appColor.withAlphaComponent(0.04)
            idCardLabel.textColor = UIColor.appColor
        } else {
            passportHolderView.borderColor = UIColor.appColor
            passportHolderView.backgroundColor = UIColor.appColor.withAlphaComponent(0.04)
            passportLabel.textColor = UIColor.appColor
        }
    }
    
    
    private func checkCameraPermission(_ compeletion : @escaping(Bool) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // the user has already authorized to access the camera.
            compeletion(true)
            
        case .notDetermined: // the user has not yet asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // if user has granted to access the camera.
                    print("the user has granted to access the camera")
                    compeletion(true)
                } else {
                    print("the user has not granted to access the camera")
                    self.showAlert(title: "Alert", message: "The user has not granted to access the camera")
                    compeletion(false)
                }
            }
            
        case .denied:
            print("the user has denied previously to access the camera.")
            self.showAlert(title: "Alert", message: "The user has denied previously to access the camera.")
            compeletion(false)
            
        case .restricted:
            print("the user can't give camera access due to some restriction.")
            self.showAlert(title: "Alert", message: "The user can't give camera access due to some restriction.")
            compeletion(false)
            
        default:
            print("something has wrong due to we can't access the camera.")
            self.showAlert(title: "Alert", message: "Something has wrong due to we can't access the camera.")
            compeletion(false)
        }
    }
    
    
    // MARK: - Actions -
    
    @IBAction func idCardAction(_ sender: UIButton)
    {
        self.onSelectionUIHandlings(true)
        
        self.checkCameraPermission { isGranted in
            if isGranted {
                
                DispatchQueue.main.async {
                    
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfieViewController") as! SelfieViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanCardViewController") as! ScanCardViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    @IBAction func passportAction(_ sender: UIButton)
    {
        self.onSelectionUIHandlings(false)
    }
}
