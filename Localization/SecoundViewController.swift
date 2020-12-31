//
//  SecoundViewController.swift
//  Localization
//
//  Created by Tariq Maged on 12/30/20.
//

import UIKit
class BaseLocalizedViewController : UIViewController{
    func listenForLanguageChange() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("languageDidChange"), object: nil, queue: nil) { [weak self] (noti) in
            self?.updateViews()
        }
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("languageDidChange"), object: nil)
    }
    
    func updateViews() {
        for view : UIView in self.view.subviews {
            if view is XIBLocalizable {
                (view as! XIBLocalizable).updateString(key: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForLanguageChange()
    }
    
}
class SecoundViewController: BaseLocalizedViewController {

    var lang = "en"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let btn = UIButton ()
        btn.setTitleColor(.black, for: .normal)
        btn.frame = CGRect(x: 20, y: 120, width: 200, height: 60)
        btn.addTarget(self, action: #selector(changeLang), for: .touchUpInside)
        btn.xibLocKey = "changeLang"
        self.view.addSubview(btn)
    }
    
    @objc func changeLang () {
        if lang == "en" {
            lang = "ar"
        }
        else {
            lang = "en"
        }
        
        AppConfigs.selectedLanguage = lang
       
    }

}
