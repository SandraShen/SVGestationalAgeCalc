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
    var heightBefore = ""
    var heightAfter = "0"
    var weightBefore = ""
    var weightAfter = "0"
    
    var picker = UIPickerView()
    var decimalPicker = UIPickerView()
    
    var height: Double!
    var weight: Double!
    
    let decimalArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var heightArray: [Int] = {
        var array: [Int] = []
        for i in 120...250 {
            array.append(i)
        }
        return array
    }()
    var weightArray: [Int] = {
        var array: [Int] = []
        for i in 30...250 {
            array.append(i)
        }
        return array
    }()
 
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBeforDecimal.inputAccessoryView = makeDoneButtonToPicker()
        heightAfterDecimal.inputAccessoryView = makeDoneButtonToPicker()
        weightBeforDecimal.inputAccessoryView = makeDoneButtonToPicker()
        weightAfterDecimal.inputAccessoryView = makeDoneButtonToPicker()
        
        picker.delegate = self
        picker.dataSource = self
        decimalPicker.delegate = self
        decimalPicker.dataSource = self
        
        heightBeforDecimal.text = heightArray[30].description
        heightAfterDecimal.text = decimalArray[0].description
        heightBefore = heightBeforDecimal.text!
        heightAfter = heightAfterDecimal.text!
        
        weightBeforDecimal.text = weightArray[20].description
        weightAfterDecimal.text = decimalArray[0].description
        weightBefore = weightBeforDecimal.text!
        weightAfter = weightAfterDecimal.text!
        
        calc()
    }
    
    // MARK: IBAction
    // 画面表示初期化
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        clearup()
        calc()
    }
    
    // MARK: methods
    // BMI計算
    private func calc() {
        // BMI = 体重kg / (身長m * 身長m)
        if transferHeight() && transferWeight() {
            let res = weight / pow(height * 0.01, 2)
            let roundRes = round(res * 100) / 100
            bmiResultLbl.text = String(format: "%.2f", roundRes)
        }
    }
    
    /// 初期化
    private func clearup() {
        heightBeforDecimal.text = "150"
        heightAfterDecimal.text = "0"
        weightBeforDecimal.text = "50"
        weightAfterDecimal.text = "0"
        bmiResultLbl.text = ""
        
        heightBefore = "150"
        heightAfter = "0"
        weightBefore = "50"
        weightAfter = "0"
    }
    
    @objc func doneButtonAction() {
        if heightBeforDecimal.isFirstResponder {
            heightBefore = heightBeforDecimal.text ?? ""
            heightBeforDecimal.resignFirstResponder()
        }
        if heightAfterDecimal.isFirstResponder {
            heightAfter = heightAfterDecimal.text ?? "0"
            heightAfterDecimal.resignFirstResponder()
        }
        if weightBeforDecimal.isFirstResponder {
            weightBefore = weightBeforDecimal.text ?? ""
            weightBeforDecimal.resignFirstResponder()
        }
        if weightAfterDecimal.isFirstResponder {
            weightAfter = weightAfterDecimal.text ?? "0"
            weightAfterDecimal.resignFirstResponder()
        }
        calc()
    }
    
    private func transferHeight() -> Bool {
        if heightBefore != "" && heightAfter != "" {
            let heightStr = heightBefore + "." + heightAfter
            height = NumberFormatter().number(from: heightStr) as! Double
            return true
        }
        return false
    }
    
    private func transferWeight() -> Bool {
        if weightBefore != "" && weightAfter != "" {
            let weightStr = weightBefore + "." + weightAfter
            weight = NumberFormatter().number(from: weightStr) as! Double
            return true
        }
        return false
    }
}

extension BmiViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.inputView = picker
            if let text = textField.text, !text.isEmpty {
                for element in heightArray.enumerated() {
                    if element.element == Int(text)! {
                        picker.selectRow(element.offset, inComponent: 0, animated: false)
                    }
                }
            } else {
                picker.selectRow(30, inComponent: 0, animated: false)
                textField.text = heightArray[30].description
            }
        case 2:
            textField.inputView = picker
            if let text = textField.text, !text.isEmpty {
                for element in weightArray.enumerated() {
                    if element.element == Int(text)! {
                        picker.selectRow(element.offset, inComponent: 0, animated: false)
                    }
                }
            } else {
                picker.selectRow(20, inComponent: 0, animated: false)
                textField.text = weightArray[20].description
            }
        case 1, 3:
            textField.inputView = decimalPicker
            if let text = textField.text, !text.isEmpty {
                for element in decimalArray.enumerated() {
                    if element.element == Int(text)! {
                        decimalPicker.selectRow(element.offset, inComponent: 0, animated: false)
                    }
                }
            } else {
                decimalPicker.selectRow(0, inComponent: 0, animated: false)
                textField.text = decimalArray[0].description
            }
        default:
            break
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            heightBefore = heightBeforDecimal.text ?? ""
        case 1:
            heightAfter = heightAfterDecimal.text ?? ""
        case 2:
            weightBefore = weightBeforDecimal.text ?? ""
        case 3:
            weightAfter = weightAfterDecimal.text ?? ""
        default:
            break
        }
        return true
    }
}

extension BmiViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === picker {
            if heightBeforDecimal.isFirstResponder {
                return heightArray[row].description
            } else {
                return weightArray[row].description
            }
        } else {
            return decimalArray[row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === picker {
            if heightBeforDecimal.isFirstResponder {
                heightBeforDecimal.text = heightArray[row].description
            }
            if weightBeforDecimal.isFirstResponder {
                weightBeforDecimal.text = weightArray[row].description
            }
        } else {
            if heightAfterDecimal.isFirstResponder {
                heightAfterDecimal.text = decimalArray[row].description
            }
            if weightAfterDecimal.isFirstResponder {
                weightAfterDecimal.text = decimalArray[row].description
            }
        }
    }
}

extension BmiViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === picker {
            return heightArray.count
        } else {
            return decimalArray.count
        }
    }
}
