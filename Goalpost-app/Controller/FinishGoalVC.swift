//
//  FinishGoalVC.swift
//  Goalpost-app
//
//  Created by Nan on 2018/2/21.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController {
    // Outlets
    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTxt: UITextField!
    // Variable
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
    }
    
    @IBAction func createGoalBtnPressed(_ sender: Any) {
        // Pass data into Core Data Goal Model
    }
    
}
