//
//  Remider.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2022/3/5.
//

import Foundation

struct Remider {
    var id: String
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}
