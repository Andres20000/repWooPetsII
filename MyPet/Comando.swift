//
//  Comando.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

import SystemConfiguration

class Comando
{
    class func crearId(rama:String?) -> String
    {
        let refHandle  = Database.database().reference().child(rama!)
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    // Estados Oferentes
    class func getEstadoOferentes()
    {
        let model  = Modelo.sharedInstance
        model.estadoOferentes.removeAll()
        
        let ref  = Database.database().reference().child("oferentes")
        
        ref.observe(.value, with: {(snap) -> Void in
            
            let oferentes = snap.children
            
            while let oferente = oferentes.nextObject() as? DataSnapshot
            {
                let value = oferente.value as! [String : AnyObject]
                let datosOferente = Oferente()
                
                datosOferente.aprobacionMyPet = value["aprobacionMyPet"] as? String
                datosOferente.idOferente = oferente.key
                
                model.estadoOferentes.append(datosOferente)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoEstadoOferentes"), object: nil)
        })
    }
    
    // Datos Publicaciones
    
    class func getPublicaciones()
    {
        let model  = Modelo.sharedInstance
        
        model.publicacionesPopulares.removeAll()
        model.publicacionesGeneral.removeAll()
        
        let refHandle = Database.database().reference().child("productos")
        
        refHandle.observe(.value, with: {(snap) -> Void in
            
            let publicaciones = snap.children
            
            while let publicacion = publicaciones.nextObject() as? DataSnapshot
            {
                let datosPublicacion = PublicacionOferente()
                
                let value = publicacion.value as! [String : AnyObject]
                
                datosPublicacion.activo = value["activo"] as? Bool
                datosPublicacion.categoria = value["categoria"] as? String
                datosPublicacion.descripcion = value["descripcion"] as? String
                datosPublicacion.destacado = value["destacado"] as? Bool
                
                if publicacion.hasChild("duracion")
                {
                    datosPublicacion.duracion = value["duracion"] as? Int
                }
                
                if publicacion.hasChild("duracionMedida")
                {
                    datosPublicacion.duracionMedida = value["duracionMedida"] as? String
                }
                
                if publicacion.hasChild("fechaCreacion")
                {
                    datosPublicacion.fechaCreacion = value["fechaCreacion"] as? String
                }
                
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
                            horarioServicioSemana.sinJornadaContinua = postDictHorario["sinJornadaContinua"] as? Bool
                            
                            datosPublicacion.horario?.append(horarioServicioSemana)
                            
                        }
                        
                        if (idHorario as? String == "FinDeSemana")
                        {
                            let horarioServicioFestivo = Horario()
                            
                            horarioServicioFestivo.dias = postDictHorario["dias"] as? String
                            horarioServicioFestivo.horaInicio = postDictHorario["horaInicio"] as? String
                            horarioServicioFestivo.horaCierre = postDictHorario["horaCierre"] as? String
                            horarioServicioFestivo.nombreArbol = idHorario as? String
                            horarioServicioFestivo.sinJornadaContinua = postDictHorario["sinJornadaContinua"] as? Bool
                            
                            datosPublicacion.horario?.append(horarioServicioFestivo)
                        }
                        
                    }
                }
                
                datosPublicacion.idOferente = value["idOferente"] as? String
                datosPublicacion.estadoOferente = model.getEstadoOferente(idOferente: datosPublicacion.idOferente!)
                datosPublicacion.idPublicacion = publicacion.key
                datosPublicacion.nombre = value["nombre"] as? String
                datosPublicacion.precio = value["precio"] as? String
                datosPublicacion.servicio = value["servicio"] as? Bool
                
                if publicacion.hasChild("servicioEnDomicilio")
                {
                    datosPublicacion.servicioEnDomicilio = value["servicioEnDomicilio"] as? Bool
                }
                
                if publicacion.hasChild("stock")
                {
                    datosPublicacion.stock = value["stock"] as? Int
                }
                
                if publicacion.hasChild("subcategoria")
                {
                    datosPublicacion.subcategoria = value["subcategoria"] as? String
                }
                
                datosPublicacion.target = value["target"] as? String
                
                if publicacion.hasChild("timestamp")
                {
                    datosPublicacion.timestamp = value["timestamp"] as? CLong
                }
                
                model.publicacionesGeneral.append(datosPublicacion)
                
                print("estado: \(model.getEstadoOferente(idOferente: datosPublicacion.idOferente!))")
                
                if datosPublicacion.estadoOferente == "Aprobado"
                {
                    print("Entra si está aprobado")
                    if datosPublicacion.activo!
                    {
                        print("Entra si está activo")
                        if model.publicacionesPopulares.count > 10
                        {
                            var i = 0
                            
                            for publicacion in model.publicacionesPopulares
                            {
                                if publicacion.idPublicacion == datosPublicacion.idPublicacion
                                {
                                    model.publicacionesPopulares.remove(at: i)
                                }
                                
                                i+=1
                            }
                        }
                        
                        model.publicacionesPopulares.append(datosPublicacion)
                    }
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPublicaciones"), object: nil)
        })
    }
    
    class func getPublicacion(idPublicacion:String?) -> PublicacionOferente
    {
        let datosPublicacion = PublicacionOferente()
        
        let refHandle = Database.database().reference().child("productos/" + idPublicacion!)
        
        refHandle.observe(DataEventType.value, with: { (snap) in
            
            let value = snap.value as! [String : AnyObject]
            
            datosPublicacion.activo = value["activo"] as? Bool
            datosPublicacion.categoria = value["categoria"] as? String
            datosPublicacion.descripcion = value["descripcion"] as? String
            datosPublicacion.destacado = value["destacado"] as? Bool
            
            if snap.hasChild("duracion")
            {
                datosPublicacion.duracion = value["duracion"] as? Int
            }
            
            if snap.hasChild("duracionMedida")
            {
                datosPublicacion.duracionMedida = value["duracionMedida"] as? String
            }
            
            if snap.hasChild("fechaCreacion")
            {
                datosPublicacion.fechaCreacion = value["fechaCreacion"] as? String
            }
            
            if snap.hasChild("fotos")
            {
                let snapFoto = snap.childSnapshot(forPath: "fotos").value as! NSDictionary
                
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
            
            if snap.hasChild("horario")
            {
                let snapHorario = snap.childSnapshot(forPath: "horario").value as! NSDictionary
                
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
                        horarioServicioSemana.sinJornadaContinua = postDictHorario["sinJornadaContinua"] as? Bool
                        
                        datosPublicacion.horario?.append(horarioServicioSemana)
                        
                    }
                    
                    if (idHorario as? String == "FinDeSemana")
                    {
                        let horarioServicioFestivo = Horario()
                        
                        horarioServicioFestivo.dias = postDictHorario["dias"] as? String
                        horarioServicioFestivo.horaInicio = postDictHorario["horaInicio"] as? String
                        horarioServicioFestivo.horaCierre = postDictHorario["horaCierre"] as? String
                        horarioServicioFestivo.nombreArbol = idHorario as? String
                        horarioServicioFestivo.sinJornadaContinua = postDictHorario["sinJornadaContinua"] as? Bool
                        
                        datosPublicacion.horario?.append(horarioServicioFestivo)
                    }
                    
                }
            }
            
            datosPublicacion.idOferente = value["idOferente"] as? String
            datosPublicacion.idPublicacion = snap.key
            datosPublicacion.nombre = value["nombre"] as? String
            datosPublicacion.precio = value["precio"] as? String
            datosPublicacion.servicio = value["servicio"] as? Bool
            
            if snap.hasChild("servicioEnDomicilio")
            {
                datosPublicacion.servicioEnDomicilio = value["servicioEnDomicilio"] as? Bool
            }
            
            if snap.hasChild("stock")
            {
                datosPublicacion.stock = value["stock"] as? Int
            }
            
            if snap.hasChild("subcategoria")
            {
                datosPublicacion.subcategoria = value["subcategoria"] as? String
            }
            
            datosPublicacion.target = value["target"] as? String
            
            if snap.hasChild("timestamp")
            {
                datosPublicacion.timestamp = value["timestamp"] as? CLong
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoPublicacion"), object: nil)
        })
        
        return datosPublicacion
    }
    
    // Datos Mascota
    
    class func getCategorias()
    {
        let model  = ModeloOferente.sharedInstance
        model.categorias.removeAll()
        
        let ref  = Database.database().reference().child("/listados/categorias")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let categorias = snap.children
            
            while let CategoriaChild = categorias.nextObject() as? DataSnapshot
            {
                
                let categoria = Categoria()
                let postDict = CategoriaChild.value as! [String : AnyObject]
                
                categoria.imagen = postDict["imagen"] as? String
                categoria.posicion = postDict["posicion"] as? Int
                categoria.nombre = postDict["nombre"] as? String
                categoria.servicio  = postDict["servicio"] as? Bool
                
                if CategoriaChild.hasChild("subcategoria")
                {
                    let snapSubCategoria = postDict["subcategoria"] as! NSDictionary
                    
                    for (idSubCategoria, _) in snapSubCategoria
                    {
                        let subcategoria = SubCategoria()
                        
                        subcategoria.nombre = idSubCategoria as? String
                        
                        categoria.subcategoria?.append(subcategoria)
                    }
                    
                }
                
                model.categorias.append(categoria)
                model.categorias.sort(by: {$0.posicion! < $1.posicion!})
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoCategorias"), object: nil)
            
        });
    }
    
    class func getTiposMascota()
    {
        let model  = Modelo.sharedInstance
        model.tiposMascota.removeAll()
        
        let ref  = Database.database().reference().child("/listados/tiposMascota")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapTipos = snap.value as! NSDictionary
            
            for (idTipo, _) in snapTipos
            {
                let tipoMascota = TiposMascota()
                
                tipoMascota.nombreTipo = idTipo as? String
                
                model.tiposMascota.append(tipoMascota)
                model.tiposMascota.sort { $0.nombreTipo?.localizedCaseInsensitiveCompare($1.nombreTipo!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoTipoMascotas"), object: nil)
            
        });
    }
    
    class func getRazasPerro()
    {
        let model  = Modelo.sharedInstance
        model.razasPerro.removeAll()
        
        let ref  = Database.database().reference().child("/listados/razasPerro")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapRazas = snap.value as! NSDictionary
            
            for (idRaza, _) in snapRazas
            {
                let razaPerro = RazasPerro()
                
                razaPerro.nombreRaza = idRaza as? String
                
                model.razasPerro.append(razaPerro)
                model.razasPerro.sort { $0.nombreRaza?.localizedCaseInsensitiveCompare($1.nombreRaza!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoRazasPerro"), object: nil)
            
        });
    }
    
    class func getRazasGato()
    {
        let model  = Modelo.sharedInstance
        model.razasGato.removeAll()
        
        let ref  = Database.database().reference().child("/listados/razasGato")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapRazas = snap.value as! NSDictionary
            
            for (idRaza, _) in snapRazas
            {
                let razaGato = RazasGato()
                
                razaGato.nombreRaza = idRaza as? String
                
                model.razasGato.append(razaGato)
                model.razasGato.sort { $0.nombreRaza?.localizedCaseInsensitiveCompare($1.nombreRaza!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoRazasGato"), object: nil)
            
        });
    }
    
    // Datos Alertas
    
    class func getTiposRecordatorio()
    {
        let model  = Modelo.sharedInstance
        model.tiposRecordatorio.removeAll()
        
        let ref  = Database.database().reference().child("/listados/tiposRecordatorio")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapTipos = snap.value as! NSDictionary
            
            for (idTipo, _) in snapTipos
            {
                let tipoRecordatorio = TipoRecordatorio()
                
                tipoRecordatorio.nombreTipo = idTipo as? String
                
                model.tiposRecordatorio.append(tipoRecordatorio)
                model.tiposRecordatorio.sort { $0.nombreTipo?.localizedCaseInsensitiveCompare($1.nombreTipo!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoTiposRecordatorio"), object: nil)
            
        });
    }
    
    class func getFrecuenciasRecordatorio()
    {
        let model  = Modelo.sharedInstance
        model.frecuenciasRecordatorio.removeAll()
        
        let ref  = Database.database().reference().child("/listados/frecuenciasRecordatorio")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapFrecuencias = snap.value as! NSDictionary
            
            for (idFrecuencia, _) in snapFrecuencias
            {
                let frecuenciaRecordatorio = FrecuenciaRecordatorio()
                
                frecuenciaRecordatorio.nombreFrecuencia = idFrecuencia as? String
                
                model.frecuenciasRecordatorio.append(frecuenciaRecordatorio)
                model.frecuenciasRecordatorio.sort { $0.nombreFrecuencia?.localizedCaseInsensitiveCompare($1.nombreFrecuencia!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoFrecuenciasRecordatorio"), object: nil)
            
        });
    }
    
    // Validar ingreso (FB/Correo)
    
    class func validarTipoIngreso() -> Bool
    {
        let user = Auth.auth().currentUser
        
        if user != nil
        {
            var provider = ""
            
            for profile in user!.providerData
            {
                //let providerID = profile.providerID
                //let uid = profile.uid;  // Provider-specific UID
                provider = profile.providerID
            }
            
            if provider == "facebook.com"
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        return false
    }
    
    // Datos Sistema
    
    class func updateDataSystem(tipo:String, uid:String, version : String)
    {
        let ref  = Database.database().reference().child(tipo + "/" + uid)
        
        let newItem = ["fechaUltimoLogeo":Date().fechaString() as AnyObject,
                       "horaUltimoLogeo":Date().horaString() as AnyObject,
                       "systemDevice": "iOS",
                       "version":version as AnyObject] as [String : AnyObject]
        
        ref.updateChildValues(newItem)
    }
    
    // Mensajes para PushNotifications
    
    class func enviarMensaje(mensaje:Mensaje)
    {
        let refHandle  = Database.database().reference().child("mensajes").childByAutoId()
        
        var newItem = ["mensaje": mensaje.mensaje as AnyObject,
                       "timestamp":ServerValue.timestamp(),
                       "tipo":mensaje.tipo as AnyObject,
                       "titulo":mensaje.titulo as AnyObject,
                       "tokens/\(mensaje.token!)":true as AnyObject,
                       "visto":mensaje.visto as AnyObject] as [String : AnyObject]
        
        if mensaje.idCliente != ""
        {
            newItem["idCliente"] = mensaje.idCliente as AnyObject
        }
        
        if mensaje.idCompra != ""
        {
            newItem["idCompra"] = mensaje.idCompra as AnyObject
        }
        
        if mensaje.idOferente != ""
        {
            newItem["idOferente"] = mensaje.idOferente as AnyObject
        }
        
        if mensaje.idPublicacion != ""
        {
            newItem["idPublicacion"] = mensaje.idPublicacion as AnyObject
        }
        
        if mensaje.infoAdicional != ""
        {
            newItem["infoAdicional"] = mensaje.infoAdicional as AnyObject
        }
        
        refHandle.updateChildValues(newItem)
    }
    
    class func getNotificaciones()
    {
        let model  = Modelo.sharedInstance
        let modelOferente  = ModeloOferente.sharedInstance
        let modelUsuario  = ModeloUsuario.sharedInstance
        
        model.notificacionesUsuario.removeAll()
        model.notificacionesOferente.removeAll()
        modelOferente.notificacionesOferenteSinLeer = 0
        modelUsuario.notificacionesUsuarioSinLeer = 0
        
        let refHandle  = Database.database().reference().child("mensajes")
        
        refHandle.observeSingleEvent(of: .value, with: {snap in
            
            let notificaciones = snap.children
            
            while let notificacion = notificaciones.nextObject() as? DataSnapshot
            {
                if notificacion.value as? [String : AnyObject] != nil
                {
                    let postDict = notificacion.value as! [String : AnyObject]
                    let miNotificacion = Mensaje()
                    
                    if notificacion.hasChild("idCompra")
                    {
                        miNotificacion.idCompra = postDict["idCompra"] as? String
                    }
                    
                    miNotificacion.idMensaje = notificacion.key
                    
                    if notificacion.hasChild("idPublicacion")
                    {
                        miNotificacion.idPublicacion = postDict["idPublicacion"] as? String
                    }
                    
                    miNotificacion.infoAdicional = postDict["infoAdicional"] as? String
                    miNotificacion.timestamp = postDict["timestamp"] as? CLong
                    miNotificacion.tipo = postDict["tipo"] as? String
                    miNotificacion.visto = postDict["visto"] as? Bool
                    
                    let  user = Auth.auth().currentUser
                    
                    if notificacion.hasChild("idCliente")
                    {
                        miNotificacion.idCliente = postDict["idCliente"] as? String
                        
                        if user != nil
                        {
                            if (user?.uid)! == miNotificacion.idCliente
                            {
                                var i = 0
                                
                                for notificacion in model.notificacionesUsuario
                                {
                                    if notificacion.idMensaje == miNotificacion.idMensaje
                                    {
                                        model.notificacionesUsuario.remove(at: i)
                                    }
                                    
                                    i+=1
                                }
                                
                                if !miNotificacion.visto!
                                {
                                    modelUsuario.notificacionesUsuarioSinLeer+=1
                                }
                                
                                model.notificacionesUsuario.append(miNotificacion)
                                model.notificacionesUsuario.sort(by: {$0.timestamp! > $1.timestamp!})
                            }
                        }
                    }
                    
                    if notificacion.hasChild("idOferente")
                    {
                        miNotificacion.idOferente = postDict["idOferente"] as? String
                        
                        if user != nil
                        {
                            if (user?.uid)! == miNotificacion.idOferente
                            {
                                var i = 0
                                
                                for notificacion in model.notificacionesOferente
                                {
                                    if notificacion.idMensaje == miNotificacion.idMensaje
                                    {
                                        model.notificacionesOferente.remove(at: i)
                                    }
                                    
                                    i+=1
                                }
                                
                                if !miNotificacion.visto!
                                {
                                    modelOferente.notificacionesOferenteSinLeer+=1
                                }
                                
                                model.notificacionesOferente.append(miNotificacion)
                                model.notificacionesOferente.sort(by: {$0.timestamp! > $1.timestamp!})
                            }
                        }
                    }
                }
            }
            
            NotificationCenter.default.post(name: Notification.Name("cargoNotificaciones"), object: nil)
        })
    }
    
    class func cambiarVistoNotificacion(mensaje:Mensaje)
    {
        let refHandle  = Database.database().reference().child("mensajes/" + mensaje.idMensaje!)
        refHandle.child("visto").setValue(true)
    }
    
    class func eliminarNotificacion(mensaje:Mensaje)
    {
        let refHandle  = Database.database().reference().child("mensajes/" + mensaje.idMensaje!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    // Funciones para Chat
    
    class func enviarMensajeAlChat(chat:ChatCompraVenta)
    {
        let refHandle  = Database.database().reference().child("chats").childByAutoId()
        
        let newItem = ["emisor": chat.emisor as AnyObject,
                       "fechaMensaje":chat.fechaMensaje as AnyObject,
                       "idCompra":chat.idCompra as AnyObject,
                       "mensaje":chat.mensaje as AnyObject,
                       "receptor":chat.receptor as AnyObject,
                       "timestamp":ServerValue.timestamp(),
                       "visto":chat.visto as AnyObject] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    class func cambiarVistoChat(chat:ChatCompraVenta)
    {
        let refHandle  = Database.database().reference().child("chats/" + chat.idChat!)
        refHandle.child("visto").setValue(true)
    }
    
    class func  getChatsCompras()
    {
        let model = Modelo.sharedInstance
        model.chatsCompraVenta.removeAll()
        
        let refHandle:DatabaseReference! = Database.database().reference().child("chats")
        
        refHandle.observeSingleEvent(of: .value, with: {snap in
            
            let chats = snap.children
            
            while let ChatChild = chats.nextObject() as? DataSnapshot
            {
                let postDict = ChatChild.value as! [String : AnyObject]
                let chat = ChatCompraVenta()
                
                chat.emisor = postDict["emisor"] as? String
                chat.fechaMensaje = postDict["fechaMensaje"] as? String
                chat.idChat = ChatChild.key
                chat.idCompra = postDict["idCompra"] as? String
                chat.mensaje = postDict["mensaje"] as? String
                chat.receptor = postDict["receptor"] as? String
                chat.timestamp = postDict["timestamp"] as? CLong
                chat.visto = postDict["visto"] as? Bool
                
                /*var i = 0
                
                for chat in model.chatsCompraVenta
                {
                    if chat.idChat == chat.idChat
                    {
                        model.chatsCompraVenta.remove(at: i)
                    }
                    
                    i+=1
                }*/
                
                model.chatsCompraVenta.append(chat)
                model.chatsCompraVenta.sort(by: {$0.timestamp! > $1.timestamp!})
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoChatsCompras"), object: nil)
            
        })
    }
    
    // Ayuda PQRS (Solicitudes)
    
    class func getTiposSolicitudes()
    {
        let model  = Modelo.sharedInstance
        model.tiposSolicitudes.removeAll()
        
        let ref  = Database.database().reference().child("/listados/tiposSolicitudes")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let tiposSolicitudes = snap.children
            
            while let tiposChild = tiposSolicitudes.nextObject() as? DataSnapshot
            {
                let tipoSolicitud = TipoSolicitud()
                let postDict = tiposChild.value as! [String : AnyObject]
                
                tipoSolicitud.consecutivo = postDict["consecutivo"] as? Int
                tipoSolicitud.idTipoSolicitud = tiposChild.key
                tipoSolicitud.nombre = postDict["nombre"] as? String
                tipoSolicitud.siglaConsecutivo = postDict["siglaConsecutivo"] as? String
                
                model.tiposSolicitudes.append(tipoSolicitud)
                model.tiposSolicitudes.sort { $0.idTipoSolicitud?.localizedCaseInsensitiveCompare($1.idTipoSolicitud!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoTiposSolicitudes"), object: nil)
            
        });
    }
    
    // Mensaje en TableView sin datos
    
    func EmptyMessage(_ message:String, tableView:UITableView)
    {
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel;
    }
    
    // Validar correo
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
    }
    
    class func calcularFechaEnAños(fecha1:NSDate, fecha2:NSDate) -> Int
    {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let calcAge = calendar.components(.year, from: fecha2 as Date, to: fecha1 as Date, options: [])
        let age = calcAge.year
        return age!
    }
    
    class func calcularFechaEnMeses(fecha1:NSDate, fecha2:NSDate) -> Int
    {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let calcMonth = calendar.components(.month, from: fecha2 as Date, to: fecha1 as Date, options: [])
        let month = calcMonth.month
        return month!
    }
    
    class func calcularFechaEnDias(fecha1:NSDate, fecha2:NSDate) -> Int
    {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let calcDay = calendar.components(.day, from: fecha2 as Date, to: fecha1 as Date, options: [])
        let day = calcDay.day
        return day!
    }
    
    // Internet Vaidation Helper...
    class func isConnectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }

}
