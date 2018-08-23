//
//  EddViewController.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2017/09/16.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class EddViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var eddTitle: UILabel!
    @IBOutlet weak var eddInput: UITextField!   // 分娩予定日
    
    @IBOutlet weak var baseDateTitle: UILabel!
    @IBOutlet weak var baseDateInput: UITextField!  // 計算基準日
    
    @IBOutlet weak var getationalAgeTitle: UILabel!
    @IBOutlet weak var getationalWeek: UILabel!     // 週数
    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var remainderDays: UILabel!      // 余り日数
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var totalGetationalDays: UILabel!// トータル妊娠日数
    
    @IBOutlet weak var resetBtn: UIButton!  // 初期化ボタン
    
    // MARK: member variables
    var isJpn = false
    var totalDaysLbl = ""
    var eddDatePicker: UIDatePicker!    // 分娩予定日datepicker
    var datePicker: UIDatePicker!       // 基準日datepicker
    var eddDate: Date!
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplay()
        
        // keyboardにdoneボタンを追加
        eddInput.inputAccessoryView = makeDoneButtonToPicker()
        baseDateInput.inputAccessoryView = makeDoneButtonToPicker()
        
        eddInput.text = defaultDateString
        baseDateInput.text = defaultDateString
        
        eddDate = defaultDate
        baseDate = defaultDate
        
        // datepickerを生成
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        eddDatePicker = UIDatePicker()
        eddDatePicker.timeZone = NSTimeZone.local
        eddDatePicker.datePickerMode = .date
        eddDatePicker.calendar = Calendar(identifier: .gregorian)
        eddDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    // MARK: IBAction
    // 入力データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        baseDate = defaultDate
        eddDate = defaultDate
        baseDateInput.text = defaultDateString
        eddInput.text = defaultDateString
        getationalWeek.text = "0"
        remainderDays.text = "0"
        if isJpn {
            totalGetationalDays.text = "0" + totalDaysLbl
        } else {
            totalGetationalDays.text = totalDaysLbl + "0"
        }
    }
    
    // MARK: methods
    func setupDisplay() {
        var eddInputTitle = ""
        var baseDateTitle = ""
        var ageTitle = ""
        var weekLbl = ""
        var daysLbl = ""
        var reset = ""
        
        switch language {
        case "jpn":
            isJpn = true
            
            eddInputTitle = "分娩予定日："
            baseDateTitle = "計算の基準日："
            ageTitle = "基準日の妊娠週数"
            weekLbl = "週"
            daysLbl = "日"
            totalDaysLbl = "　日目"
            reset = "初期化"
        case "eng":
            eddInputTitle = "Expected Date of Delivery"
            baseDateTitle = "Reference Day"
            
            ageTitle = "Getational Age on the Reference Day"
            weekLbl = "week(s)"
            daysLbl = "day(s)"
            totalDaysLbl = "day "
            reset = "Reset"
        case "fre":
            eddInputTitle = "La date présumée de votre accouchement"
            baseDateTitle = "Date de référence"
            ageTitle = "Âge gestationnel"
            weekLbl = "semaine(s)"
            daysLbl = "jour(s)"
            totalDaysLbl = "jour "
            reset = "réinitialiser"
        default:
            break
        }
        eddTitle.text = eddInputTitle
        self.baseDateTitle.text = baseDateTitle
        getationalAgeTitle.text = ageTitle
        self.weekLbl.text = weekLbl
        dayLbl.text = daysLbl
        if isJpn {
            totalGetationalDays.text = totalGetationalDays.text! + totalDaysLbl
        } else {
            totalGetationalDays.text = totalDaysLbl + totalGetationalDays.text!
        }
        resetBtn.setTitle(reset, for: .normal)
    }
    
    // doneボタンアクション
    func doneButtonAction() {
        baseDateInput.resignFirstResponder()
        eddInput.resignFirstResponder()
        let (week, remainder, day) = calcGetationalAgeFromEdd(fromDate: eddDate, toDate: baseDate)
        getationalWeek.text = week
        remainderDays.text = remainder
        if isJpn {
            totalGetationalDays.text = day + totalDaysLbl
        } else {
            totalGetationalDays.text = totalDaysLbl + day
        }
    }
    
    // datepicker制御
    @objc func handleDatePicker() {
        if eddInput.isFirstResponder {
            eddDate = eddDatePicker.date
            eddInput.text = formatteDateForPicker(date: eddDatePicker.date)
        }
        if baseDateInput.isFirstResponder {
            baseDate = datePicker.date
            baseDateInput.text = formatteDateForPicker(date: datePicker.date)
        }
    }
}

extension EddViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            textField.inputView = eddDatePicker
        } else {
            textField.inputView = datePicker
        }
        return true
    }
}
