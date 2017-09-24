//
//  LmpViewController.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2017/09/16.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class LmpViewController: BaseViewController {
    // MARK: IBOutlets
    @IBOutlet weak var lmpTitle: UILabel!
    @IBOutlet weak var lmpInput: UITextField!   // 最終月経開始日
    
    @IBOutlet weak var baseDateTitle: UILabel!
    @IBOutlet weak var baseDateInput: UITextField!  // 計算基準日
    
    @IBOutlet weak var expectedDateOfDeliveryTitle: UILabel!
    @IBOutlet weak var expectedDateOfDeliveryLbl: UILabel!  //　分娩予定日ラベル
    
    @IBOutlet weak var getationalAgeTitle: UILabel!
    @IBOutlet weak var getaionalWeekLbl: UILabel!   // 週数
    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var remainderDaysLbl: UILabel!   // 余り日数
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var totalGetationalDaysLbl: UILabel! //　トータル妊娠日数
    @IBOutlet weak var totalDaysLbl: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!  // 初期化ボタン
    
    // MARK: member variables
    var datePicker: UIDatePicker!
    var lmpDate: Date!
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDisplay()
        
        // keyboardにdoneボタンを追加
        self.lmpInput.inputAccessoryView = self.makeDoneButtonToPicker()
        self.baseDateInput.inputAccessoryView = self.makeDoneButtonToPicker()
        
        self.lmpInput.text = self.defaultDateString
        self.baseDateInput.text = self.defaultDateString
        
        self.lmpDate = self.defaultDate
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
        self.lmpDate = self.defaultDate
        self.baseDate = self.defaultDate
        self.baseDateInput.text = self.defaultDateString
        self.lmpInput.text = self.defaultDateString
        self.expectedDateOfDeliveryLbl.text = ""
        self.getaionalWeekLbl.text = "0"
        self.remainderDaysLbl.text = "0"
        self.totalGetationalDaysLbl.text = "0"
    }
    
    // MARK: methods
    func setupDisplay() {
        var lmpTitle = ""
        var baseDateTitle = ""
        var eddTitle = ""
        var ageTitle = ""
        var weekLbl = ""
        var daysLbl = ""
        var totalDaysLbl = ""
        var reset = ""
        
        switch self.language {
        case "jpn":
            lmpTitle = "最終月経開始日："
            baseDateTitle = "計算の基準日："
            eddTitle = "分娩予定日（修正なし）："
            ageTitle = "基準日の妊娠週数"
            weekLbl = "週"
            daysLbl = "日"
            totalDaysLbl = "日目"
            reset = "初期化"
        case "eng":
            lmpTitle = "The first day of the last menstrual period (LMP)"
            baseDateTitle = "Reference Day"
            eddTitle = "Expected Date of Delivery (without adjustment)"
            ageTitle = "Getational Age on the Reference Day"
            weekLbl = "week"
            daysLbl = "days"
            totalDaysLbl = "days"
            reset = "Reset"
        case "fre":
            lmpTitle = "Le premier jour de vos dernières règles"
            baseDateTitle = "Date de référence"
            eddTitle = "La date présumée de votre accouchement sans modification"
            ageTitle = "Âge gestationnel"
            weekLbl = "Semaine"
            daysLbl = "jours"
            totalDaysLbl = "jours"
            reset = "Réinitialiser"
        default:
            break
        }
        self.lmpTitle.text = lmpTitle
        self.baseDateTitle.text = baseDateTitle
        self.expectedDateOfDeliveryTitle.text = eddTitle
        self.getationalAgeTitle.text = ageTitle
        self.weekLbl.text = weekLbl
        self.daysLbl.text = daysLbl
        self.totalDaysLbl.text = totalDaysLbl
        self.resetBtn.setTitle(reset, for: .normal)
    }
    
    // doneボタンアクション
    func doneButtonAction() {
        self.lmpInput.resignFirstResponder()
        self.baseDateInput.resignFirstResponder()
        
        self.expectedDateOfDeliveryLbl.text = self.calcEddFromLmp(fromDate: lmpDate)
        let (week, remainder, day) = self.calcGetationalAge(fromDate: lmpDate, toDate: baseDate)
        self.getaionalWeekLbl.text = week
        self.remainderDaysLbl.text = remainder
        self.totalGetationalDaysLbl.text = day
    }
    
    // datepicker制御
    func handleDatePicker() {
        if self.lmpInput.isFirstResponder {
            self.lmpDate = self.datePicker.date
            self.lmpInput.text = self.formatteDateForPicker(date: self.datePicker.date)
        }
        if self.baseDateInput.isFirstResponder {
            self.baseDate = self.datePicker.date
            self.baseDateInput.text = self.formatteDateForPicker(date: self.datePicker.date)
        }
    }
}

extension LmpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputView = self.datePicker
        return true
    }
}
