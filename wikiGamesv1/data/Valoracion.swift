//
//  Valoracion.swift
//  wikiGamesv1
//
//  Created by dam on 10/02/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import Foundation
struct ValoracionResponse:Codable {
    
    struct Valoracion:Codable{
        var id:Int?
        var idusuario:Int?
        var idjuego:Int?
        var valoracion:Int?
    }
    
    var valoraciones:[Valoracion]
    
    struct isInserted:Codable{
        var inserted:Bool
    }
    struct isUpdated:Codable{
        var updated:Bool
    }
}
