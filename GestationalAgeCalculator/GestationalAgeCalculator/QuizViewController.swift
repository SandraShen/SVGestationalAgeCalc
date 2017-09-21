//
//  QuizViewController.swift
//  GestationalAgeCalculator
//
//  Created by 沈 穎音 on 2017/09/21.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var firstNumberDigit: UITextField!   // 一つ目の数字の桁数
    @IBOutlet weak var secondNumberDigit: UITextField!  // 二つ目の数字の桁数
    @IBOutlet weak var answerInput: UITextField!        // 答え入力textField
    @IBOutlet weak var operationSegment: UISegmentedControl!    // 計算符号切り替えセグメント
    
    @IBOutlet weak var firstNumberLbl: UILabel!
    @IBOutlet weak var secondNumberLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    
    @IBOutlet weak var checkIconBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    // MARK: Member variables
    var first: Int!
    var second: Int!
    
    var digitPicker: UIPickerView!
    
    // MARK: life cycle
    
}
