//
//  Reminder.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2022/4/4.
//

import Foundation

struct Reminder {
    var id: String
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}
