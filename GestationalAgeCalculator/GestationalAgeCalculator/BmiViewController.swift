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
    var heightAfter = ""
    var weightBefore = ""
    var weightAfter = ""
    
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
    }
    
    // MARK: methods
    // BMI計算
    private func calc() {
        // BMI = 体重kg / (身長m * 身長m)
        if transferHeight() && transferWeight() {
            let res = self.weight / pow(self.height * 0.01, 2)
            let roundRes = round(res * 100) / 100
            self.bmiResultLbl.text = roundRes.description
        }
    }
    
    func doneButtonAction() {
        if self.heightBeforDecimal.isFirstResponder {
            self.heightBefor = self.heightBeforDecimal.text ?? ""
            self.heightBeforDecimal.resignFirstResponder()
        }
        if self.heightAfterDecimal.isFirstResponder {
            self.heightAfter = self.heightAfterDecimal.text ?? ""
            self.heightAfterDecimal.resignFirstResponder()
        }
        if self.weightBeforDecimal.isFirstResponder {
            self.weightBefore = self.weightBeforDecimal.text ?? ""
            self.weightBeforDecimal.resignFirstResponder()
        }
        if self.weightAfterDecimal.isFirstResponder {
            self.weightAfter = self.weightAfterDecimal.text ?? ""
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
