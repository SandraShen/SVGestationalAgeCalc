//
//  GestationalWeekViewController.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2017/09/30.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit
class GestationalWeekViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var gestationalWeekInput: UITextField!
    @IBOutlet weak var baseDateInput: UITextField!
    
    @IBOutlet weak var eddLbl: UILabel!
    @IBOutlet weak var gestationalWeek: UILabel!
    @IBOutlet weak var remainderDaysLbl: UILabel!
    @IBOutlet weak var totalDaysLbl: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    // MARK: member variables
    var datePicker: UIDatePicker!
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboardにdoneボタンを追加
        self.gestationalWeekInput.inputAccessoryView = self.makeDoneButtonToPicker()
        self.baseDateInput.inputAccessoryView = self.makeDoneButtonToPicker()
        
        self.gestationalWeekInput.text = "0"
        self.baseDateInput.text = self.defaultDateString
        self.baseDate = self.defaultDate
        
        // 基準日datepickerを生成
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.calendar = Calendar(identifier: .gregorian)
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
    }
    
    // MARK: methods
    func handleDatePicker() {
        self.baseDate = self.datePicker.date
        self.baseDateInput.text = self.formatteDateForPicker(date: self.datePicker.date)
    }
    
    // doneボタンアクション
    func doneButtonAction() {
        self.baseDateInput.resignFirstResponder()
        self.gestationalWeekInput.resignFirstResponder()
        self.eddLbl.text = self.calcEddFromGestationalWeeks(weeks: Int(self.gestationalWeekInput.text!)!, baseDate: self.baseDate)
    }
    
    // MARK: IBActions
    // データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        self.baseDate = self.defaultDate
        self.baseDateInput.text = self.defaultDateString
        self.eddLbl.text = ""
        self.gestationalWeekInput.text = "0"
    }
}

extension GestationalWeekViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.inputView = self.datePicker
        } else {
            if textField.text == "0" {
                textField.text = ""
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            if (textField.text?.isEmpty)! || textField.text == nil {
                textField.text = "0"
            }
        }
        return true
    }
}
