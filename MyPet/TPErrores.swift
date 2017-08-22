//
//  TPErrores.swift
//  TPagaTest
//
//  Created by Andres Garcia on 3/12/17.
//  Copyright © 2017 Tactoapps. All rights reserved.
//

import Foundation



enum TPagaError: Error {
    case idClienteNoExiste   // El id de cliente Tpaga no se encontro
    case noAutorizado   // No recibio las credenciales correctamente
    case desconocido    // Fallo pero ni idea que paso
    case noJson        // La data que recibio no la pudo parsear
    case camposErroneos   // Tpaga pudo parsear a json pero los campos no estan completos o no son los que son. O por ejemplo el numero de tarjeta esta muy corto.
   case rechazada(String)
    
    
    

    
}
