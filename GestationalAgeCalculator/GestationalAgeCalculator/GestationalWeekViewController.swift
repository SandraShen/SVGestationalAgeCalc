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
        gestationalWeekInput.inputAccessoryView = makeDoneButtonToPicker()
        gestationalDaysInput.inputAccessoryView = makeDoneButtonToPicker()
        baseDateInput.inputAccessoryView = makeDoneButtonToPicker()
        
        // 基準日datepickerを生成
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        // 妊娠週数・日数選択pickerを生成
        weekPicker = UIPickerView()
        daysPicker = UIPickerView()
        weekPicker.tag = 0
        daysPicker.tag = 1
        weekPicker.delegate = self
        daysPicker.delegate = self
        weekPicker.dataSource = self
        daysPicker.dataSource = self
        
        weekPicker.selectRow(5, inComponent: 0, animated: false)
        daysPicker.selectRow(0, inComponent: 0, animated: false)
        
        // textfield初期値、基準日初期値設定
        gestationalWeekInput.text = weekPicker.selectedRow(inComponent: 0).description
        gestationalDaysInput.text = daysPicker.selectedRow(inComponent: 0).description
            baseDateInput.text = defaultDateString
        baseDate = defaultDate
        
        // 分娩予定日表示は初期値を元に計算
        eddLbl.text = calcEddFromGestationalWeeks(weeks: Int(gestationalWeekInput.text!)!, days: Int(gestationalDaysInput.text!)!, baseDate: baseDate)
    }
    
    // MARK: methods
    @objc func handleDatePicker() {
        baseDate = datePicker.date
        baseDateInput.text = formatteDateForPicker(date: datePicker.date)
    }
    
    // doneボタンアクション
    func doneButtonAction() {
        baseDateInput.resignFirstResponder()
        gestationalWeekInput.resignFirstResponder()
        gestationalDaysInput.resignFirstResponder()
        eddLbl.text = calcEddFromGestationalWeeks(weeks: Int(gestationalWeekInput.text!)!, days: Int(gestationalDaysInput.text!)!, baseDate: baseDate)
    }
    
    // MARK: IBActions
    // データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        baseDate = defaultDate
        baseDateInput.text = defaultDateString
        
        weekPicker.selectRow(5, inComponent: 0, animated: false)
        daysPicker.selectRow(0, inComponent: 0, animated: false)
        
        gestationalWeekInput.text = weekPicker.selectedRow(inComponent: 0).description
        gestationalDaysInput.text = daysPicker.selectedRow(inComponent: 0).description
        
        eddLbl.text = calcEddFromGestationalWeeks(weeks: Int(gestationalWeekInput.text!)!, days: Int(gestationalDaysInput.text!)!, baseDate: baseDate)
    }
}

extension GestationalWeekViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.inputView = datePicker
        } else if textField.tag == 0 {
            textField.inputView = weekPicker
        } else {
            textField.inputView = daysPicker
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
            gestationalWeekInput.text = row.description
        } else {
            gestationalDaysInput.text = row.description
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
