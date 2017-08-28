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
    
    
    class func  getMisCalificaciones(){
        
        
        let model = ModeloOferente.sharedInstance
        
        let uid = model.idOferente
        let refHandle:FIRDatabaseReference! = FIRDatabase.database().reference().child("calificaciones")
        
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
    
    // Agregado para Usuario
    
    class func  getCalificacionesPublicaciones()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        let refHandle:FIRDatabaseReference! = FIRDatabase.database().reference().child("calificaciones")
        
        refHandle.observe(.childAdded, with: {(snap) -> Void in
            
            let calificacion = Calificacion()
            let value = snap.value as! [String : AnyObject]
            
            calificacion.calificacion = value["calificacion"] as! Int
            calificacion.comentario = value["comentario"] as! String
            calificacion.fecha = value["fecha"] as! String
            calificacion.idCalificacion = snap.key
            calificacion.idCliente = value["idCliente"] as! String
            calificacion.idCompra = value["idCompra"] as! String
            calificacion.idOferente = value["idOferente"] as! String
            calificacion.idPublicacion = value["idPublicacion"] as! String
            
            modelUsuario.calificacionesPublicaciones.append(calificacion)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoCalificacionesPublicaciones"), object: nil)
            
        })
    }
    
    class func calificarCompra(calificacionCompra:Calificacion)
    {
        let refHandle  = FIRDatabase.database().reference().child("calificaciones").childByAutoId()
        
        refHandle.child("/calificacion").setValue(calificacionCompra.calificacion)
        refHandle.child("/comentario").setValue(calificacionCompra.comentario)
        refHandle.child("/fecha").setValue(calificacionCompra.fecha)
        refHandle.child("/idCliente").setValue(calificacionCompra.idCliente)
        refHandle.child("/idCompra").setValue(calificacionCompra.idCompra)
        refHandle.child("/idOferente").setValue(calificacionCompra.idOferente)
        refHandle.child("/idPublicacion").setValue(calificacionCompra.idPublicacion)
    }
}
