//
//  FinishGoalVC.swift
//  Goalpost-app
//
//  Created by Nan on 2018/2/21.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import CoreData

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
        if pointsTxt.text != "" && pointsTxt.text != "0" {
            self.save(completion: { (success) in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    func save(completion: @escaping (_ success: Bool) -> ()) {
        // 取得 ManagedContext 使用coreData
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTxt.text!)!
        goal.goalProgress = Int32(0)
        // 存取會拋出錯誤 所以使用try catch 來處理錯誤
        do {
            try managedContext.save()
            print("Successfully save data.")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
