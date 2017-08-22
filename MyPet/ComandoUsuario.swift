//
//  ComandoUsuario.swift
//  MyPet
//
//  Created by Jose Aguilar on 12/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase

class ComandoUsuario
{
    class func registrarUsuario(uid:String, correo:String)
    {
        let ref  = FIRDatabase.database().reference().child("clientes/" + uid)
        ref.child("/correo").setValue(correo)
    }
    
    class func completarRegistro(uid:String, correo:String, datos:DatosComplementarios)
    {
        let ref  = FIRDatabase.database().reference().child("clientes/" + uid)
        
        var newItem = ["apellido":datos.apellido as AnyObject,
                       "celular":datos.celular as AnyObject,
                       "documento": datos.documento as AnyObject,
                       "nombre":datos.nombre as AnyObject,
                       "pagoEfectivo":datos.pagoEfectvo as AnyObject] as [String : AnyObject]
        
        newItem["correo"] = correo as AnyObject
        
        for direccion in datos.direcciones!
        {
            let refHandle = ref.child("direcciones").childByAutoId()
            
            var direccionRegistrada = ["direccion" : direccion.direccion as AnyObject,
                                     "nombre" : direccion.nombre as AnyObject,
                                     "porDefecto": direccion.porDefecto as AnyObject] as [String : AnyObject]
            
            for ubicacionDireccion in direccion.ubicacion!
            {
                let ubicacion = ["lat" : ubicacionDireccion.latitud as AnyObject,
                                 "lon" : ubicacionDireccion.longitud as AnyObject] as [String : AnyObject]
                
                direccionRegistrada["ubicacion"] = ubicacion as AnyObject
            }
            
            newItem["direcciones/\(refHandle.key)"] = direccionRegistrada as AnyObject
        }
        
        ref.updateChildValues(newItem)
        
    }
    
    class func getUsuario(uid:String?)
    {
        
        print(uid!)
        
        if uid == nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoUsuario"), object: nil)
        }
        
        let model  = ModeloUsuario.sharedInstance
        model.usuario.removeAll()
        
        let datosUsuario = Usuario()
        
        let ref  = FIRDatabase.database().reference().child("clientes/" + uid!)
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let value = snap.value as? NSDictionary
            
            datosUsuario.correo = value?["correo"] as? String
            
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
                            
                            if mascotaUsuario.activa!
                            {
                                model.mascotaSeleccionada = mascotaUsuario
                            }
                            
                            datosComplementarios.mascotas?.append(mascotaUsuario)
                        }
                    }
                    
                    model.mascotas = datosComplementarios.mascotas!
                    
                    datosComplementarios.nombre = value?["nombre"] as? String
                    datosComplementarios.pagoEfectvo = value?["pagoEfectivo"] as? Bool
                    
                    datosUsuario.datosComplementarios?.append(datosComplementarios)
                }
                
                model.usuario.append(datosUsuario)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoUsuario"), object: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    class func crearIdMascotaUsuario(uid:String?) -> String
    {
        let refHandle  = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas")
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    class func loadFotoMascota(uid:String?, idMascota: String, nombreFoto: String, fotoData:Data)
    {
        let storage = FIRStorage.storage()
        
        // Create a reference to the file you want to upload
        let path = "mascotas/\(uid!)/\(idMascota)/\(nombreFoto)"
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
    
    class func deleteFotoMascota(uid:String?, idMascota: String, nombreFoto: String)
    {
        let storage = FIRStorage.storage()
        
        // Create a reference to the file to delete
        let path = "mascotas/\(uid!)/\(idMascota)/\(nombreFoto)"
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
    
    class func crearEditarMascota(uid:String?, mascota:Mascota)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
        
        refHandle.child("/activa").setValue(mascota.activa)
        refHandle.child("/fechaNacimiento").setValue(mascota.fechaNacimiento)
        refHandle.child("/foto").setValue(mascota.foto)
        refHandle.child("/genero").setValue(mascota.genero)
        refHandle.child("/nombre").setValue(mascota.nombre)
        refHandle.child("/raza").setValue(mascota.raza)
        refHandle.child("/tipo").setValue(mascota.tipo)
    }
    
    class func activarMascota(uid:String?, idMascota:String?, datos:DatosComplementarios)
    {
        for mascota in datos.mascotas!
        {
            let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
            
            if (mascota.idMascota == idMascota)
            {
                refHandle.child("/activa").setValue(true)
            } else
            {
                refHandle.child("/activa").setValue(false)
            }
        }
    }
    
    class func eliminarPerfilMascota(uid:String?, mascota:Mascota)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func crearIdAlertaMascotaUsuario(uid:String?, idMascota:String?) -> String
    {
        let refHandle  = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + idMascota! + "/alertas")
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    class func crearEditarAlertaMascota(uid:String?, idMascota:String?, alerta:Alerta)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + idMascota! + "/alertas/" + alerta.idAlerta!)
        
        refHandle.child("/activada").setValue(alerta.activada)
        refHandle.child("/fechaFin").setValue(alerta.fechaFin)
        refHandle.child("/fechaInicio").setValue(alerta.fechaInicio)
        refHandle.child("/frecuencia").setValue(alerta.frecuencia)
        refHandle.child("/hora").setValue(alerta.hora)
        refHandle.child("/nombre").setValue(alerta.nombre)
        refHandle.child("/tipoRecordatorio").setValue(alerta.tipoRecordatorio)
    }
    
    class func desactivarAlertaMascota(uid:String?, idMascota:String?, alerta:Alerta)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + idMascota! + "/alertas/" + alerta.idAlerta!)
        refHandle.child("/activada").setValue(false)
    }
    
    class func eliminarAlertaMascota(uid:String?, idMascota:String?, alerta:Alerta)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/mascotas/" + idMascota! + "/alertas/" + alerta.idAlerta!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func activarDesactivarFavorito(uid:String?, idPublicacion:String?, activo:Bool)
    {
        let refHandle = FIRDatabase.database().reference().child("clientes/" + uid! + "/favoritos")
        refHandle.child("/\(idPublicacion!)").setValue(activo)
    }
    
    class func preguntarEnPublicacion(pregunta:Pregunta)
    {
        let refHandle  = FIRDatabase.database().reference().child("preguntas").childByAutoId()
        
        refHandle.child("/fechaPregunta").setValue(pregunta.fechaPregunta)
        refHandle.child("/idCliente").setValue(pregunta.idCliente)
        refHandle.child("/idOferente").setValue(pregunta.idOferente)
        refHandle.child("/idPublicacion").setValue(pregunta.idPublicacion)
        refHandle.child("/pregunta").setValue(pregunta.pregunta)
        refHandle.child("/timestamp").setValue(FIRServerValue.timestamp())
        
        let model = Modelo.sharedInstance
        model.preguntasPublicacion.removeAll()
    }
}





































