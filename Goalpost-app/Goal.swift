//
//  Goal.swift
//  Goalpost-app
//
//  Created by Nan on 2018/3/1.
//  Copyright © 2018年 nan. All rights reserved.
//

import Foundation

class Goals {
    public private(set) var description: String!
    public private(set) var type: String!
    public private(set) var completeValue: Int32!
    public private(set) var progress: Int32!
    
    func setGoals(description: String, type: String, completeValue: Int32, progress: Int32) {
        self.description = description
        self.type = type
        self.completeValue = completeValue
        self.progress = progress
    }
}
