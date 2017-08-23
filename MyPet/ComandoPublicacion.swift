//
//  ComandoPublicacion.swift
//  MyPet
//
//  Created by Jose Aguilar on 12/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ComandoPublicacion
{
    class func crearIdPublicacionOferente() -> String
    {
        let refHandle  = FIRDatabase.database().reference().child("productos")
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    class func crearPublicacionOferente(publicacion:PublicacionOferente)
    {
        let refHandle  = FIRDatabase.database().reference().child("productos/" + publicacion.idPublicacion!)
        
        var newItem = ["activo":publicacion.activo as Any,
                       "categoria":publicacion.categoria as Any,
                       "descripcion": publicacion.descripcion as Any,
                       "destacado":publicacion.destacado as Any,
                       "idOferente":publicacion.idOferente as Any,
                       "nombre":publicacion.nombre as Any,
                       "precio":publicacion.precio as Any,
                       "servicio":publicacion.servicio as Any,
                       "target":publicacion.target as Any] as [String : Any]
        
        if (publicacion.fotos?.count)! > 0
        {
            for foto in (publicacion.fotos)!
            {
                newItem["fotos/\(foto.idFoto as AnyObject)"] = foto.nombreFoto as AnyObject
            }
        }
        
        if publicacion.horario!.count != 0
        {
            for horarioPublicacion in publicacion.horario!
            {
                let horario = ["dias" : horarioPublicacion.dias as Any,
                               "horaCierre" : horarioPublicacion.horaCierre as Any,
                               "horaInicio" : horarioPublicacion.horaInicio as Any] as [String : Any]
                
                newItem["horario/\(horarioPublicacion.nombreArbol as AnyObject)"] = horario as AnyObject
            }
        }
        
        if publicacion.stock != ""
        {
            newItem["stock"] = publicacion.stock as AnyObject
        }
        
        if publicacion.subcategoria != ""
        {
            newItem["subcategoria"] = publicacion.subcategoria as AnyObject
        }
        
        refHandle.updateChildValues(newItem)
    }
    
    class func getPublicacionesOferente(uid:String?)
    {
        if uid == nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPublicacionesOferente"), object: nil)
        }
        
        let model  = ModeloOferente.sharedInstance
        model.publicacionesActivas.removeAll()
        model.publicacionesInactivas.removeAll()
        
        let refHandle = FIRDatabase.database().reference().child("productos")
        
        let ref = refHandle.queryOrdered(byChild: "/idOferente").queryEqual(toValue: uid)
        
        ref.observe(.value, with: {(snap) -> Void in
            
            let publicaciones = snap.children
            
            while let publicacion = publicaciones.nextObject() as? FIRDataSnapshot
            {
                let datosPublicacion = PublicacionOferente()
                let value = publicacion.value as! [String : AnyObject]
                
                datosPublicacion.activo = value["activo"] as? Bool
                datosPublicacion.categoria = value["categoria"] as? String
                datosPublicacion.descripcion = value["descripcion"] as? String
                datosPublicacion.destacado = value["destacado"] as? Bool
                
                if publicacion.hasChild("fotos")
                {
                    let snapFoto = publicacion.childSnapshot(forPath: "fotos").value as! NSDictionary
                    
                    for (id, foto) in snapFoto
                    {
                        let fotoPublicacion = Foto()
                        
                        fotoPublicacion.idFoto = id as? String
                        fotoPublicacion.nombreFoto = foto as? String
                        
                        let str:String = fotoPublicacion.idFoto!
                        let endIndex = str.index(str.startIndex, offsetBy: 4)
                        fotoPublicacion.numeroFoto = Int(str[endIndex].description)
                        
                        datosPublicacion.fotos?.append(fotoPublicacion)
                        datosPublicacion.fotos?.sort(by: {$0.numeroFoto < $1.numeroFoto})
                    }
                }
                
                if publicacion.hasChild("horario")
                {
                    let snapHorario = publicacion.childSnapshot(forPath: "horario").value as! NSDictionary
                    
                    var i = 0
                    
                    for (idHorario, horario) in snapHorario
                    {
                        let postDictHorario = (horario as! [String : AnyObject])
                        
                        if (idHorario as? String == "Semana")
                        {
                            let horarioServicioSemana = Horario()
                            
                            horarioServicioSemana.dias = postDictHorario["dias"] as? String
                            horarioServicioSemana.horaInicio = postDictHorario["horaInicio"] as? String
                            horarioServicioSemana.horaCierre = postDictHorario["horaCierre"] as? String
                            horarioServicioSemana.nombreArbol = idHorario as? String
                            
                            datosPublicacion.horario?.append(horarioServicioSemana)
                            
                        }
                        
                        if (idHorario as? String == "FinDeSemana")
                        {
                            let horarioServicioFestivo = Horario()
                            
                            horarioServicioFestivo.dias = postDictHorario["dias"] as? String
                            horarioServicioFestivo.horaInicio = postDictHorario["horaInicio"] as? String
                            horarioServicioFestivo.horaCierre = postDictHorario["horaCierre"] as? String
                            horarioServicioFestivo.nombreArbol = idHorario as? String
                            
                            datosPublicacion.horario?.append(horarioServicioFestivo)
                        }
                        
                        i += 1
                    }
                }
                
                datosPublicacion.idOferente = value["idOferente"] as? String
                datosPublicacion.idPublicacion = publicacion.key
                datosPublicacion.nombre = value["nombre"] as? String
                datosPublicacion.precio = value["precio"] as? String
                datosPublicacion.servicio = value["servicio"] as? Bool
                datosPublicacion.duracion = value["duracion"] as? Int
            
                
                if publicacion.hasChild("stock")
                {
                    datosPublicacion.stock = value["stock"] as? String
                }
                
                if publicacion.hasChild("subcategoria")
                {
                    datosPublicacion.subcategoria = value["subcategoria"] as? String
                }
                
                datosPublicacion.target = value["target"] as? String
                
                if datosPublicacion.activo!
                {
                    model.publicacionesActivas.append(datosPublicacion)
                    
                } else
                {
                    model.publicacionesInactivas.append(datosPublicacion)
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPublicacionesOferente"), object: nil)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    class func loadImagenPublicacion(idFoto: String, nombreFoto: String, fotoData:Data)
    {
        let storage = FIRStorage.storage()
        
        // Create a reference to the file you want to upload
        let path = "productos/" + idFoto + "/" + nombreFoto
        let ref = storage.reference(withPath: path)
        
        // Upload the file to the path
        let uploadTask = ref.put(fotoData, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error load image desde Firebase: \(error.debugDescription)")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print("progress: \(percentComplete)")
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("status: \(snapshot.status)")
        }
    }
    
    class func deleteImagenesPublicacion(idFoto: String, nombreFoto: String)
    {
        let storage = FIRStorage.storage()
        
        // Create a reference to the file to delete
        let path = "productos/" + idFoto + "/" + nombreFoto
        let ref = storage.reference(withPath: path)
        
        // Delete the file
        ref.delete { (error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error delete image en Firebase: \(error.debugDescription)")
            } else {
                // File deleted successfully
                print("Referencia eliminada")
            }
        }
    }
    
    class func updateEstadoPublicacion(idPublicacion:String, activo:Bool)
    {
        let refHandle = FIRDatabase.database().reference().child("/productos/" + idPublicacion)
        refHandle.child("/activo").setValue(activo)
    }
    
    class func updateTipo(idPublicacion:String, tipo:String)
    {
        let refHandle = FIRDatabase.database().reference().child("/productos/" + idPublicacion)
        refHandle.child("/target").setValue(tipo)
    }
    
    class func updateArticulo(idPublicacion:String)
    {
        let model  = ModeloOferente.sharedInstance
        
        let refHandle = FIRDatabase.database().reference().child("/productos/" + idPublicacion)
        
        refHandle.child("/descripcion").setValue(model.publicacion.descripcion)
        refHandle.child("/nombre").setValue(model.publicacion.nombre)
        refHandle.child("/precio").setValue(model.publicacion.precio)
        
        if model.publicacion.servicio!
        {
            for horarioPublicacion in model.publicacion.horario!
            {
                if horarioPublicacion.nombreArbol == "Semana"
                {
                    refHandle.child("/horario/Semana/dias").setValue(horarioPublicacion.dias)
                    refHandle.child("/horario/Semana/horaCierre").setValue(horarioPublicacion.horaCierre)
                    refHandle.child("/horario/Semana/horaInicio").setValue(horarioPublicacion.horaInicio)
                }
                
                if horarioPublicacion.nombreArbol == "FinDeSemana"
                {
                    refHandle.child("/horario/FinDeSemana/dias").setValue(horarioPublicacion.dias)
                    refHandle.child("/horario/FinDeSemana/horaCierre").setValue(horarioPublicacion.horaCierre)
                    refHandle.child("/horario/FinDeSemana/horaInicio").setValue(horarioPublicacion.horaInicio)
                }
            }
        }else
        {
            refHandle.child("/stock").setValue(model.publicacion.stock)
        }
    }
    
    class func updateFotos(idPublicacion:String)
    {
        let model  = ModeloOferente.sharedInstance
        
        let refHandle = FIRDatabase.database().reference().child("/productos/" + idPublicacion)
        
        for foto in (model.publicacion.fotos)!
        {
            refHandle.child("/fotos/\(foto.idFoto as AnyObject)").setValue(foto.nombreFoto as AnyObject)
        }
        
    }
    
    class func getPreguntasRespuestasPublicacionOferente(idPublicacion:String)
    {
        let model = Modelo.sharedInstance
        model.preguntasPublicacion.removeAll()
        
        let refHandle = FIRDatabase.database().reference().child("preguntas")
        
        let ref = refHandle.queryOrdered(byChild: "/idPublicacion").queryEqual(toValue: idPublicacion)
        
        ref.observe(.value, with: {(snap) -> Void in
            
            let preguntas = snap.children
            
            while let pregunta = preguntas.nextObject() as? FIRDataSnapshot
            {
                let datosPregunta = Pregunta()
                let value = pregunta.value as! [String : AnyObject]
                
                datosPregunta.fechaPregunta = value["fechaPregunta"] as? String
                
                if pregunta.hasChild("fechaRespuesta")
                {
                    datosPregunta.fechaRespuesta = value["fechaRespuesta"] as? String
                }
                
                datosPregunta.idCliente = value["idCliente"] as? String
                datosPregunta.idOferente = value["idOferente"] as? String
                datosPregunta.idPregunta = pregunta.key
                datosPregunta.idPublicacion = value["idPublicacion"] as? String
                datosPregunta.pregunta = value["pregunta"] as? String
                
                if pregunta.hasChild("respuesta")
                {
                    datosPregunta.respuesta = value["respuesta"] as? String
                }
                
                datosPregunta.timestamp = value["timestamp"] as? CLong
                
                model.preguntasPublicacion.append(datosPregunta)
                
                //model.preguntasPublicacion.sort(by: {$0.timestamp! > $1.timestamp!})
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPreguntasRespuestasPublicacion"), object: nil)
        })
    }
}




































