

import UIKit

class SingleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var ivGame: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var comentarios:[ComentarioResponse.Comentario]=Array()
    var valoraciones:[ValoracionResponse.Valoracion]=Array()
    var game :JuegoResponse.Juego?
    var imageGame:UIImage?
    var valoracion=0
    var contRatings:Int?
    
    @IBOutlet weak var btV1: UIButton!
    @IBOutlet weak var btV2: UIButton!
    @IBOutlet weak var btV3: UIButton!
    @IBOutlet weak var btV4: UIButton!
    @IBOutlet weak var btV5: UIButton!
    
    @IBOutlet weak var tvDesc: UITextView!
    
    
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var lbAutor1: UILabel!
    @IBOutlet weak var lbComent1: UILabel!
    @IBOutlet weak var lbAutor2: UILabel!
    @IBOutlet weak var lbComent2: UILabel!
    @IBOutlet weak var lbAutor3: UILabel!
    @IBOutlet weak var lbComent3: UILabel!
    
    @IBOutlet weak var btShowComents: UIButton!
    var userId: Int?
    var gameId: Int?
    var authorLabels:[UILabel]=Array()
    var comentLabels:[UILabel]=Array()
    
    var comments:[ComentarioResponse.Comentario]=Array()
    var currentUserComments:[ComentarioResponse.Comentario]=Array()
    var users:[UsuarioResponse.Usuario]=Array()
    var allUsers:[UsuarioResponse.Usuario]=Array()
    var newComment: ComentarioResponse.Comentario?
    let modalVC = CommentViewController()
    var userComments:[UsuarioResponse.Usuario:ComentarioResponse.Comentario] = [:]
    var filteredGames:[JuegoResponse.Juego] = [JuegoResponse.Juego]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRatings()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.modalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
        if filteredGames.isEmpty{
            
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("si2")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "si"), object: nil)
    }
    @objc func modalDismissed() {
        print("Nos esta entrando aqui")
        self.userComments = [:]
        self.currentUserComments = []
        self.users = Array()
        self.allUsers = Array()
        for label in authorLabels {
            label.text = ""
        }
        for label in comentLabels {
            label.text = ""
        }
        getRatings()
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
    func getRatings(){
        self.valoraciones=Array()
        gameId = game?.id! as! NSNumber as! Int
        
        let _ = HttpClient.get("valoracion") { (data) in
            guard let data=data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ValoracionResponse.self, from: data)
                for valoracion in response.valoraciones{
                    self.valoraciones.append(valoracion)
                }
                self.valoracion = 0
                self.contRatings = 0
                var valoracionJuego=0
                var contRatings=0
                for valoracion in self.valoraciones {
                    if valoracion.idjuego!==self.gameId!{
                        valoracionJuego+=valoracion.valoracion!
                        contRatings+=1
                    }
                }
                self.contRatings=contRatings
                if valoracionJuego>0 && contRatings>0 {
                    self.valoracion=valoracionJuego/contRatings
                    //Aqui carga los juegos con valoracion
                          
                }
                self.initComp()
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
        }
    }
    func initComp(){
        authorLabels.append(lbAutor1)
        authorLabels.append(lbAutor2)
        authorLabels.append(lbAutor3)
        
        comentLabels.append(lbComent1)
        comentLabels.append(lbComent2)
        comentLabels.append(lbComent3)
        if let juego = game{
            DispatchQueue.main.async {
                print("no aaaaaaadssadsdssa")
                self.lbTitle.text =  self.game!.titulo
                 self.tvDesc.text =  self.game?.descripcion;
                 self.ivGame.image = self.imageGame!
                 self.labelRating.text="("+String( self.contRatings!)+")"
                self.putRatings()
            }
           
           initProcessResponse(Int(truncating: game?.id! as! NSNumber))
        }
    }
    
    func readData(_ key: String) -> ComentarioResponse.Comentario{
        let preferences = UserDefaults.standard
        let commentData = preferences.object(forKey: key) as? Data
        var comment: ComentarioResponse.Comentario = ComentarioResponse.Comentario()
        if(commentData != nil){
            comment = try! PropertyListDecoder().decode(ComentarioResponse.Comentario.self, from: commentData!)
        }
        return comment
    }
    
    func putRatings(){
        switch valoracion {
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
    }
    
    @IBAction func editGame(_ sender: Any) {
           self.performSegue(withIdentifier: "editGameSegue", sender: UIButton.self)
    }
    
    @IBAction func showMyComments(_ sender: UIButton) {
            self.performSegue(withIdentifier: "rateSegue", sender: UIButton.self)
    }
    
    @IBAction func showComments(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showCommentsSegue", sender: UIButton.self)
    }
    
    func initProcessResponse(_ id: Int){
        //array como respuesta
       var ok=HttpClient.get("comentario") { (data) in
            guard let data=data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                var response = try decoder.decode(ComentarioResponse.self, from: data)
                var cont = 0
                response.comentarios.sort(by: { $0.id! > $1.id!})
                if !response.comentarios.isEmpty{
                    self.initUserProcessResponse(response.comentarios, id)
                }
           } catch let parsingError {
               print("Error", parsingError)
           }
        }
    }
    
    func getAlias(_ currentComment: ComentarioResponse.Comentario,_ responseComments:[ComentarioResponse.Comentario],_ responseUsers: [UsuarioResponse.Usuario] ) ->String{
        var alias: String = ""
        for user in responseUsers{
            for comment in responseComments{
                if self.gameId == comment.idjuego && currentComment.idusuario == user.id{
                    print("entra" + String(user.alias))
                    alias = user.alias
                    self.userComments[user] = currentComment
                    break
                }
            }
        }
        return alias
    }
    
func initUserProcessResponse(_ responseComments: [ComentarioResponse.Comentario], _ currentGameId: Int ){

        let _ = HttpClient.get("usuario/get/all") { (data) in
            guard let data=data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UsuarioResponse.getUsers.self, from: data)
                self.allUsers = response.usuarios
                if !response.usuarios.isEmpty{
                    self.doTheJob(responseComments, currentGameId, response.usuarios)
                }
                
           } catch let parsingError {
                print("Error", parsingError)
           }
        }
    }

    func doTheJob(_ responseComments: [ComentarioResponse.Comentario], _ currentGameId: Int, _ responseUsers: [UsuarioResponse.Usuario]){
        var cont = 0
        for comentario in responseComments{
            if comentario.idusuario == self.getCurrentUserId() && comentario.idjuego == currentGameId{
                self.currentUserComments.append(comentario)
            }
            if comentario.idjuego == currentGameId {
                self.comments.append(comentario)
                if cont < 3 {
                    print("adsadsads\(comentario.comentario)")
                    switch cont {
                        case 0:
                            self.writeLb(self.lbComent1, comentario.comentario!)
                            self.writeLb(self.lbAutor1, self.getAlias(comentario, responseComments,responseUsers))
                        case 1:
                            self.writeLb(self.lbComent2, comentario.comentario!)
                            self.writeLb(self.lbAutor2, self.getAlias(comentario, responseComments,responseUsers))
                        case 2:
                            self.writeLb(self.lbComent3, comentario.comentario!)
                            self.writeLb(self.lbAutor3, self.getAlias(comentario,responseComments,responseUsers))
                        default:
                            print("default")
                    }
                cont += 1
                } else{
                    let _ = self.getAlias(comentario,responseComments,responseUsers)
                }
            }
        }
    }
    
    func getUsername(_ userId: Int){
        
    }
    func writeLb(_ label: UILabel, _ text : String){
        DispatchQueue.main.async {
            label.text = text
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
               switch (segue.identifier) {
               case "showCommentsSegue":
                   guard let commentsTableViewController = segue.destination as? CommentsTableViewController else{
                       fatalError("Unexpected destination: \(segue.destination)")
                   }
                   commentsTableViewController.userComments = self.userComments
                
                case "rateSegue":
                   guard let commentViewController = segue.destination as? CommentViewController else{
                       fatalError("Unexpected destination: \(segue.destination)")
                   }
                   commentViewController.comments = self.currentUserComments
                    commentViewController.valoraciones=self.valoraciones
                                       commentViewController.idJuego=self.game?.id
                                       commentViewController.idUsuario =  UserDefaults.standard.integer(forKey: "userId")
                case "editGameSegue":
                guard let editGameController = segue.destination as? AddViewController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                editGameController.juego = self.game
               default:
                   print("Default")
               }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.ivGame.image = UIImage(data: data)
            }
        }
    }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
}
   /* @IBAction func cancel(_ sender: Any) {
        /*let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The GameViewController is not inside a navigation controller.")
        }
 */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */*/
