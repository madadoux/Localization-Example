//
//  ViewController.swift
//  Localization
//
//  Created by Mohamed saeed on 12/22/20.
//

import UIKit
class AppConfigs {
   static var selectedLanguage = "en" {
        didSet{
            NotificationCenter.default.post(Notification(name: Notification.Name("languageDidChange")))
        }
    }
}

class ViewController: BaseLocalizedViewController {
    var lang = "en"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let btn = UIButton ()
        btn.setTitleColor(.black, for: .normal)
        btn.frame = CGRect(x: 20, y: 120, width: 200, height: 60)
        btn.backgroundColor = .gray
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

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, associativeKey, lift(x: value),  policy)
    }
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        return nil
    }
}


protocol XIBLocalizable {
    var xibLocKey: String? { get set }
    func updateString(key:String?)
}

extension UIButton: XIBLocalizable {
    private struct AssociatedKey {
            static var viewExtension = "lblExtension"
        }

    func updateString(key: String?) {
        let path = Bundle.main.path(forResource: AppConfigs.selectedLanguage , ofType: "lproj")
        let bundle = Bundle(path: path!)
        let localizedText = bundle!.localizedString(forKey: key ?? xibLocKey ?? "", value: "", table: nil)
        setTitle(localizedText, for: .normal)
    }
    
    @IBInspectable var xibLocKey: String? {
        get {
         return   getAssociatedObject(object: self, associativeKey: &AssociatedKey.viewExtension)
        }
        set(key) {
            if let value = key {
                setAssociatedObject(object: self, value: value, associativeKey: &AssociatedKey.viewExtension, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            updateString(key: key)
        }
    }
    
}
extension UILabel: XIBLocalizable {

    
    @IBInspectable var xibLocKey: String? {
        get {
         return   getAssociatedObject(object: self, associativeKey: &AssociatedKey.viewExtension)
        }
        set(key) {
            if let value = key {
                setAssociatedObject(object: self, value: value, associativeKey: &AssociatedKey.viewExtension, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            updateString(key: key)
        }
    }
    
    func updateString(key:String? = nil ){
        
        let path = Bundle.main.path(forResource: AppConfigs.selectedLanguage , ofType: "lproj")
        let bundle = Bundle(path: path!)
        let localizedText = bundle!.localizedString(forKey: key ?? xibLocKey ?? "", value: "", table: nil)
        text = localizedText
    }
    
    
    private struct AssociatedKey {
            static var viewExtension = "viewExtension"
        }

       
}
