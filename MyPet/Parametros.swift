//
//  Parametros.swift
//  MyPet
//
//  Created by Andres Garcia on 8/23/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase


class Parametros {
    

    var valorDestacado = 0
    
}


class ComandoParametros {
    
    
    class func getParametros(){
        
        let model  = ModeloOferente.sharedInstance
        
        let ref  = FIRDatabase.database().reference().child("params/" )
        
            ref.observeSingleEvent(of: .value, with: {snap in
                
            let value = snap.value as! NSDictionary
                
            model.params.valorDestacado = value["valorDestacado"] as! Int
                
            
        })
        
    }
    
    
    
    
    
}
