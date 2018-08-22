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
    var operationKey: OperationKey!
    
    var digitPicker: UIPickerView!
    
    let digit = ["1桁", "2桁", "3桁", "4桁"]
    var firstRandomDigit: Int!
    var secondRandomDigit: Int!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        digitPicker = UIPickerView()
        digitPicker.delegate = self
        digitPicker.dataSource = self
        
        firstNumberDigit.inputAccessoryView = makeDoneButtonToPicker()
        secondNumberDigit.inputAccessoryView = makeDoneButtonToPicker()
        answerInput.inputAccessoryView = makeDoneMinusButtonToPicker()
        
        checkIconBtn.isHidden = true
        
        // 初期値は足し算
        operationLbl.text = "+"
        operationKey = .plus
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        digitPicker.selectRow(1, inComponent: 0, animated: false)
        firstNumberDigit.text = digit[digitPicker.selectedRow(inComponent: 0)]
        secondNumberDigit.text = digit[digitPicker.selectedRow(inComponent: 0)]
        firstRandomDigit = digitPicker.selectedRow(inComponent: 0)
        secondRandomDigit = digitPicker.selectedRow(inComponent: 0)
        start()
    }
    
    // MARK: IBActions
    @IBAction func operationChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            operationKey = .plus
        case 1:
            operationKey = .minus
        case 2:
            operationKey = .multiply
        case 3:
            operationKey = .divide
        default:
            break
        }
        operationLbl.text = operationKey.dispStr
        answerLbl.text = nil
        startQuiz(operationKey: operationKey)
    }
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        start()
    }
    
    @IBAction func answerBtnTapped(_ sender: UIButton) {
        if let answer = self.answer {
            answerLbl.text = String(answer)
            checkIconBtn.isHidden = !(answerLbl.text == answerInput.text)
        }
    }
    
    @IBAction func endBtnTapped(_ sender: UIButton) {
        firstNumberDigit.text = ""
        secondNumberDigit.text = ""
        firstNumberLbl.text = ""
        secondNumberLbl.text = ""
        answerInput.text = ""
        answerLbl.text = ""
        answer = nil
        
        checkIconBtn.isHidden = true
        
        startBtn.setTitle("開始", for: .normal)
    }
    
    // MARK: methods
    // doneボタンアクション
    @objc func doneButtonAction() {
        firstNumberDigit.resignFirstResponder()
        secondNumberDigit.resignFirstResponder()
        answerInput.resignFirstResponder()
        guard let _ = answer else {
            return
        }
        
        guard let text = answerInput.text, !text.isEmpty else {
            return
        }
        
        checkAnswer(answer: text)
    }
    
    func toggleMinus() {
        guard let text = answerInput.text else {
            return
        }
        
        var newText = text
        if newText.hasPrefix("-") {
            if let range = newText.range(of: "-") {
                newText.removeSubrange(range)
                answerInput.text = newText
            }
        } else {
            if newText != "" {
                answerInput.text = "-" + newText
            } else {
                answerInput.text = "-"
            }
        }
    }
    
    func start() {
        guard let firstNumberDigit = firstNumberDigit.text, !firstNumberDigit.isEmpty else {
            return
        }
        
        guard let secondNumberDigit = secondNumberDigit.text, !secondNumberDigit.isEmpty else {
            return
        }
        
        answerLbl.text = nil
        answerInput.text = nil
        checkIconBtn.isHidden = true
        startBtn.setTitle("次の問題", for: .normal)
        startQuiz(operationKey: operationKey)
    }
    
    func startQuiz(operationKey: OperationKey) {
        guard firstNumberDigit.text != "", secondNumberDigit.text != "" else {
            return
        }
        
        // 桁数の応じてrandom範囲を指定
        var first = 10
        var second = 10
        var cheatAnswer = 0
        /*
         割り算 A/B=Answer の場合、Bとanswerに乱数を入れる
         A=B*Answer
         桁数ラベルを　「二つ目の数の桁数」、「解の桁数」に変更
         */
        guard operationKey != .divide else {
            // 一つ目：
            switch firstRandomDigit {
            case 0:
                second = Int(arc4random_uniform(10))
            case 1:
                second = Int(arc4random(lower: 10, upper: 99))
            case 2:
                second = Int(arc4random(lower: 100, upper: 999))
            case 3:
                second = Int(arc4random(lower: 1000, upper: 9999))
            default: break
            }
            // 二つ目：（答えに乱数）
            switch secondRandomDigit {
            case 0:
                cheatAnswer = Int(arc4random_uniform(10))
            case 1:
                cheatAnswer = Int(arc4random(lower: 10, upper: 99))
            case 2:
                cheatAnswer = Int(arc4random(lower: 100, upper: 999))
            case 3:
                cheatAnswer = Int(arc4random(lower: 1000, upper: 9999))
            default: break
            }
            
            first = second * cheatAnswer
            quizCalc(operationKey: operationKey, first: first, second: second, cheatAnswer: cheatAnswer)
            
            return
        }
        
        // 一つ目
        switch firstRandomDigit {
        case 0:
            first = Int(arc4random_uniform(10))
        case 1:
            first = Int(arc4random(lower: 10, upper: 99))
        case 2:
            first = Int(arc4random(lower: 100, upper: 999))
        case 3:
            first = Int(arc4random(lower: 1000, upper: 9999))
        default: break
        }
        
        // 二つ目
        switch  secondRandomDigit {
        case 0:
            second = Int(arc4random_uniform(10))
        case 1:
            second = Int(arc4random(lower: 10, upper: 99))
        case 2:
            second = Int(arc4random(lower: 100, upper: 999))
        case 3:
            second = Int(arc4random(lower: 1000, upper: 9999))
        default: break
        }
        
        quizCalc(operationKey: operationKey, first: first, second: second)
    }
    
    func quizCalc(operationKey: OperationKey, first: Int, second: Int, cheatAnswer: Int? = nil) {
        
        var answer: Int!
        
        switch operationKey {
        case .plus:
            answer = QuizCal(first: first, second: second, answer: 0).sum()
        case .minus:
            answer = QuizCal(first: first, second: second, answer: 0).del()
        case .multiply:
            answer = QuizCal(first: first, second: second, answer: 0).mul()
        case .divide:
            guard let cAnswer = cheatAnswer else {
                break
            }
            answer = cAnswer
        }
        
        self.answer = answer
        
        firstNumberLbl.text = String(first)
        secondNumberLbl.text = String(second)
    }
    
    func checkAnswer(answer: String) {
        answerLbl.text = String(answer)
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
            textField.inputView = digitPicker
            textField.text = digit[digitPicker.selectedRow(inComponent: 0)]
            firstRandomDigit = digitPicker.selectedRow(inComponent: 0)
            secondRandomDigit = digitPicker.selectedRow(inComponent: 0)
        }
        return true
    }
}

extension QuizViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return digit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if firstNumberDigit.isFirstResponder {
            firstNumberDigit.text = digit[row]
            firstRandomDigit = row
        }
        if secondNumberDigit.isFirstResponder {
            secondNumberDigit.text = digit[row]
            secondRandomDigit = row
        }
    }
}

extension QuizViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return digit.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

enum OperationKey: Int {
    case plus
    case minus
    case multiply
    case divide
    
    var dispStr: String {
        switch self {
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiply:
            return "*"
        case .divide:
            return "/"
        }
    }
}
