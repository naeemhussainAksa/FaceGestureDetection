//
//  PopupViewController.swift
//  KnowFace
//
//  Created by Naeem Hussain on 24/10/2022.
//

import UIKit

class PopupViewController: BaseViewController {

    
    // MARK: - Outlets -
    
    @IBOutlet weak var detailHolderView: UIView!
    @IBOutlet weak var tableVew: UITableView!
    @IBOutlet weak var constTableHeight: NSLayoutConstraint!
    @IBOutlet weak var constTop: NSLayoutConstraint!
    
    
    // MARK: - Declarations -
    
    var tableData : [PopupFields] = []
    
    // MARK: - Controller's Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVew.register(UINib(nibName: "PopupDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PopupDetailTableViewCell")
        tableVew.estimatedRowHeight = UITableView.automaticDimension
        tableVew.rowHeight = UITableView.automaticDimension
        detailHolderView.roundCornersTopView(20)
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableVew.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let holderHeight = detailHolderView.bounds.height
        self.constTop.constant = -holderHeight
        
        print("in viewDidAppear :", holderHeight)
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableVew.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tableVew && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.constTableHeight.constant = newSize.height
                    self.view.layoutIfNeeded()
                    print("height :", newSize.height)
                }
            }
        }
    }
    
    
    private func populateData()
    {
        let option = ["Name : ", "Father Name : ", "CNIC : ", "Gender : ", "Date of Birth : ", "Address : "]
        for title in option {
            
            let obj = PopupFields(name: title, detail: "Unknown")
            tableData.append(obj)
        }
        
        tableVew.reloadData()
    }

    // MARK: - Actions -
    
    @IBAction func crossAction(_ sender: Any) {
        
        self.constTop.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.view.layoutIfNeeded()
        } completion: { success in
            self.dismiss(animated: false)
        }
    }
}

extension PopupViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupDetailTableViewCell", for: indexPath) as! PopupDetailTableViewCell
        
        cell.config(tableData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
