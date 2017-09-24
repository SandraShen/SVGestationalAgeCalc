//
//  QuizViewController.swift
//  GestationalAgeCalculator
//
//  Created by 沈 穎音 on 2017/09/21.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class QuizViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var firstNumberDigit: UITextField!   // 一つ目の数字の桁数
    @IBOutlet weak var secondNumberDigit: UITextField!  // 二つ目の数字の桁数
    @IBOutlet weak var answerInput: UITextField!        // 答え入力textField
    @IBOutlet weak var operationSegment: UISegmentedControl!    // 計算符号切り替えセグメント
    
    @IBOutlet weak var firstNumberLbl: UILabel!
    @IBOutlet weak var secondNumberLbl: UILabel!
    @IBOutlet weak var operationLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    
    @IBOutlet weak var checkIconBtn: UIButton!
    @IBOutlet weak var answerBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    // MARK: Member variables
    var first: Int!
    var second: Int!
    var answer: Int!
    var isPlus = true
    var isStarted = false
    
    var digitPicker: UIPickerView!
    
    let digit = ["1桁", "2桁", "3桁", "4桁"]
    var firstRandomDigit: Int!
    var secondRandomDigit: Int!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.digitPicker = UIPickerView()
        self.digitPicker.delegate = self
        self.digitPicker.dataSource = self
        
        self.firstNumberDigit.inputAccessoryView = self.makeDoneButtonToPicker()
        self.secondNumberDigit.inputAccessoryView = self.makeDoneButtonToPicker()
        self.answerInput.inputAccessoryView = self.makeDoneMinusButtonToPicker()
        
        self.checkIconBtn.isHidden = true
    }
    
    // MARK: IBActions
    @IBAction func operationChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.operationLbl.text = "+"
            self.isPlus = true
        case 1:
            self.operationLbl.text = "-"
            self.isPlus = false
        default:
            break
        }
    }
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        if !self.isStarted {
            guard self.firstNumberDigit.text != nil, self.firstNumberDigit.text != "" else {
                return
            }
            
            guard self.secondNumberDigit.text != nil, self.secondNumberDigit.text != "" else {
                return
            }
            
            self.startBtn.setTitle("次の問題", for: .normal)
            self.isStarted = true
        } else {
            self.answerInput.text = ""
            self.checkIconBtn.isHidden = true
            self.answerLbl.text = ""
        }
        self.startQuiz()
    }
    
    @IBAction func answerBtnTapped(_ sender: UIButton) {
        if self.answer != nil {
            self.answerLbl.text = String(self.answer)
        }
    }
    
    @IBAction func endBtnTapped(_ sender: UIButton) {
        self.firstNumberDigit.text = ""
        self.secondNumberDigit.text = ""
        self.firstNumberLbl.text = ""
        self.secondNumberLbl.text = ""
        self.answerInput.text = ""
        self.answerLbl.text = ""
        self.answer = nil
        
        self.checkIconBtn.isHidden = true
        
        self.startBtn.setTitle("開始", for: .normal)
        self.isStarted = false
    }
    
    // MARK: methods
    // doneボタンアクション
    func doneButtonAction() {
        self.firstNumberDigit.resignFirstResponder()
        self.secondNumberDigit.resignFirstResponder()
        
        if self.answerInput.isFirstResponder && self.answer != nil {
            if let text = self.answerInput.text {
                if text != "" {
                    self.checkAnswer(answer: text)
                }
            }
        }
        self.answerInput.resignFirstResponder()
    }
    
    func toggleMinus() {
        if let text = self.answerInput.text {
            var newText = text
            if newText.hasPrefix("-") {
                if let range = newText.range(of: "-") {
                    newText.removeSubrange(range)
                    self.answerInput.text = newText
                }
            } else {
                if newText != "" {
                    self.answerInput.text = "-" + newText
                } else {
                    self.answerInput.text = "-"
                }
            }
        }
    }
    
    func startQuiz() {
        if self.firstNumberDigit.text != "" && self.secondNumberDigit.text != "" {
            // 桁数の応じてrandom範囲を指定
            var first = 10
            var second = 10
            
            // 一つ目
            switch self.firstRandomDigit {
            case 0:
                first = Int(arc4random_uniform(10))
            case 1:
                first = Int(self.arc4random(lower: 10, upper: 99))
            case 2:
                first = Int(self.arc4random(lower: 100, upper: 999))
            case 3:
                first = Int(self.arc4random(lower: 1000, upper: 9999))
            default: break
            }
            
            // 二つ目
            switch  self.secondRandomDigit {
            case 0:
                second = Int(arc4random_uniform(10))
            case 1:
                second = Int(self.arc4random(lower: 10, upper: 99))
            case 2:
                second = Int(self.arc4random(lower: 100, upper: 999))
            case 3:
                second = Int(self.arc4random(lower: 1000, upper: 9999))
            default: break
            }
            
            self.quizCalc(operationFlg: self.isPlus, first: first, second: second)
        }
    }
    
    func quizCalc(operationFlg: Bool, first: Int, second: Int) {        
        self.firstNumberLbl.text = String(first)
        self.secondNumberLbl.text = String(second)
        
        var answer: Int!
        if operationFlg {
            answer = first + second
            print("@@ + answer : \(answer)")
        } else {
            answer = first - second
            print("@@ - answer : \(answer)")
        }
        
        self.answer = answer
    }
    
    func checkAnswer(answer: String) {
        if answer == String(self.answer) {
            self.checkIconBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        } else {
            self.checkIconBtn.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
            self.answerLbl.text = String(self.answer)
        }
        self.checkIconBtn.isHidden = false
    }
    
    func arc4random(lower: UInt32, upper: UInt32) -> UInt32 {
        guard upper >= lower else {
            return 0
        }
        
        return arc4random_uniform(upper - lower) + lower
    }
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag != 1 {
            textField.inputView = self.digitPicker
            textField.text = self.digit[self.digitPicker.selectedRow(inComponent: 0)]
            self.firstRandomDigit = self.digitPicker.selectedRow(inComponent: 0)
            self.secondRandomDigit = self.digitPicker.selectedRow(inComponent: 0)
        }
        return true
    }
}

extension QuizViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.digit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.firstNumberDigit.isFirstResponder {
            self.firstNumberDigit.text = self.digit[row]
            self.firstRandomDigit = row
        }
        if self.secondNumberDigit.isFirstResponder {
            self.secondNumberDigit.text = self.digit[row]
            self.secondRandomDigit = row
        }
    }
}

extension QuizViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.digit.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
