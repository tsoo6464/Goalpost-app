//
//  GoalsVC.swift
//  Goalpost-app
//
//  Created by Nan on 2018/2/10.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit
import CoreData
// 公開的 每個地方都能使用的變數
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoConstranint: NSLayoutConstraint!
    // Variables
    let screenSize = UIScreen.main.bounds
    var goals: [Goal] = []
    var undoGoal = Goals()
    var undoCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        self.tableView.reloadData()
    }
    
    func undoViewAnimate(constant: CGFloat) {
        undoConstranint.constant = constant
        UIView.animate(withDuration: 0.3) {
            // 更新view狀態
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (success) in
            if success {
                if self.goals.count >= 1 {
                    self.tableView.isHidden = false
                } else {
                    self.tableView.isHidden = true
                }
            }
        }
    }
    // 新增目標
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentDetail(createGoalVC)
    }
}
// TableView
extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    // 可否編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // 使cell沒有編輯控制鍵
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    // Cell能夠往左滑動刪除資料
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.undoViewAnimate(constant: 60)
            self.fetchCoreDataObjects()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        
        return [deleteAction, addAction]
    }
}
extension GoalsVC {
    // 增加完成次數
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
            print("Successfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    // 刪除資料
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        undoGoal.setGoals(description: goals[indexPath.row].goalDescription!, type: goals[indexPath.row].goalType!, completeValue: goals[indexPath.row].goalCompletionValue, progress: goals[indexPath.row].goalProgress)
        managedContext.delete(goals[indexPath.row])
        print(undoGoal)
        
        do {
            try managedContext.save()
            print("Successfully removed goal!")
            print(undoGoal)
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    // 獲取數據
    func fetch(completion: @escaping (_ success: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        do {
            goals = try managedContext.fetch(fetchRequest) as! [Goal]
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(true)
        }
        
    }
    // 復原上一個刪除的項目
    @IBAction func undoPressed(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let goal = Goal(context: managedContext)
        goal.goalDescription = undoGoal.description
        goal.goalType = undoGoal.type
        goal.goalCompletionValue = undoGoal.completeValue
        goal.goalProgress = undoGoal.progress
        goals.append(goal)
        
        do {
            try managedContext.save()
            self.fetchCoreDataObjects()
            self.tableView.reloadData()
            print(goals)
            print("Successfully undo")
        } catch {
            debugPrint("Cloud not undo: \(error.localizedDescription)")
        }
        undoViewAnimate(constant: 0)
    }
}
