//
//  MoodModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import Foundation

@objc enum MoodModel: Int32, CaseIterable {
    case awful = 1, bad = 2, couldBeBetter = 3, cool = 4, awesome = 5
}

extension MoodModel {
    var description: String {
        switch self {
        case .awful:
            return "Awful"
        case .bad:
            return "Bad"
        case .couldBeBetter:
            return "Could be better"
        case .cool:
            return "Cool"
        case .awesome:
            return "Awesome"
        }
    }
}
