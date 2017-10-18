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
    @IBOutlet weak var gestationalDaysInput: UITextField!
    @IBOutlet weak var baseDateInput: UITextField!
    
    @IBOutlet weak var eddLbl: UILabel!
    @IBOutlet weak var gestationalWeek: UILabel!
    @IBOutlet weak var remainderDaysLbl: UILabel!
    @IBOutlet weak var totalDaysLbl: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    // MARK: member variables
    var weekPicker: UIPickerView!   // 妊娠週数picker
    var daysPicker: UIPickerView!   // 妊娠日数picker
    var datePicker: UIDatePicker!   // 基準日datepicker
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboardにdoneボタンを追加
        self.gestationalWeekInput.inputAccessoryView = self.makeDoneButtonToPicker()
        self.gestationalDaysInput.inputAccessoryView = self.makeDoneButtonToPicker()
        self.baseDateInput.inputAccessoryView = self.makeDoneButtonToPicker()
        
        // 基準日datepickerを生成
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.calendar = Calendar(identifier: .gregorian)
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
        
        // 妊娠週数・日数選択pickerを生成
        self.weekPicker = UIPickerView()
        self.daysPicker = UIPickerView()
        self.weekPicker.tag = 0
        self.daysPicker.tag = 1
        self.weekPicker.delegate = self
        self.daysPicker.delegate = self
        self.weekPicker.dataSource = self
        self.daysPicker.dataSource = self
        
        self.weekPicker.selectRow(5, inComponent: 0, animated: false)
        self.daysPicker.selectRow(0, inComponent: 0, animated: false)
        
        // textfield初期値、基準日初期値設定
        self.gestationalWeekInput.text = self.weekPicker.selectedRow(inComponent: 0).description
        self.gestationalDaysInput.text = self.daysPicker.selectedRow(inComponent: 0).description
            self.baseDateInput.text = self.defaultDateString
        self.baseDate = self.defaultDate
        
        // 分娩予定日表示は初期値を元に計算
        self.eddLbl.text = self.calcEddFromGestationalWeeks(weeks: Int(self.gestationalWeekInput.text!)!, days: Int(self.gestationalDaysInput.text!)!, baseDate: self.baseDate)
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
        self.gestationalDaysInput.resignFirstResponder()
        self.eddLbl.text = self.calcEddFromGestationalWeeks(weeks: Int(self.gestationalWeekInput.text!)!, days: Int(self.gestationalDaysInput.text!)!, baseDate: self.baseDate)
    }
    
    // MARK: IBActions
    // データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        self.baseDate = self.defaultDate
        self.baseDateInput.text = self.defaultDateString
        
        self.weekPicker.selectRow(5, inComponent: 0, animated: false)
        self.daysPicker.selectRow(0, inComponent: 0, animated: false)
        
        self.gestationalWeekInput.text = self.weekPicker.selectedRow(inComponent: 0).description
        self.gestationalDaysInput.text = self.daysPicker.selectedRow(inComponent: 0).description
        
        self.eddLbl.text = self.calcEddFromGestationalWeeks(weeks: Int(self.gestationalWeekInput.text!)!, days: Int(self.gestationalDaysInput.text!)!, baseDate: self.baseDate)
    }
}

extension GestationalWeekViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.inputView = self.datePicker
        } else if textField.tag == 0 {
            textField.inputView = self.weekPicker
        } else {
            textField.inputView = self.daysPicker
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

extension GestationalWeekViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let weeks = Array(0..<43)
        let days = Array(0..<7)
        if pickerView.tag == 0 {
            return weeks[row].description
        } else {
            return days[row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.gestationalWeekInput.text = row.description
        } else {
            self.gestationalDaysInput.text = row.description
        }
    }
}

extension GestationalWeekViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return 43
        } else {
            return 7
        }
    }
}
