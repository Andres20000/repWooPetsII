//
//  ComandoPreguntasOferente.swift
//  MyPet
//
//  Created by Andres Garcia on 8/10/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase


class ComandoPreguntasOferente {
    
    
    class func getTodasMisPreguntas() {
        
        let model = ModeloOferente.sharedInstance
        
        model.preguntas.removeAll()
        let uid = model.idOferente
        
        let refHandle = FIRDatabase.database().reference().child("preguntas")
        
        let ref = refHandle.queryOrdered(byChild: "/idOferente").queryEqual(toValue: uid)
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            
            let pregu = Pregunta()
            let value = snap.value as! [String : AnyObject]
            
            pregu.fechaPregunta = value["fechaPregunta"] as? String
            
            if snap.hasChild("fechaRespuesta")
            {
                pregu.fechaRespuesta = value["fechaRespuesta"] as? String
            }
            
            pregu.idCliente = value["idCliente"] as? String
            pregu.idOferente = value["idOferente"] as? String
            pregu.idPregunta = snap.key
            pregu.idPublicacion = value["idPublicacion"] as? String
            pregu.pregunta = value["pregunta"] as? String
            
            if snap.hasChild("respuesta")
            {
                pregu.respuesta = value["respuesta"] as? String
            }
            
            pregu.timestamp = value["timestamp"] as? CLong
            
            model.preguntas.append(pregu)
            
            model.preguntas.sort(by: {$0.timestamp! > $1.timestamp!})
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPregunta"), object: nil)
            
        })
    }
    
    
    
    class func getMiniUsuario(uid:String?)
    {
        
        
        let model  = ModeloOferente.sharedInstance
        
        let datosUsuario = Usuario()
        
        let ref  = FIRDatabase.database().reference().child("clientes/" + uid!)
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let value = snap.value as? NSDictionary
            
            datosUsuario.correo = value?["correo"] as? String
            datosUsuario.id = uid!
            
            if datosUsuario.correo != nil
            {
                if snap.hasChild("apellido")
                {
                    let datosComplementarios = DatosComplementarios()
                    
                    datosComplementarios.apellido = value?["apellido"] as? String
                    datosComplementarios.celular = value?["celular"] as? String
                    
                    let snapDirecciones = snap.childSnapshot(forPath: "direcciones").value as! NSDictionary
                    
                    for (idDireccion, direccion) in snapDirecciones
                    {
                        let postDictDireccion = (direccion as! [String : AnyObject])
                        let direccionUsuario = Direccion()
                        
                        direccionUsuario.idDireccion = idDireccion as? String
                        direccionUsuario.direccion = postDictDireccion["direccion"] as? String
                        direccionUsuario.nombre = postDictDireccion["nombre"] as? String
                        direccionUsuario.porDefecto = postDictDireccion["porDefecto"] as? Bool
                        
                        let valUbicacion = postDictDireccion["ubicacion"] as? NSDictionary
                        let ubicacionDireccion = Ubicacion()
                        
                        ubicacionDireccion.latitud = valUbicacion?["lat"] as? Double
                        ubicacionDireccion.longitud = valUbicacion?["lon"] as? Double
                        
                        direccionUsuario.ubicacion?.append(ubicacionDireccion)
                        
                        datosComplementarios.direcciones?.append(direccionUsuario)
                    }
                    
                    datosComplementarios.documento = value?["documento"] as? String
                    
                    if snap.hasChild("favoritos")
                    {
                        let snapFavoritos = snap.childSnapshot(forPath: "favoritos").value as! NSDictionary
                        
                        for (idFavorito, activo) in snapFavoritos
                        {
                            let favoritoUsuario = Favorito()
                            
                            favoritoUsuario.idPublicacion = idFavorito as? String
                            favoritoUsuario.activo = activo as? Bool
                            
                            if favoritoUsuario.activo!
                            {
                                datosComplementarios.favoritos?.append(favoritoUsuario)
                            }
                        }
                    }
                    
                    if snap.hasChild("mascotas")
                    {
                        let snapMascotas = snap.childSnapshot(forPath: "mascotas").value as! NSDictionary
                        
                        for (idMascota, mascota) in snapMascotas
                        {
                            let postDictMascota = (mascota as! [String : AnyObject])
                            let mascotaUsuario = Mascota()
                            
                            mascotaUsuario.idMascota = idMascota as? String
                            mascotaUsuario.activa = postDictMascota["activa"] as? Bool
                            mascotaUsuario.fechaNacimiento = postDictMascota["fechaNacimiento"] as? String
                            mascotaUsuario.foto = postDictMascota["foto"] as? String
                            mascotaUsuario.genero = postDictMascota["genero"] as? String
                            mascotaUsuario.nombre = postDictMascota["nombre"] as? String
                            mascotaUsuario.raza = postDictMascota["raza"] as? String
                            mascotaUsuario.tipo = postDictMascota["tipo"] as? String
                            
                           
                            
                            datosComplementarios.mascotas?.append(mascotaUsuario)
                        }
                    }
                    
                   
                    
                    datosComplementarios.nombre = value?["nombre"] as? String
                    datosComplementarios.pagoEfectvo = value?["pagoEfectivo"] as? Bool
                    
                    datosUsuario.datosComplementarios?.append(datosComplementarios)
                }
                
                model.misUsuarios[datosUsuario.id] = datosUsuario
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoMiniUsuario"), object: nil)
        })
    }

   
    
    class func updateRespuesta(respuesta:String, idPregunta:String) {
        
        var ref  = FIRDatabase.database().reference().child("preguntas/" + idPregunta + "/respuesta")
        ref.setValue(respuesta)
        
        let nowDate = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.string(from: nowDate as Date)
        
        
        
        ref  = FIRDatabase.database().reference().child("preguntas/" + idPregunta + "/fechaRespuesta")
        ref.setValue(dateString)
        
        
    }
    
    
    
    
}

