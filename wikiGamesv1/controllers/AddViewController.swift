//
//  AddViewController.swift
//  wikiGamesv1
//
//  Created by DAW on 03/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit
import iOSDropDown

extension AddViewController: UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.titles.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tfTipo.text = self.titles[row]
    }
}

extension AddViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.tfTipo.text = self.titles[row]
        self.tfTipo.resignFirstResponder()
    }

    func didTapCancel() {
        self.tfTipo.text = nil
        self.tfTipo.resignFirstResponder()
    }
}

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    var uploadGame=false
    var juego:JuegoResponse.Juego?
    var game2 = JuegoResponse.Juego()
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let titles = ["RPG", "Rol", "Survival", "Race", "Horror", "Survival/Horror", "Simulator", "Cooking", "FPS", "Shooter", "Adventure"]
    
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfCompañia: UITextField!
    @IBOutlet weak var tfTipo: UITextField!
    @IBOutlet weak var tfFechaLanzamiento: UITextField!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var btAddGame: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
        
        tfTitulo.delegate = self
        tfCompañia.delegate = self
        tfFechaLanzamiento.delegate = self
        tvDesc.delegate = self
        tvDesc.layer.borderWidth = 1
        tvDesc.layer.borderColor = UIColor.lightGray.cgColor
        tvDesc.layer.cornerRadius = 5
        tvDesc.text = "Description"
        tvDesc.textColor = UIColor.lightGray
        
        self.tfTipo.inputView = self.pickerView
        self.tfTipo.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        
        checkGame()
        
        /*
        // The list of array to display. Can be changed dynamically
        tfTipo.optionArray = ["Option 1", "Option 2", "Option 3"]
        
        // The the Closure returns Selected Index and String
        tfTipo.didSelect{(selectedText , index ,id) in
            self.tfCompañia.text = "Selected String: \(selectedText) \n index: \(index)"
        }
 
         */
        
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func checkGame(){
        guard let game = juego
            else{
                return
        }
        
        let url = URL(string: "https://informatica.ieszaidinvergeles.org:9047/app/public/api/uploads/\(game.id!)")
        let data = try? Data(contentsOf: url!)
        
        gameImage.image = UIImage(data: data!)
        tfTitulo.text = game.titulo
        tfCompañia.text = game.empresa
        tfTipo.text = game.tipo
        tfFechaLanzamiento.text = game.fechaLanzamiento
        tvDesc.textColor = UIColor.black
        tvDesc.text = game.descripcion
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            saveGame(btAddGame)
        }

        return true
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
     func showDatePicker(){
       datePicker.datePickerMode = .date
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
       tfFechaLanzamiento.inputAccessoryView = toolbar
       tfFechaLanzamiento.inputView = datePicker

    }

     @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy"
      tfFechaLanzamiento.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
         //nameTextField.resignFirstResponder()
         // UIImagePickerController is a view controller that lets a user pick media from their photo library.
         let imagePickerController = UIImagePickerController()
         
         // Only allow photos to be picked, not taken.
         imagePickerController.sourceType = .photoLibrary
         //
         imagePickerController.allowsEditing = true
         // por defecto
         // Make sure ViewController is notified when the user picks an image.
        
         imagePickerController.delegate = self
        /* imagePickerController.modalPresentationStyle = .fullScreen
         imagePickerController.modalTransitionStyle = .crossDissolve*/
         present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    // MARK: ImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        gameImage.image = selectedImage
        /*
        let data = selectedImage.jpegData(compressionQuality: 0.1)
        let _ = HttpClient.upload(route: "uploads", fileParameter: "file", fileData: data!) { (data) in
            print(data!)
        }
        */
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGame(_ sender: Any) {
        var titulo=tfTitulo.text
        var comp=tfCompañia.text
        var tipo=tfTipo.text
        var fechaLanz=tfFechaLanzamiento.text
        var desc=tvDesc.text
        
        if titulo!.isEmpty||comp!.isEmpty||tipo!.isEmpty||fechaLanz!.isEmpty||desc!.isEmpty{
            let alert = UIAlertController(title: "ERROR", message: "Fill in the fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
                var game: [String: Any] = [
                            "id": 0,
                            "titulo": titulo,
                            "empresa": comp,
                            "caratula": "0",
                            "tipo": tipo,
                            "fechaLanzamiento": fechaLanz,
                            "descripcion": desc
                        ]
                
                HttpClient.post("juego", game) { (data, response, error) in
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(JuegoResponse.isInserted.self, from: data!)
                        //self.performSegue(withIdentifier: "saveSegueGame", sender: nil)
                        if response.inserted > 0{
                             self.doTheJob(response.inserted)
                         }else{
                             print("ERROR CRÍTICO")
                         }
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                
        }
        
        juego?.titulo=tfTitulo.text
    }
    
    
    @IBAction func editGame(_ sender: UIBarButtonItem) {
        var id = juego!.id
        var titulo=tfTitulo.text
        var comp=tfCompañia.text
        var caratula = juego!.id!
        var tipo=tfTipo.text
        var fechaLanz=tfFechaLanzamiento.text
        var desc=tvDesc.text
        
        if titulo!.isEmpty||comp!.isEmpty||tipo!.isEmpty||fechaLanz!.isEmpty||desc!.isEmpty{
            let alert = UIAlertController(title: "ERROR", message: "Fill in the fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
                let game: [String: Any] = [
                    "titulo": titulo as Any,
                            "empresa": comp as Any,
                            "caratula": caratula as Any,
                            "tipo": tipo as Any,
                            "fechaLanzamiento": fechaLanz as Any,
                            "descripcion": desc as Any
                        ]
                
                HttpClient.put("juego/\(id!)", game) { (data, response, error) in
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(JuegoResponse.isEdited.self, from: data!)
                        //self.performSegue(withIdentifier: "saveSegueGame", sender: nil)
                        if response.edited{
                            
                            self.game2.titulo = (game["titulo"] as! String)
                            self.game2.empresa = (game["empresa"] as! String)
                            self.game2.caratula = "0"
                            self.game2.tipo = (game["tipo"] as! String)
                            self.game2.fechaLanzamiento = (game["fechaLanzamiento"] as! String)
                            self.game2.descripcion = (game["descripcion"] as! String)
                            print("TITULO A PASAR"+"\(self.game2.titulo!)")
                             self.doTheJob3()
                         }else{
                             print("swift es una verga"+"\(id!)")
                         }
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
        }
        
        juego?.titulo=tfTitulo.text
    }
    
    func doTheJob(_ id:Int){
        DispatchQueue.main.async{
            let data = self.gameImage.image!.jpegData(compressionQuality: 0.1)
            HttpClient.uploadId(route: "uploads", fileParameter: "file", fileData: data!, fileName: String(id)) { (data) in
                self.doTheJob2(data: data!)
            }
        }
    }
    
    func doTheJob2(data: Data){
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(JuegoResponse.isUploaded.self, from: data)
            if response.uploaded{
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "saveSegueGame", sender: nil)
                }
            }else{
                print("swift es una verga")
            }
        } catch let parsingError {
          print("Error", parsingError)
      }
    }
    
    
    func doTheJob3(){
        DispatchQueue.main.async{
            let data = self.gameImage.image!.jpegData(compressionQuality: 0.1)
            print("uploads/\(self.juego!.id!)")
            HttpClient.uploadId(route: "uploads", fileParameter: "file", fileData: data!, fileName: String(self.juego!.id!)) { (data) in
                self.doTheJob4(data: data!)
            }
        }
    }
    
    func doTheJob4(data: Data){
        do{
            let decoder = JSONDecoder()
            let response = try decoder.decode(JuegoResponse.isUploaded.self, from: data)
            if response.uploaded{
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "backEditGameSegue", sender: nil)
                }
            }else{
                print("swift es una verga")
            }
        } catch let parsingError {
          print("Error", parsingError)
      }
        
    }
    
}
