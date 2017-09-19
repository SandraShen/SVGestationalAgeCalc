//
//  ViewController.swift
//  GestationalAgeCalculator
//
//  Created by Sandra Voice on 2017/09/09.
//  Copyright © 2017年 OritoClinic. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var languageSwicher: UISegmentedControl! // 言語選択セグメント
    
    @IBOutlet weak var lmpBtn: UIButton!    // 最終月経開始日から計算
    @IBOutlet weak var eddBtn: UIButton!    // 分娩予定日から計算
    @IBOutlet weak var lmpLbl: UILabel!
    @IBOutlet weak var eddLbl: UILabel!
    
    // MARK: member variables
    private var selectedLanguage: String {
        get {
            guard let language = UserDefaults.standard.string(forKey: "language") else {
                return "jpn"
            }
            return language
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "language")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDisplay()
    }

    // MARK: IBAction
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // 選択されたセグメントによって表示言語を切り替える
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedLanguage = "jpn"
        case 1:
            self.selectedLanguage = "eng"
        case 2:
            self.selectedLanguage = "fre"
        default:
            break
        }
        self.setupDisplay()
    }
    
    // MARK: methods
    private func setupDisplay() {
        var navigationTitle = ""
        var lmpBtnTitle = ""
        var eddBtnTitle = ""
        var backBtnTile = ""
        switch self.selectedLanguage {
        case "jpn":
            self.languageSwicher.selectedSegmentIndex = 0
            navigationTitle = "妊娠週数計算機"
            lmpBtnTitle = "最終月経開始日から計算"
            eddBtnTitle = "分娩予定日から計算"
            backBtnTile = "戻る"
        case "eng":
            self.languageSwicher.selectedSegmentIndex = 1
            navigationTitle = "Pregnancy Wheel"
            lmpBtnTitle = "Calculate from the LMP"
            eddBtnTitle = "Calculate from the EDD"
            backBtnTile = "Back"
        case "fre":
            self.languageSwicher.selectedSegmentIndex = 2
            navigationTitle = "Roulette obstétricale"
            lmpBtnTitle = "Calculer par vos dernières règles"
            eddBtnTitle = "Calculer par la date présumée de votre accouchement"
            backBtnTile = "Retour"
        default:
            return
        }
        self.navigationItem.title = navigationTitle
        let myBackButton = UIBarButtonItem(title: backBtnTile, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = myBackButton
//        self.lmpBtn.setTitle(lmpBtnTitle, for: .normal)
//        self.eddBtn.setTitle(eddBtnTitle, for: .normal)
        self.lmpLbl.text = lmpBtnTitle
        self.eddLbl.text = eddBtnTitle
    }
}

