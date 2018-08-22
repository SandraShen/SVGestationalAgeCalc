//
//  QuizCalculate.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2018/08/22.
//  Copyright © 2018年 OritoClinic. All rights reserved.
//

import Foundation

struct QuizCal {
    let first: Int!
    let second: Int!
    let answer: Int!
    
    func sum() -> Int {
        return first + second
    }
    
    func del() -> Int {
        return first - second
    }
    
    func mul() -> Int {
        return first * second
    }
    
    func div() -> Int {
        return answer * second
    }
}
