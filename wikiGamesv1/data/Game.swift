//
//  Game.swift
//  wikiGamesv1
//
//  Created by DAW on 31/01/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import Foundation
struct JuegoResponse:Codable {
    
    struct Juego:Codable{
        var id:Int?
        var titulo:String?
        var empresa:String?
        var caratula:String?
        var tipo:String?
        var fechaLanzamiento:String?
        var descripcion:String?
    }
    
    var games:[Juego]
    
    struct isInserted:Codable{
        var inserted:Int
    }
    
    struct isEdited:Codable {
        var edited:Bool
    }
    
    struct isUploaded:Codable{
        var uploaded:Bool
    }
}


