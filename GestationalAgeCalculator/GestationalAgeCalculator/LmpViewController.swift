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
    
    @IBOutlet weak var resetBtn: UIButton!  // 初期化ボタン
    
    // MARK: member variables
    var isJpn = false
    var totalDaysLbl = ""
    var datePicker: UIDatePicker!
    var lmpDatePicker: UIDatePicker!
    var lmpDate: Date!
    var baseDate: Date!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplay()
        
        // keyboardにdoneボタンを追加
        lmpInput.inputAccessoryView = makeDoneButtonToPicker()
        baseDateInput.inputAccessoryView = makeDoneButtonToPicker()
        
        lmpInput.text = defaultDateString
        baseDateInput.text = defaultDateString
        
        lmpDate = defaultDate
        baseDate = defaultDate
        
        // 基準日datepickerを生成
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        // LMPdatepickerを生成
        lmpDatePicker = UIDatePicker()
        lmpDatePicker.timeZone = NSTimeZone.local
        lmpDatePicker.datePickerMode = .date
        lmpDatePicker.calendar = Calendar(identifier: .gregorian)
        lmpDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    // MARK: IBAction
    // 入力データ初期化
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        lmpDate = defaultDate
        baseDate = defaultDate
        baseDateInput.text = defaultDateString
        lmpInput.text = defaultDateString
        expectedDateOfDeliveryLbl.text = ""
        getaionalWeekLbl.text = "0"
        remainderDaysLbl.text = "0"
        if isJpn {
            totalGetationalDaysLbl.text = "0" + totalDaysLbl
        } else {
            totalGetationalDaysLbl.text = totalDaysLbl + "0"
        }
        datePicker.setDate(defaultDate, animated: false)
        lmpDatePicker.setDate(defaultDate, animated: false)
    }
    
    // MARK: methods
    func setupDisplay() {
        var lmpTitle = ""
        var baseDateTitle = ""
        var eddTitle = ""
        var ageTitle = ""
        var weekLbl = ""
        var daysLbl = ""
        var reset = ""
        
        switch language {
        case "jpn":
            isJpn = true
            
            lmpTitle = "最終月経開始日："
            baseDateTitle = "計算の基準日："
            eddTitle = "分娩予定日（修正なし）："
            ageTitle = "基準日の妊娠週数"
            weekLbl = "週"
            daysLbl = "日"
            totalDaysLbl = "　日目"
            reset = "初期化"
        case "eng":
            lmpTitle = "The first day of the last menstrual period (LMP)"
            baseDateTitle = "Reference Day"
            eddTitle = "Expected Date of Delivery (without adjustment)"
            ageTitle = "Getational Age\n on the Reference Day"
            weekLbl = "week(s)"
            daysLbl = "day(s)"
            totalDaysLbl = "day "
            reset = "Reset"
        case "fre":
            lmpTitle = "Le premier jour de vos dernières règles"
            baseDateTitle = "Date de référence"
            eddTitle = "La date présumée de votre accouchement sans modification"
            ageTitle = "Âge gestationnel"
            weekLbl = "semaine(s)"
            daysLbl = "jour(s)"
            totalDaysLbl = "jour "
            reset = "Réinitialiser"
        default:
            break
        }
        self.lmpTitle.text = lmpTitle
        self.baseDateTitle.text = baseDateTitle
        expectedDateOfDeliveryTitle.text = eddTitle
        getationalAgeTitle.text = ageTitle
        self.weekLbl.text = weekLbl
        self.daysLbl.text = daysLbl
        if isJpn {
            totalGetationalDaysLbl.text = totalGetationalDaysLbl.text! + totalDaysLbl
        } else {
            totalGetationalDaysLbl.text = totalDaysLbl + totalGetationalDaysLbl.text!
        }
        resetBtn.setTitle(reset, for: .normal)
    }
    
    // doneボタンアクション
    @objc func doneButtonAction() {
        lmpInput.resignFirstResponder()
        baseDateInput.resignFirstResponder()
        
        expectedDateOfDeliveryLbl.text = calcEddFromLmp(fromDate: lmpDate)
        let (week, remainder, day) = calcGetationalAge(fromDate: lmpDate, toDate: baseDate!)
        getaionalWeekLbl.text = week
        remainderDaysLbl.text = remainder
        if isJpn {
            totalGetationalDaysLbl.text = day + totalDaysLbl
        } else {
            totalGetationalDaysLbl.text = totalDaysLbl + day
        }
    }
    
    // datepicker制御
    @objc func handleDatePicker() {
        if lmpInput.isFirstResponder {
            lmpDate = lmpDatePicker.date
            lmpInput.text = formatteDateForPicker(date: lmpDatePicker.date)
        }
        if baseDateInput.isFirstResponder {
            baseDate = datePicker.date
            baseDateInput.text = formatteDateForPicker(date: datePicker.date)
        }
    }
}

extension LmpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.inputView = lmpDatePicker
        case 1:
            textField.inputView = datePicker
        default:
            break
        }
        return true
    }
}
