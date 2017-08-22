//
//  Compra.swift
//  MyPet
//
//  Created by Andres Garcia on 8/16/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation


class ItemCompra {
    
    var cantidad = 0
    var estado = "Indeterminado"
    var servicio = false
    var fechaServicio:String?
    //var horaServicio:String?
   // var duracion:Int?
    var idPublicacion = ""
    //var nombre = ""
    //var target = ""
    //var valor = 0
    var compra:Compra? = nil
    var consecutivo:Int = -1
    

}


class Compra {
    
    
    var idCompra:String = ""
    var fecha = ""
    var idCliente = ""
    var idOferente = ""
    var valor = 0
    
    var items:[ItemCompra] = []
    var timestamp:CLong = 0
    
    
    
    
}


