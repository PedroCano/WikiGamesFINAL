//
//  Usuario.swift
//  wikiGamesv1
//
//  Created by DAW on 31/01/2020.
//  Copyright © 2020 DAM. All rights reserved.
//

import Foundation
struct UsuarioResponse:Codable {
    struct Usuario:Codable, Hashable{
        static func == (lhs: UsuarioResponse.Usuario, rhs: UsuarioResponse.Usuario) -> Bool {
            return lhs.id == rhs.id && lhs.alias == rhs.alias && lhs.claveAcceso == rhs.correo
        }
        
        var id:Int
        var alias:String
        var correo:String
        var claveAcceso:String
        
        
    }
    var usuarios:[Usuario]
    //var user:Array<Usuario>
    struct checkUsuario:Codable {
        var verify:Int
    }
    
    struct isRegistered:Codable{
        var registered:Bool
    }
    
    struct getUsers:Codable{
        var usuarios: [Usuario]
    }
    
    
}
