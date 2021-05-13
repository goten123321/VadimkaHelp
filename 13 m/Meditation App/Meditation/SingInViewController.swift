//
//  ViewController.swift
//  Meditation App
//
//  Created by user on 01.04.2021.
//

import UIKit
import Alamofire
import SwiftyJSON


class SingInViewController: UIViewController {

    @IBOutlet weak var inputLogin: UITextField!



    @IBOutlet weak var inputPassword: UITextField!

    let userDef = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputLogin.text = "1"
        inputPassword.text = "1"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        
    }
        
    func isValidEmail(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]@+^$&*#^$(@^#}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
        
    }
    
    @IBAction func signInAction( sender: UIButton){
        
        guard inputPassword.text?.isEmpty == false && inputPassword.text?.isEmpty == false else { return showAlert(message: "поля пустые") }
        guard isValidEmail(emailID: inputLogin.text!) else { return showAlert(message: "Проверте правильность почты")}
        
            
        
        let url = "http://mskko2021.mad.hakta.pro/api/user/login"
        
        let param: [String: String] = [
            "email": inputLogin.text!,
            "password": inputPassword.text!
        ]
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let token = json["token"].stringValue
                self.userDef.setValue(token, forKey: "userToken")
            case .failure(let error):
                let errorJSON = JSON (response.data)
                let errorDesciption = errorJSON["error"].stringValue
                self.showAlert(message: errorDesciption)
                
            }
        }
        

    
    }


}
//58



