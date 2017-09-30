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
    var datePicker: UIDatePicker!
    var eddDate: Date!
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDisplay()
        
        // keyboardにdoneボタンを追加
        self.eddInput.inputAccessoryView = self.makeDoneButtonToPicker()
        self.baseDateInput.inputAccessoryView = self.makeDoneButtonToPicker()
        
        self.eddInput.text = self.defaultDateString
        self.baseDateInput.text = self.defaultDateString
        
        self.eddDate = self.defaultDate
        self.baseDate = self.defaultDate
        
        // datepickerを生成
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .date
        self.datePicker.calendar = Calendar(identifier: .gregorian)
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
    }
    
    // MARK: IBAction
    // 入力データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        self.baseDate = self.defaultDate
        self.eddDate = self.defaultDate
        self.baseDateInput.text = self.defaultDateString
        self.eddInput.text = self.defaultDateString
        self.getationalWeek.text = "0"
        self.remainderDays.text = "0"
        if self.isJpn {
            self.totalGetationalDays.text = "0" + self.totalDaysLbl
        } else {
            self.totalGetationalDays.text = self.totalDaysLbl + "0"
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
        
        switch self.language {
        case "jpn":
            self.isJpn = true
            
            eddInputTitle = "分娩予定日："
            baseDateTitle = "計算の基準日："
            ageTitle = "基準日の妊娠週数"
            weekLbl = "週"
            daysLbl = "日"
            self.totalDaysLbl = "　日目"
            reset = "初期化"
        case "eng":
            eddInputTitle = "Expected Date of Delivery"
            baseDateTitle = "Reference Day"
            
            ageTitle = "Getational Age on the Reference Day"
            weekLbl = "week(s)"
            daysLbl = "day(s)"
            self.totalDaysLbl = "day "
            reset = "Reset"
        case "fre":
            eddInputTitle = "La date présumée de votre accouchement"
            baseDateTitle = "Date de référence"
            ageTitle = "Âge gestationnel"
            weekLbl = "semaine(s)"
            daysLbl = "jour(s)"
            self.totalDaysLbl = "jour "
            reset = "réinitialiser"
        default:
            break
        }
        self.eddTitle.text = eddInputTitle
        self.baseDateTitle.text = baseDateTitle
        self.getationalAgeTitle.text = ageTitle
        self.weekLbl.text = weekLbl
        self.dayLbl.text = daysLbl
        if self.isJpn {
            self.totalGetationalDays.text = self.totalGetationalDays.text! + self.totalDaysLbl
        } else {
            self.totalGetationalDays.text = self.totalDaysLbl + self.totalGetationalDays.text!
        }
        self.resetBtn.setTitle(reset, for: .normal)
    }
    
    // doneボタンアクション
    func doneButtonAction() {
        self.baseDateInput.resignFirstResponder()
        self.eddInput.resignFirstResponder()
        let (week, remainder, day) = self.calcGetationalAgeFromEdd(fromDate: self.eddDate, toDate: self.baseDate)
        self.getationalWeek.text = week
        self.remainderDays.text = remainder
        if self.isJpn {
            self.totalGetationalDays.text = day + self.totalDaysLbl
        } else {
            self.totalGetationalDays.text = self.totalDaysLbl + day
        }
    }
    
    // datepicker制御
    func handleDatePicker(){
        if self.eddInput.isFirstResponder {
            self.eddDate = self.datePicker.date
            self.eddInput.text = self.formatteDateForPicker(date: self.datePicker.date)
        }
        if self.baseDateInput.isFirstResponder {
            self.baseDate = self.datePicker.date
            self.baseDateInput.text = self.formatteDateForPicker(date: self.datePicker.date)
        }
    }
}

extension EddViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputView = self.datePicker
        return true
    }
}
