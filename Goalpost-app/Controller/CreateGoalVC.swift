//
//  CreateGoalVC.swift
//  Goalpost-app
//
//  Created by Nan on 2018/2/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {
    // Outlets
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // IBAction
    @IBAction func nextBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func shortTermBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func longTermBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
}
