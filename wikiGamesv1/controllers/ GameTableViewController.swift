//
//  GamesTableViewController.swift
//  wikiGamesv1
//
//  Created by DAW on 31/01/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import UIKit

class GamesTableViewController: UITableViewController,UISearchResultsUpdating, UISearchControllerDelegate {
    
    var juegos:[JuegoResponse.Juego]=Array()
    var valoraciones:[ValoracionResponse.Valoracion]=Array()
    let searchController = UISearchController(searchResultsController: nil)
    var rgb: Bool = true
    var filteredGames = [JuegoResponse.Juego]()
    var filteredGames2 = [JuegoResponse.Juego]()
    var auxFilteredGames = [JuegoResponse.Juego]()
    var game = JuegoResponse.Juego()
    
    override func viewDidLoad() {
        print("aroquesibro view")
        super.viewDidLoad()
        initProcessResponse()
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.si),
        name: NSNotification.Name(rawValue: "si"),
        object: nil)
        searchController.searchResultsUpdater = self
               searchController.dimsBackgroundDuringPresentation = false
               definesPresentationContext = true
               tableView.tableHeaderView = searchController.searchBar
               navigationItem.hidesSearchBarWhenScrolling = true
                //DESCOMENTAR PARA MODE
               /* var colors:[UIColor] = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.purple]
               var cont = 0
               
               DispatchQueue.global(qos: .default).async {
                   while self.rgb{
                       if cont < colors.count{
                           DispatchQueue.main.async {
                               self.searchController.searchBar.barTintColor = colors[cont]
                           }
                           cont += 1
                       }
                       if cont >= colors.count{
                       cont = 0
                       }
                       usleep(100000)
                   }
               }*/
        //searchController.searchBar.showsCancelButton = false
        searchController.searchBar.tintColor = UIColor.black
    }
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("sasdasddasdsa end")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("sasdasddasdsa begin")
    }

    @objc func si() {
        print("aroquesibro table")
        print("aroquesibro \(filteredGames2)")
          juegos = Array()
          valoraciones = Array()
        auxFilteredGames = filteredGames2
          initProcessResponse()
       }
    
    private func filterGames(for searchText: String) {
      filteredGames = juegos.filter { game in
        return game.titulo!.lowercased().contains(searchText.lowercased()) || game.empresa!.lowercased().contains(searchText.lowercased())
      }
        filteredGames2 = filteredGames
        if filteredGames.isEmpty && searchController.searchBar.showsCancelButton {
            tableView.isScrollEnabled = true
        }else{
            tableView.isScrollEnabled = false
        }
      tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {

        if #available(iOS 11.0, *) {
               navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
            if #available(iOS 11.0, *) {
                  navigationItem.hidesSearchBarWhenScrolling = true
          }
    }

    
    @IBAction func DoLogout(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "LogoutSegue", sender: nil)
    }
    
    
    func initProcessResponse(){
        //array como respuesta
       var ok=HttpClient.get("juego") { (data) in
            print("respuesta recibida")
            guard let data=data else{
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(JuegoResponse.self, from: data)
                print(response)
                print("antesdecomprobarsiestavacio \(self.auxFilteredGames)")

                    for juego in response.games{
                        print(juego.titulo)
                        self.juegos.append(juego)
                    }
                if !self.auxFilteredGames.isEmpty{
                    self.filteredGames = self.auxFilteredGames
                }
                self.reloadTable()
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            self.getRatings()
        }
        if ok{
            print("llamada hecha")
        }else{
            print("error en la llamada")
        }
    }
    // MARK: - Table view data source
    func reloadTable()  {
        print("Si \(juegos)")
        DispatchQueue.main.async{
                    self.tableView.reloadData()
        }
    }
    func getRatings(){
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
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            self.reloadTable()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if searchController.isActive && searchController.searchBar.text != "" {
                 return filteredGames.count
               }
               return juegos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            print("entra aqui")
          game = filteredGames[indexPath.row]
        } else {
          game = juegos[indexPath.row]
        }
        let idJuego=game.id!
        var valoracionJuego=0
        var contRatings=0
        for valoracion in valoraciones {
            if valoracion.idjuego==idJuego{
                valoracionJuego+=valoracion.valoracion!
                contRatings+=1
            }
        }
        if valoracionJuego>0 && contRatings>0 {
            valoracionJuego=valoracionJuego/contRatings
        }
        switch valoracionJuego {
        case 1:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 2:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 3:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 4:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV4.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        case 5:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
           cell.btV4.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
        default:
            cell.btV1.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV2.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV3.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV4.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
            cell.btV5.setImage(UIImage(systemName: "gamecontroller"), for: .normal)
        }
        
        cell.labelCell.text=game.titulo
        cell.labelAutor.text=game.empresa
        
        
        HttpClient.get("uploads/\(game.id!)") { (data) in
            DispatchQueue.main.async {
                cell.imageCell!.image = UIImage(data: data!)
            }
        }
        //let url = URL(string: "https://informatica.ieszaidinvergeles.org:9047/app/public/uploads/\(game.id!)")
        //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        //cell.imageCell!.image = UIImage(data: data!)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
      //filteredGames(for: searchController.searchBar.text ?? "")
        filterGames(for: searchController.searchBar.text!)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier) {
        case "AddSegue":
            print("Adding new game")
        case "ShowSegue":
            guard let gameDetailViewController = segue.destination as? SingleViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGameCell = sender as? GameTableViewCell else{
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGameCell) else{
                fatalError("The selected cell is not being displayed by the table")
            }
           
                        //navigationController?.popViewController(animated: false)
            if searchController.isActive && searchController.searchBar.text != "" {
                print("entra aqui")
              game = filteredGames[indexPath.row]
            } else {
              game = juegos[indexPath.row]
            }
            var valoracionJuego=0
            var contRatings=0
            for valoracion in valoraciones {
                if valoracion.idjuego==game.id{
                    valoracionJuego+=valoracion.valoracion!
                    contRatings+=1
                }
            }
            if valoracionJuego>0 && contRatings>0 {
                valoracionJuego=valoracionJuego/contRatings
            }
            let url = URL(string: "https://informatica.ieszaidinvergeles.org:9047/app/public/api/uploads/\(game.id!)")
            print("//////////////////////\(game.id!)")
            let data = try? Data(contentsOf: url!)
            
            gameDetailViewController.imageGame = UIImage(data: data!)
            gameDetailViewController.game = game
            /*
            gameDetailViewController.valoracion=valoracionJuego
            gameDetailViewController.ratingCont=contRatings
            gameDetailViewController.valoraciones=self.valoraciones
            */
            
        default:
            print("Default")
        }
    }

}
