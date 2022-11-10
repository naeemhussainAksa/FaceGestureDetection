//
//  LivenessDetectionViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 08/11/2022.
//

import UIKit


enum LivenessDetectionValues: String, CaseIterable {
    case turn_left              = "Turn Left"
    case turn_right             = "Turn Right"
    case tuen_left_then_right   = "Turn Left Then Right"
    case move_up                = "Move Up"
    case move_down              = "Move Down"
    case move_up_then_down      = "Move Up Then Down"
    case smile                  = "please smile"
    case blink_eyes             = "Blink Your Eyes"
    case random                 = "Select Random"
}

class LivenessDetectionViewController: BaseViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var tableData: [LivenessDetectionValues] = {
        let tableViewElements = LivenessDetectionValues.allCases
        return tableViewElements
    }()
    var inputDataDict = [String: Any]()
    
    // MARK: - Controller's Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewsInit()
    }
    
    
    // MARK: - Methods -
   
    private func tableViewsInit()
    {
        tableView.register(UINib(nibName: "LivenessDetectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LivenessDetectionHeaderTableViewCell")
        tableView.register(UINib(nibName: "LivenessDetectionOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "LivenessDetectionOptionsTableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension LivenessDetectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LivenessDetectionHeaderTableViewCell", for: indexPath) as! LivenessDetectionHeaderTableViewCell
            return cell
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LivenessDetectionOptionsTableViewCell", for: indexPath) as! LivenessDetectionOptionsTableViewCell
            cell.titleDesLabel.text = tableData[indexPath.row - 1].rawValue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            let scanVC = self.storyboard?.instantiateViewController(withIdentifier: "SelfieViewController") as! SelfieViewController
            scanVC.inputDataDict = self.inputDataDict
            scanVC.detectionModes = tableData[indexPath.row - 1]
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
    }
}
