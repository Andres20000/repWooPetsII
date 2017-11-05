//
//  ComandoCompras.swift
//  MyPet
//
//  Created by Andres Garcia on 8/16/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//


import Foundation
import Firebase

class ComandoCompras
{
    class func  getMisCompras(abiertas:Bool)
    {
        let model = ModeloOferente.sharedInstance
        
        let uid = model.idOferente
        var refHandle:DatabaseReference! = nil
        
        if abiertas
        {
            refHandle = Database.database().reference().child("compras/abiertas")
        } else
        {
            if model.yaEstaLlamandoCerradas
            {
                return
            }
            refHandle = Database.database().reference().child("compras/cerradas")
            model.yaEstaLlamandoCerradas = true
        }
        
        let ref = refHandle.queryOrdered(byChild: "/idOferente").queryEqual(toValue: uid)
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            
            let compra = Compra()
            let value = snap.value as! [String : AnyObject]
            
            
            compra.idCompra = snap.key
            compra.fecha = value["fecha"] as! String
            compra.idCliente = value["idCliente"] as! String
            compra.idOferente = value["idOferente"] as! String
            compra.valor = value["valor"] as! Int
            compra.timestamp = value["timestamp"] as! CLong
            

            let items = snap.childSnapshot(forPath: "pedido")
            
            let pedidos = items.children
            
            while let ped = pedidos.nextObject() as? DataSnapshot {
                
               let info = ped.value as! NSDictionary
               
                let item = ItemCompra()
                item.cantidad = info["cantidad"] as! Int
                item.estado = info["estado"] as! String
                item.fechaServicio = info["fechaServicio"] as? String
                item.idPublicacion = info["idPublicacion"] as! String
                item.servicio = info["servicio"] as! Bool
                item.compra = compra
                item.consecutivo = Int(ped.key)!
                compra.items.append(item)
                
            }

            if abiertas
            {
                model.misVentas.append(compra)
            } else
            {
                model.misVentasCerradas.append(compra)
            }
            
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoVenta"), object: nil)
            
        })
    
    }
    
    class func setEstadoCompraAbierta(item:ItemCompra, estado:String )
    {
        let ref  = Database.database().reference().child("compras/abiertas/" +  item.compra!.idCompra + "/pedido/" + String(item.consecutivo) + "/estado")
        
        ref.setValue(estado)
    }
    
    
    
}
