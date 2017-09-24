//
//  BaseViewController.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2017/09/16.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: mamber variables
    // 現在の言語設定
    var language: String {
        return UserDefaults.standard.string(forKey: "language")!
    }
    
    var defaultDateString: String {
        return self.getToday()
    }
    
    var defaultDate: Date!
    
    let cal = Calendar(identifier: .gregorian)
    
    // MARK: public function
    func makeDoneButtonToPicker() -> UIToolbar {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: Selector(("doneButtonAction")))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        return doneToolbar
    }
    
    func makeDoneMinusButtonToPicker() -> UIToolbar {
        let doneToolbar = self.makeDoneButtonToPicker()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let minus = UIBarButtonItem(title: "ー", style: .plain, target: self, action: Selector(("toggleMinus")))
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: Selector(("doneButtonAction")))
        
        let items = NSMutableArray()
        items.add(minus)
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        return doneToolbar
    }
    
    // 本日の年月日を取得
    func getToday() -> String {
        self.defaultDate = cal.startOfDay(for: Date())
        let components = cal.dateComponents([.year, .month, .day], from: self.defaultDate)
        return ("\(components.year!) / \(components.month!) / \(components.day!)")
    }
    
    // picker date formatter
    func formatteDateForPicker(date: Date) -> String {
        let components = cal.dateComponents([.year, .month, .day], from: date)
        return ("\(components.year!) / \(components.month!) / \(components.day!)")
    }
    
    // 分娩予定日計算
    func calcEddFromLmp(fromDate: Date) -> String {
        let result = cal.date(byAdding: .day, value: 280, to: fromDate)
        guard let resDate = result else {
            return ""
        }
        let components = cal.dateComponents([.year, .month, .day], from: resDate)
        return ("\(components.year!) / \(components.month!) / \(components.day!)")
    }
    
    // 最終月経開始日から基準日までの妊娠週数・日数計算
    func calcGetationalAge(fromDate: Date, toDate: Date) -> (String, String, String) {
        // 計算に使用される日付の時刻を0時0分0秒に指定
        let startFromDate = cal.startOfDay(for: fromDate)
        let startToDate = cal.startOfDay(for: toDate)
        
        let calResultComponent = cal.dateComponents([.day], from: startFromDate, to: startToDate)
        let day = calResultComponent.day!
        let week = day / 7
        let remainder = day % 7
        print("**** 週: \(week)")
        print("**** 日目: \(day)")
        print("**** 日: \(remainder)")
        
        return (week.description, remainder.description, (day + 1).description)
    }
    
    // 分娩予定から基準日までの妊娠週数・日数を逆算
    // - parameter -
    // -- fromDate: 分娩予定日
    // -- toDate:   基準日
    func calcGetationalAgeFromEdd(fromDate: Date, toDate: Date) -> (String, String, String) {
        // 計算に使用される日付の時刻を0時0分0秒に指定
        let startFromDate = cal.startOfDay(for: fromDate)
        let startToDate = cal.startOfDay(for: toDate)
        
        // 分娩予定日から280日を減算
        let result = cal.date(byAdding: .day, value: -280, to: startFromDate)
        guard let resDate = result else {
            return ("*", "*", "*")
        }
        // 減算結果から基準日までの経過日数を取得
        let calResultComponent = cal.dateComponents([.day], from: cal.startOfDay(for: resDate), to: startToDate)
        let day = calResultComponent.day!
        let week = day / 7
        let remainder = day % 7
        print("**** 週: \(week)")
        print("**** 日目: \(day)")
        print("**** 日: \(remainder)")
        
        return (week.description, remainder.description, (day + 1).description)
    }
}
