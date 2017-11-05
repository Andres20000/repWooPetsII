//
//  ComandoCalificacion.swift
//  MyPet
//
//  Created by Andres Garcia on 8/20/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase


class ComandoCalificacion {
    
    
    class func  getMisCalificaciones()
    {
        let model = ModeloOferente.sharedInstance
        
        let uid = model.idOferente
        let refHandle:DatabaseReference! = Database.database().reference().child("calificaciones")
        
        let ref = refHandle.queryOrdered(byChild: "/idOferente").queryEqual(toValue: uid)
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            
            let cali = Calificacion()
            let value = snap.value as! [String : AnyObject]
            
            cali.idCalificacion = snap.key
            cali.fecha = value["fecha"] as! String
            cali.idCliente = value["idCliente"] as! String
            cali.idOferente = value["idOferente"] as! String
            cali.calificacion = value["calificacion"] as! Int
            cali.idCompra = value["idCompra"] as! String
            cali.comentario = value["comentario"] as! String
            //cali.timestamp = value["timestamp"] as! CLong
            
            model.misCalificaciones.append(cali)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoCalificacion"), object: nil)
            
        })
        
    }
}
