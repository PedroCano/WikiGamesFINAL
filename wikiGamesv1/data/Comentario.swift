//
//  Comentario.swift
//  wikiGamesv1
//
//  Created by dam on 10/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import Foundation

struct ComentarioResponse:Codable  {
    struct Comentario:Codable{
        var id:Int?
        var idusuario:Int?
        var idjuego:Int?
        var fecha:String?
        var comentario:String?
        
    }
    var comentarios:[Comentario]
    
    struct getComentario:Codable{
        var comentario:Comentario
    }
    
    struct isUpdated:Codable {
        var updated:Bool
    }
}
