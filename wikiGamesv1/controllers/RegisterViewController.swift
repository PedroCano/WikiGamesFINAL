//
//  RegisterViewController.swift
//  wikiGamesv1
//
//  Created by DAW on 04/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var RegisterBackground: UIImageView!
    @IBOutlet weak var btRegister: UIButton!
    
    @IBOutlet weak var lbMail: UITextField!
    @IBOutlet weak var lbAlias: UITextField!
    @IBOutlet weak var lbPassword: UITextField!
    @IBOutlet weak var lbRepeatPassword: UITextField!
    
    var user:[String:Any] = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegisterBackground.alpha = 0.4
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        lbMail.delegate = self
        lbAlias.delegate = self
        lbPassword.delegate = self
        lbRepeatPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            Register(btRegister)
        }

        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func Register(_ sender: Any) {
        
        let mail:String?
        let alias:String?
        let password:String?
        let repeatPassword:String?
        
        mail = lbMail.text
        alias = lbAlias.text
        password = lbPassword.text
        repeatPassword = lbRepeatPassword.text
        
        if(mail!.isEmpty || alias!.isEmpty || password!.isEmpty || repeatPassword!.isEmpty){
            let alert = UIAlertController(title: "ERROR", message: "Fill in the fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if !isValidEmail(mail!) {
                let alert = UIAlertController(title: "ERROR", message: "Not valid eMail", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let user: [String: Any] = [
                            "id": 0,
                            "alias": lbAlias.text!,
                            "correo": lbMail.text!,
                            "claveAcceso":lbPassword.text!
                        ]
                
                HttpClient.post("usuario", user) { (data, response, error) in
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(UsuarioResponse.isRegistered.self, from: data!)
                        if !response.registered{
                            DispatchQueue.main.async{
                                let alert = UIAlertController(title: "ERROR", message: "there is already a user with that alias or that mail", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }else{
                            DispatchQueue.main.async { if((password?.elementsEqual((repeatPassword)!))!){
                                self.performSegue(withIdentifier: "registerSegue", sender: UIButton.self)
                                                    }else{
                                                        let alert = UIAlertController(title: "ERROR", message: "Passwords doesn't match", preferredStyle: UIAlertController.Style.alert)
                                                        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                    }
                                }
                               } catch let parsingError {
                                   print("Error", parsingError)
                               }
                    }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
