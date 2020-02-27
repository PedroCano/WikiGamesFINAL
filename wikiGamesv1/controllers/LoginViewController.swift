//
//  LoginViewController.swift
//  wikiGamesv1
//
//  Created by DAW on 04/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LoginBackground: UIImageView!
    @IBOutlet weak var LoginUsername: UITextField!
    @IBOutlet weak var LoginPassword: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    var userId:Int?
    var username:String?
    var password:String?
           
    var usuarios:[UsuarioResponse.Usuario] = Array()
    
    var preferences = UserDefaults.standard
    var value = 2
    var name = "user_id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginBackground.alpha = 0.4
        LoginUsername.delegate = self
        LoginPassword.delegate = self
        var userName = getCurrentUserAlias()
        if !(getCurrentUserAlias().elementsEqual("")){
            LoginUsername.text=userName
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func getCurrentUserAlias() -> String{
        let preferences = UserDefaults.standard
        let name = "userName"
        var userAlias = ""
        if preferences.object(forKey: name) != nil{
            userAlias = preferences.string(forKey: name)!
        }
        return userAlias
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            Login(LoginButton)
        }

        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        
       
        username = LoginUsername.text
        password = LoginPassword.text
        
        if(username!.isEmpty || password!.isEmpty){
            let alert = UIAlertController(title: "ERROR", message: "Fill in the fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            HttpClient.post("usuario/check", [
                "alias": username!,
                "claveAcceso": password!
            ]) { (data, response, error) in
                do {
                let decoder = JSONDecoder()
                    let response = try decoder.decode(UsuarioResponse.checkUsuario.self, from: data!)
                    if !(response.verify>0) {
                        DispatchQueue.main.async{
                            let alert = UIAlertController(title: "ERROR", message: "Data error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self.userId=response.verify
                        self.saveData()
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "loginSegue", sender: UIButton.self)
                        }
                    }
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            }
        }
    }
    
    @IBAction func Register(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowRegisterSegue", sender: nil)
    }
    
    @IBAction func bgOutside(_ sender: UITapGestureRecognizer){
        LoginUsername.resignFirstResponder()
        LoginPassword.resignFirstResponder()
    }
    func saveData(){
        let preferences = UserDefaults.standard
        var value = self.userId
        var name = "userId"
        preferences.set(value, forKey: name)
        let value2 = self.username
        let name2 = "userName"
        preferences.set(value2, forKey: name2)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
