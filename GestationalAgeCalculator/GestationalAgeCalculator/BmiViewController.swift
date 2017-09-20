//
//  BmiViewController.swift
//  GestationalAgeCalculator
//
//  Created by 沈 穎音 on 2017/09/19.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class BmiViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var heightBeforDecimal: UITextField!
    
    @IBOutlet weak var heightAfterDecimal: UITextField!
    
    @IBOutlet weak var weightBeforDecimal: UITextField!
    
    @IBOutlet weak var weightAfterDecimal: UITextField!
    
    @IBOutlet weak var bmiResultLbl: UILabel!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    // MARK: member variables
    var heightBefor = ""
    var heightAfter = "0"
    var weightBefore = ""
    var weightAfter = "0"
    
    var height: Double!
    var weight: Double!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightBeforDecimal.inputAccessoryView = self.makeDoneButtonToPicker()
        self.heightAfterDecimal.inputAccessoryView = self.makeDoneButtonToPicker()
        self.weightBeforDecimal.inputAccessoryView = self.makeDoneButtonToPicker()
        self.weightAfterDecimal.inputAccessoryView = self.makeDoneButtonToPicker()
    }
    
    // MARK: IBAction
    // 画面表示初期化
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        self.heightBeforDecimal.text = ""
        self.heightAfterDecimal.text = ""
        self.weightBeforDecimal.text = ""
        self.weightAfterDecimal.text = ""
        self.bmiResultLbl.text = ""
        
        self.heightBefor = ""
        self.heightAfter = "0"
        self.weightBefore = ""
        self.weightAfter = "0"
    }
    
    // MARK: methods
    // BMI計算
    private func calc() {
        // BMI = 体重kg / (身長m * 身長m)
        if transferHeight() && transferWeight() {
            let res = self.weight / pow(self.height * 0.01, 2)
            let roundRes = round(res * 100) / 100
            self.bmiResultLbl.text = String(format: "%.2f", roundRes)
        }
    }
    
    func doneButtonAction() {
        if self.heightBeforDecimal.isFirstResponder {
            self.heightBefor = self.heightBeforDecimal.text ?? ""
            self.heightBeforDecimal.resignFirstResponder()
        }
        if self.heightAfterDecimal.isFirstResponder {
            self.heightAfter = self.heightAfterDecimal.text ?? "0"
            self.heightAfterDecimal.resignFirstResponder()
        }
        if self.weightBeforDecimal.isFirstResponder {
            self.weightBefore = self.weightBeforDecimal.text ?? ""
            self.weightBeforDecimal.resignFirstResponder()
        }
        if self.weightAfterDecimal.isFirstResponder {
            self.weightAfter = self.weightAfterDecimal.text ?? "0"
            self.weightAfterDecimal.resignFirstResponder()
        }
        self.calc()
    }
    
    private func transferHeight() -> Bool {
        if self.heightBefor != "" && self.heightAfter != "" {
            let heightStr = self.heightBefor + "." + self.heightAfter
            self.height = NumberFormatter().number(from: heightStr) as! Double
            return true
        }
        return false
    }
    
    private func transferWeight() -> Bool {
        if self.weightBefore != "" && self.weightAfter != "" {
            let weightStr = self.weightBefore + "." + self.weightAfter
            self.weight = NumberFormatter().number(from: weightStr) as! Double
            return true
        }
        return false
    }
}

extension BmiViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            self.heightBefor = self.heightBeforDecimal.text ?? ""
        case 1:
            self.heightAfter = self.heightAfterDecimal.text ?? ""
        case 2:
            self.weightBefore = self.weightBeforDecimal.text ?? ""
        case 3:
            self.weightAfter = self.weightAfterDecimal.text ?? ""
        default:
            break
        }
        return true
    }
}
