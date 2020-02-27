//
//  CommentViewController.swift
//  wikiGamesv1
//
//  Created by DAW on 11/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myCommentTableView: UITableView!
    @IBOutlet weak var btDone: UIButton!
    @IBOutlet weak var tvComment: UITextField!
    var comments:[ComentarioResponse.Comentario]? = Array()
    var newComment:ComentarioResponse.Comentario? = ComentarioResponse.Comentario()
    
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var btV1: UIButton!
    @IBOutlet weak var btV2: UIButton!
    @IBOutlet weak var btV3: UIButton!
    @IBOutlet weak var btV4: UIButton!
    @IBOutlet weak var btV5: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var deleteRate: UIButton!
    @IBOutlet weak var deleteComment: UIButton!
    
    var valoraciones:[ValoracionResponse.Valoracion]=Array()
    var idUsuario:Int?
    var idJuego:Int?
    var idValoracion:Int?
    var updateRate:Bool=false
    var rate:Int?
    
    var buleano = true
    var comentarioId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRating()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(didtapContainerView(_:)))
        self.tableview.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(tap)
        if(rate != nil){
            deleteRate.isHidden = false
        }else{
            deleteRate.isHidden = true
        }
        deleteComment.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteRateAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Delete Rate", message: "Do you want to delete your game rating?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.rate(rate: 0)
                    HttpClient.delete("valoracion/\(self.idValoracion!)") { (data) in
                        print("OK")
                    }
                    self.deleteRate.isHidden = true
                    self.rate = 0
                    }))
                   self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func deleteCommentAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Comment", message: "Do you want to end your comment editing?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
        
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.lbComment.text = "Leave a comment"
            self.tvComment.text = ""
            self.buleano = true
            self.deleteComment.isHidden = true
            }))
           self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didtapContainerView(_ gesture: UITapGestureRecognizer) {
        let touch = gesture.location(in: self.tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            self.lbComment.text = "Edit your comment"
            self.tvComment.text = comments![indexPath.row].comentario
            deleteComment.isHidden = false;
            comentarioId = comments![indexPath.row].id
            print("ID DE MIERDA \(comentarioId!)")
            buleano = false
        }
    }
    
    func getRating(){
        print("id juego: \(idJuego) idUsuario: \(idUsuario)")
        if idUsuario != nil && idJuego != nil {
            print(idUsuario!)
            for valoracion in valoraciones {
                if valoracion.idusuario!==idUsuario! && valoracion.idjuego!==idJuego! {
                    self.rate=valoracion.valoracion!
                    rate(rate: rate!)
                    updateRate=true
                    idValoracion=valoracion.id!
                    print(idValoracion)
                }
            }
        }
    }
    func getRatings2(){
        let _ = HttpClient.get("valoracion") { (data) in
            guard let data=data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ValoracionResponse.self, from: data)
                print(response)
                for valoracion in response.valoraciones{
                    self.valoraciones.append(valoracion)
                }
                self.getRating()
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            
        }
    }
    @IBAction func rating(_ sender: UIButton) {
        var butonRate=sender.tag
        if(rate != nil){
            print(rate!)
        }
        
        if rate == nil || rate != butonRate{
        
        let alert = UIAlertController(title: "Your Rate", message: "Do you want to rate this game with \(butonRate) controller/s?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                    self.deleteRate.isHidden = true
                    
                }))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self.rate = sender.tag
                    self.rate(rate: self.rate!)
                    self.deleteRate.isHidden = false
                    }))
                   self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    func rate(rate:Int)->Void{
        switch rate {
        case 1:
            btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 2:
            btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 3:
            btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 4:
            btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 5:
            btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
        default:
            btV1.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV2.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        }
        if updateRate {
            updateRate(rate: rate)
        }else{
            uploadRate(rate: rate)
            print("si")
            getRatings2()
        }
        
    }
    func uploadRate(rate:Int) {
        let rate: [String: Any] = [
            "id": 0,
            "idJuego": idJuego!,
            "idUsuario": idUsuario!,
            "valoracion": self.rate!,
        ]
        HttpClient.post("valoracion", rate) { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ValoracionResponse.isInserted.self, from: data!)
                //self.performSegue(withIdentifier: "saveSegueGame", sender: nil)
                if response.inserted{
                    print(response.inserted)
                 }else{
                     print("swift es una verga")
                 }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        
    }
    
    func updateRate(rate:Int){
        print("valoracion/\(idValoracion!)")
        let rate: [String: Any] = [
            "idJuego": idJuego!,
            "idUsuario": idUsuario!,
            "valoracion": self.rate!,
        ]
        HttpClient.put("valoracion/\(idValoracion!)", rate) { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ValoracionResponse.isUpdated.self, from: data!)
                //self.performSegue(withIdentifier: "saveSegueGame", sender: nil)
                if response.updated{
                    print(response.updated)
                 }else{
                     print("swift es una verga")
                 }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
    }
    
    
    func getCurrentUserId() -> Int{
        let preferences = UserDefaults.standard
        let name = "userId"
        var userId = 0
        if preferences.object(forKey: name) != nil{
            userId = preferences.integer(forKey: name)
        }
        return userId
    }
    
    func getCurrentGameId() -> Int{
        let preferences = UserDefaults.standard
        let name = "gameId"
        var gameId = 0
        if preferences.object(forKey: name) != nil{
            gameId = preferences.integer(forKey: name)
        }
        return gameId
    }
    
    func writeComment(_ sender: UIButton){
        let com = tvComment.text
        let idUsuario = getCurrentUserId()
        let idJuego = self.idJuego
        let date = Date().fullDate
        
        if !(com!.isEmpty){
            let comment: [String: Any] = [
                        "id": 0,
                        "idUsuario": idUsuario,
                        "idJuego": idJuego,
                        "fecha": date,
                        "comentario": com
                    ]
            print(comment)

            let _ = HttpClient.post("comentario", comment) { (data, response, error) in
                do {
                    print("entra")
                    let decoder = JSONDecoder()
                    var response = try decoder.decode(ComentarioResponse.getComentario.self, from: data!)
                    print(response)
                    if response.comentario.id == nil{
                       DispatchQueue.main.async{
                            let alert = UIAlertController(title: "ERROR", message: "there is already a user with that alias or that mail", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else{
                        self.newComment = response.comentario
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
                        }
                    }
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            }
        }else{
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
        }
    }
    
    func updateComment(_ sender: UIButton){
        
        let com = tvComment.text
        let idUsuario = getCurrentUserId()
        let idJuego = self.idJuego
        let date = Date().fullDate
        
       let comment: [String: Any] = [
                    "id": comentarioId!,
                    "idUsuario": idUsuario,
                    "idJuego": idJuego!,
                    "fecha": date,
                    "comentario": com!
                ]
        print(comment)

        let _ = HttpClient.put("comentario/\(comentarioId!)", comment) { (data, response, error) in
            do {
                print("entra")
                let decoder = JSONDecoder()
                var response = try decoder.decode(ComentarioResponse.isUpdated.self, from: data!)
                print(response)
                if response.updated{
                    print(response.updated)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
                    }
                } else{
                    print("Swift es una verga")
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    func saveData(_ text: ComentarioResponse.Comentario,_ key: String){
        let preferences = UserDefaults.standard
        preferences.set(try? PropertyListEncoder().encode(text), forKey: key)
    }
    
    @IBAction func done(_ sender: UIButton) {
        if (buleano == true){
            writeComment(sender)
        }else if(buleano == false){
            print("ojo")
            updateComment(sender)
            buleano = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            done(btDone)
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCommentCell", for: indexPath) as! MyCommentTableViewCell
    
        cell.lbMyDate.text = comments![indexPath.row].fecha
        cell.lbMyComment.text = comments![indexPath.row].comentario
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("entra1entra")
        if let cell = tableView.cellForRow(at: indexPath) {
            print("entra1entra")
            if cell.isSelected {
              print("entra1entra")

            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let _ = HttpClient.delete("comentario/\(comments![indexPath.row].id!)") { (data) in
                print("HA ENTRADO EN EL BORRADO MAQUINA")
            }
            comments?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

}
