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
        let ref  = Database.database().reference().child("clientes/" + uid)
        ref.child("/correo").setValue(correo)
    }
    
    class func sendTokenDevice(uid:String, token:String)
    {
        let refHandle = Database.database().reference().child("clientes/" + uid)
        refHandle.child("/tokenDevice").setValue(token)
    }
    
    class func completarRegistro(uid:String, datos:DatosComplementarios)
    {
        let ref  = Database.database().reference().child("clientes/" + uid)
        
        ref.child("/apellido").setValue(datos.apellido)
        ref.child("/celular").setValue(datos.celular)
        
        for direccion in datos.direcciones!
        {
            let refHandle = ref.child("direcciones").childByAutoId()
            
            refHandle.child("/direccion").setValue(direccion.direccion)
            refHandle.child("/nombre").setValue(direccion.nombre)
            refHandle.child("/porDefecto").setValue(direccion.porDefecto)
            refHandle.child("/posicion").setValue(direccion.posicion)
            
            for ubicacionDireccion in direccion.ubicacion!
            {
                refHandle.child("/ubicacion/lat").setValue(ubicacionDireccion.latitud)
                refHandle.child("/ubicacion/lon").setValue(ubicacionDireccion.longitud)
            }
        }
        
        ref.child("/documento").setValue(datos.documento)
        ref.child("/nombre").setValue(datos.nombre)
        ref.child("/metodoDePago").setValue(datos.metodoDePago)
    }
    
    class func editarDatosPerfil(uid:String, datos:DatosComplementarios)
    {
        let ref  = Database.database().reference().child("clientes/" + uid)
        
        ref.child("/apellido").setValue(datos.apellido)
        ref.child("/celular").setValue(datos.celular)
        
        for direccion in datos.direcciones!
        {
            var refHandle:DatabaseReference! = nil
            
            if direccion.idDireccion == ""
            {
                refHandle = ref.child("direcciones").childByAutoId()
                
            }else
            {
                refHandle = ref.child("direcciones/" + direccion.idDireccion!)
            }
            
            refHandle.child("/direccion").setValue(direccion.direccion)
            refHandle.child("/nombre").setValue(direccion.nombre)
            refHandle.child("/porDefecto").setValue(direccion.porDefecto)
            refHandle.child("/posicion").setValue(direccion.posicion)
            
            for ubicacionDireccion in direccion.ubicacion!
            {
                refHandle.child("/ubicacion/lat").setValue(ubicacionDireccion.latitud)
                refHandle.child("/ubicacion/lon").setValue(ubicacionDireccion.longitud)
            }
        }
        
        ref.child("/documento").setValue(datos.documento)
        ref.child("/nombre").setValue(datos.nombre)
    }
    
    class func eliminarDireccion(uid:String?, idDireccion:String?)
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/direcciones/" + idDireccion!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func activarDireccion(uid:String?, idDireccion:String?, datos:DatosComplementarios)
    {
        print("idDirección: \(idDireccion!)")
        for direccion in datos.direcciones!
        {
            let refHandle = Database.database().reference().child("clientes/" + uid! + "/direcciones/" + direccion.idDireccion!)
            
            if (direccion.idDireccion == idDireccion)
            {
                refHandle.child("/porDefecto").setValue(true)
            } else
            {
                refHandle.child("/porDefecto").setValue(false)
            }
        }
    }
    
    class func editarMetodoPago(uid:String, metodoDePago:String)
    {
        let ref  = Database.database().reference().child("clientes/" + uid)
        
        ref.child("/metodoDePago").setValue(metodoDePago)
    }
    
    class func getUsuario(uid:String?)
    {
        let model  = ModeloUsuario.sharedInstance
        model.usuario.removeAll()
        
        let ref  = Database.database().reference().child("clientes/" + uid!)
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let value = snap.value as? NSDictionary
            let datosUsuario = Usuario()
            
            datosUsuario.correo = value?["correo"] as? String
            
            if datosUsuario.correo != nil
            {
                if snap.hasChild("apellido")
                {
                    let datosComplementarios = DatosComplementarios()
                    
                    datosComplementarios.apellido = value?["apellido"] as? String
                    
                    if snap.hasChild("carrito")
                    {
                        let snapPublicacionesEnCarrito = snap.childSnapshot(forPath: "carrito").value as! NSDictionary
                        
                        for (idCarrito, carrito) in snapPublicacionesEnCarrito
                        {
                            let postDictCarrito = (carrito as! [String : AnyObject])
                            let carritoUsuario = Carrito()
                            
                            carritoUsuario.cantidadCompra = postDictCarrito["cantidadCompra"] as? Int
                            carritoUsuario.servicio = postDictCarrito["servicio"] as? Bool
                            
                            if carritoUsuario.servicio!
                            {
                                
                                carritoUsuario.fechaHoraReserva = postDictCarrito["fechaHoraReserva"] as? String
                            }
                            
                            carritoUsuario.idCarrito = idCarrito as? String
                            carritoUsuario.idPublicacion = postDictCarrito["idPublicacion"] as? String
                            
                            carritoUsuario.publicacionCompra = Comando.getPublicacion(idPublicacion: carritoUsuario.idPublicacion!)
                            
                            datosComplementarios.carrito?.append(carritoUsuario)
                        }
                    }
                    
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
                        direccionUsuario.posicion = postDictDireccion["posicion"] as? Int
                        
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
                            
                            let valAlerta = postDictMascota["alertas"] as? NSDictionary
                            
                            if valAlerta != nil
                            {
                                for (idAlerta, alerta) in valAlerta!
                                {
                                    let postDictAlerta = (alerta as! [String : AnyObject])
                                    let alertaMascota = Alerta()
                                    
                                    alertaMascota.activada = postDictAlerta["activada"] as? Bool
                                    alertaMascota.fechaFin = postDictAlerta["fechaFin"] as? String
                                    alertaMascota.fechaInicio = postDictAlerta["fechaInicio"] as? String
                                    alertaMascota.frecuencia = postDictAlerta["frecuencia"] as? String
                                    alertaMascota.hora = postDictAlerta["hora"] as? String
                                    alertaMascota.idAlerta = idAlerta as? String
                                    alertaMascota.idMascota = mascotaUsuario.idMascota
                                    alertaMascota.nombre = postDictAlerta["nombre"] as? String
                                    alertaMascota.tipoRecordatorio = postDictAlerta["tipoRecordatorio"] as? String
                                    
                                    mascotaUsuario.alertas?.append(alertaMascota)
                                }
                            }
                            
                            if mascotaUsuario.activa!
                            {
                                model.mascotaSeleccionada = mascotaUsuario
                            }
                            
                            datosComplementarios.mascotas?.append(mascotaUsuario)
                        }
                    }
                    
                    model.mascotas = datosComplementarios.mascotas!
                    
                    datosComplementarios.nombre = value?["nombre"] as? String
                    datosComplementarios.metodoDePago = value?["metodoDePago"] as? String
                    
                    datosUsuario.datosComplementarios?.append(datosComplementarios)
                }
                
                datosUsuario.tokenDevice = value?["tokenDevice"] as? String
                
                model.usuario.append(datosUsuario)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoUsuario"), object: nil)
        })
    }
    
    class func crearIdMascotaUsuario(uid:String?) -> String
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/mascotas")
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    class func loadFotoMascota(uid:String?, idMascota: String, nombreFoto: String, fotoData:Data)
    {
        let storage = Storage.storage()
        
        // Create a reference to the file you want to upload
        let path = "mascotas/\(uid!)/\(idMascota)/\(nombreFoto)"
        let ref = storage.reference(withPath: path)
        
        // Upload the file to the path
        let uploadTask = ref.putData(fotoData, metadata: nil) { metadata, error in
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
        let storage = Storage.storage()
        
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
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
        
        let newItem = ["activa":mascota.activa as AnyObject,
                       "fechaNacimiento":mascota.fechaNacimiento as AnyObject,
                       "foto": mascota.foto as AnyObject,
                       "genero":mascota.genero as AnyObject,
                       "nombre":mascota.nombre as AnyObject,
                       "raza":mascota.raza as AnyObject,
                       "tipo":mascota.tipo as AnyObject] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    class func activarMascota(uid:String?, idMascota:String?, datos:DatosComplementarios)
    {
        for mascota in datos.mascotas!
        {
            let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
            
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
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + mascota.idMascota!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func crearIdAlertaMascotaUsuario(uid:String?, idMascota:String?) -> String
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + idMascota! + "/alertas")
        let ref = refHandle.childByAutoId()
        
        return ref.key
    }
    
    class func crearEditarAlertaMascota(uid:String?, alerta:Alerta)
    {
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + alerta.idMascota! + "/alertas/" + alerta.idAlerta!)
        
        let newItem = ["activada":alerta.activada as AnyObject,
                       "fechaFin":alerta.fechaFin as AnyObject,
                       "fechaInicio": alerta.fechaInicio as AnyObject,
                       "frecuencia":alerta.frecuencia as AnyObject,
                       "hora":alerta.hora as AnyObject,
                       "nombre":alerta.nombre as AnyObject,
                       "tipoRecordatorio":alerta.tipoRecordatorio as AnyObject] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    class func desactivarAlertaMascota(uid:String?, alerta:Alerta)
    {
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + alerta.idMascota! + "/alertas/" + alerta.idAlerta!)
        
        refHandle.child("/activada").setValue(false)
        refHandle.child("/fechaFin").setValue("")
        refHandle.child("/fechaInicio").setValue("")
        refHandle.child("/hora").setValue("")
    }
    
    class func eliminarAlertaMascota(uid:String?, alerta:Alerta)
    {
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/mascotas/" + alerta.idMascota! + "/alertas/" + alerta.idAlerta!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func activarDesactivarFavorito(uid:String?, idPublicacion:String?, activo:Bool)
    {
        let refHandle = Database.database().reference().child("clientes/" + uid! + "/favoritos")
        refHandle.child("/\(idPublicacion!)").setValue(activo)
    }
    
    class func preguntarEnPublicacion(pregunta:Pregunta)
    {
        let refHandle  = Database.database().reference().child("preguntas/" + pregunta.idPregunta!)
        
        let newItem = ["fechaPregunta":pregunta.fechaPregunta as AnyObject,
                       "idCliente":pregunta.idCliente as AnyObject,
                       "idOferente": pregunta.idOferente as AnyObject,
                       "idPublicacion":pregunta.idPublicacion as AnyObject,
                       "pregunta":pregunta.pregunta as AnyObject,
                       "timestamp":ServerValue.timestamp()] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    class func agregarAlCarrito(uid:String?, carrito:Carrito)
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/carrito").childByAutoId()
        
        refHandle.child("/cantidadCompra").setValue(carrito.cantidadCompra)
        
        if carrito.servicio!
        {
            refHandle.child("/fechaHoraReserva").setValue(carrito.fechaHoraReserva)
        }
        
        refHandle.child("/idPublicacion").setValue(carrito.idPublicacion)
        refHandle.child("/servicio").setValue(carrito.servicio)
    }
    
    class func eliminarPublicacionCarrito(uid:String?, idPublicacionCarrito:String?)
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/carrito/" + idPublicacionCarrito!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func editarPublicacionCarrito(uid:String?, carrito:Carrito)
    {
        let refHandle  = Database.database().reference().child("clientes/" + uid! + "/carrito/" + carrito.idCarrito!)
        
        if carrito.servicio!
        {
            refHandle.child("/fechaHoraReserva").setValue(carrito.fechaHoraReserva)
        } else
        {
            refHandle.child("/cantidadCompra").setValue(carrito.cantidadCompra)
        }
    }
    
    class func descontarEnstock(compra:Carrito)
    {
        let refHandle = Database.database().reference().child("productos/" + (compra.idPublicacion)! + "/stock")
        
        refHandle.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let value = currentData.value as? Int {
                debugPrint("FB BEFORE \(currentData)")
                currentData.value = value - (compra.cantidadCompra)!
                debugPrint("FB AFTER \(currentData)")
                
                if (currentData.value as? Int)! > 0 || (currentData.value as? Int)! == 0
                {
                    NotificationCenter.default.post(name: Notification.Name("descuentoExitoso"), object: nil)
                    return .success(withValue: currentData)
                }else
                {
                    NotificationCenter.default.post(name: Notification.Name("descuentoFallido"), object: nil)
                    currentData.value = value
                    debugPrint("FB EMPTY \(currentData)")
                    return .success(withValue: currentData)
                }
                
            } else {
                //currentData.value = value
                debugPrint("FB EMPTY \(currentData)")
                //return .success(withValue: currentData)
            }
            
            return .success(withValue: currentData)
            
        }){ (error, committed, snapshot) in
            if let error = error
            {
                debugPrint("FB ERROR: \(error)")
            } else
            {
                debugPrint("FB COMMITTED \(snapshot)")
            }
        }
    }
    
    class func restablecerStock(compra:Carrito)
    {
        let refHandle = Database.database().reference().child("productos/" + (compra.idPublicacion)! + "/stock")
        
        refHandle.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let value = currentData.value as? Int {
                debugPrint("FB BEFORE \(currentData)")
                currentData.value = value + (compra.cantidadCompra)!
                debugPrint("FB AFTER \(currentData)")
                
                return .success(withValue: currentData)
                
            } else {
                //data.value = 1
                debugPrint("FB EMPTY \(currentData)")
                //return .success(withValue: currentData)
            }
            
            return .success(withValue: currentData)
            
        }){ (error, committed, snapshot) in
            if let error = error {
                debugPrint("FB ERROR: \(error)")
            } else {
                debugPrint("FB COMMITTED \(snapshot)")
            }
        }
    }
    
    class func realizarCompra(compra:CompraUsuario)
    {
        var refHandle:DatabaseReference! = nil
        
        if compra.idCompra == ""
        {
            refHandle  = Database.database().reference().child("compras/abiertas").childByAutoId()
            
        }else
        {
            refHandle  = Database.database().reference().child("compras/abiertas/" + compra.idCompra!)
        }
        
        var newItem = ["fecha":compra.fecha as AnyObject,
                       "idCliente":compra.idCliente as AnyObject,
                       "idOferente":compra.idOferente as AnyObject,
                       "metodoPago":compra.metodoPago as AnyObject,
                       "pedido/1/cantidad":compra.pedido?[0].cantidadCompra as AnyObject,
                       "pedido/1/estado":compra.pedido?[0].estado as AnyObject,
                       "pedido/1/idPublicacion":compra.pedido?[0].idPublicacion as AnyObject,
                       "pedido/1/reprogramada":compra.pedido?[0].reprogramada as AnyObject,
                       "pedido/1/servicio":compra.pedido?[0].servicio as AnyObject,
                       "timestamp":ServerValue.timestamp(),
                       "valor":compra.valor as AnyObject] as [String : AnyObject]
        
        if (compra.pedido?[0].servicio!)!
        {
            newItem["pedido/1/fechaServicio"] = compra.pedido?[0].fechaServicio as AnyObject
        }
        
        if compra.pedido?[0].direccion != ""
        {
            newItem["pedido/1/direccion"] = compra.pedido?[0].direccion as AnyObject
        }
        
        if compra.metodoPago == "Tarjeta"
        {
            if (compra.pedido?[0].servicio!)!
            {
                agregarPagoCliente(idCompra: refHandle.key, idTarjeta: compra.idTarjeta!, tipoCompra: "Compra Servicio")
            }else
            {
                agregarPagoCliente(idCompra: refHandle.key, idTarjeta: compra.idTarjeta!, tipoCompra: "Compra Producto")
            }
        }
        
        refHandle.updateChildValues(newItem)
        
        let mensaje = Mensaje()
        
        mensaje.idOferente = compra.idOferente
        mensaje.idCompra = refHandle.key
        mensaje.infoAdicional = compra.nombrePublicacion
        
        if (compra.pedido?[0].servicio)!
        {
            mensaje.mensaje = "¡Felicitaciones! Has vendido el servicio \(mensaje.infoAdicional!)"
        }else
        {
            mensaje.mensaje = "¡Felicitaciones! Has vendido el producto \(mensaje.infoAdicional!)"
        }
        
        mensaje.tipo = "ventaRealizada"
        mensaje.titulo = "Venta realizada"
        mensaje.token = compra.tokenDeviceOferente
        mensaje.visto = false
        
        Comando.enviarMensaje(mensaje: mensaje)
    }
    
    class func eliminarCompraDeAbierta(compra:CompraUsuario)
    {
        let refHandle  = Database.database().reference().child("compras/abiertas/" + compra.idCompra!)
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func confirmarCompra(compra:CompraUsuario)
    {
        let refHandle  = Database.database().reference().child("compras/cerradas/" + compra.idCompra!)
        
        var newItem = ["fecha":compra.fecha as AnyObject,
                       "idCliente":compra.idCliente as AnyObject,
                       "idOferente":compra.idOferente as AnyObject,
                       "metodoPago":compra.metodoPago as AnyObject,
                       "pedido/1/cantidad":compra.pedido?[0].cantidadCompra as AnyObject,
                       "pedido/1/estado":compra.pedido?[0].estado as AnyObject,
                       "pedido/1/idPublicacion":compra.pedido?[0].idPublicacion as AnyObject,
                       "pedido/1/reprogramda":compra.pedido?[0].reprogramada as AnyObject,
                       "pedido/1/servicio":compra.pedido?[0].servicio as AnyObject,
                       "timestamp":ServerValue.timestamp(),
                       "valor":compra.valor as AnyObject] as [String : AnyObject]
        
        if (compra.pedido?[0].servicio!)!
        {
            newItem["pedido/1/fechaServicio"] = compra.pedido?[0].fechaServicio as AnyObject
        }
        
        if compra.pedido?[0].direccion != ""
        {
            newItem["pedido/1/direccion"] = compra.pedido?[0].direccion as AnyObject
        }
        
        refHandle.updateChildValues(newItem)
        
        let mensaje = Mensaje()
        
        mensaje.idOferente = compra.idOferente
        mensaje.idCompra = refHandle.key
        mensaje.infoAdicional = compra.nombrePublicacion
        
        if (compra.pedido?[0].servicio)!
        {
            mensaje.mensaje = "¡Felicitaciones! Tu servicio \(mensaje.infoAdicional!) ha sido efectivo"
        }else
        {
            mensaje.mensaje = "¡Felicitaciones! Tu venta del producto \(mensaje.infoAdicional!) ha finalizado"
        }
        
        mensaje.tipo = "ventaFinalizada"
        mensaje.titulo = "Venta finalizada"
        mensaje.token = compra.tokenDeviceOferente
        mensaje.visto = false
        
        Comando.enviarMensaje(mensaje: mensaje)
    }
    
    class func getMisComprasUsuario(uid:String?)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        modelUsuario.misCompras.removeAll()
        modelUsuario.misComprasAbiertas.removeAll()
        modelUsuario.misComprasCerradas.removeAll()
        
        let refHandle  = Database.database().reference().child("compras/abiertas")
        let ref = refHandle.queryOrdered(byChild: "/idCliente").queryEqual(toValue: uid)
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            
            let miCompra = CompraUsuario()
            let postDict = snap.value as! [String : AnyObject]
            
            miCompra.fecha = postDict["fecha"] as? String
            miCompra.idCliente = postDict["idCliente"] as? String
            miCompra.idCompra = snap.key
            miCompra.idOferente = postDict["idOferente"] as? String
            miCompra.metodoPago = postDict["metodoPago"] as? String
            miCompra.timestamp = postDict["timestamp"] as? CLong
            miCompra.valor = postDict["valor"] as? Int
            
            let snapPedidos = snap.childSnapshot(forPath: "pedido")
            let pedidos = snapPedidos.children
            
            while let pedido = pedidos.nextObject() as? DataSnapshot
            {
                let pedidoCompra = PedidoUsuario()
                let postDictPedido = pedido.value as! NSDictionary
                
                pedidoCompra.idPedido = Int(pedido.key)
                pedidoCompra.cantidadCompra = postDictPedido["cantidad"] as? Int
                
                if snapPedidos.hasChild("1/direccion")
                {
                    pedidoCompra.direccion = postDictPedido["direccion"] as? String
                }
                
                pedidoCompra.estado = postDictPedido["estado"] as? String
                
                pedidoCompra.servicio = postDictPedido["servicio"] as? Bool
                
                if pedidoCompra.servicio!
                {
                    pedidoCompra.fechaServicio = postDictPedido["fechaServicio"] as? String
                }
                
                pedidoCompra.idPublicacion = postDictPedido["idPublicacion"] as? String
                
                if snapPedidos.hasChild("1/reprogramada")
                {
                    pedidoCompra.reprogramada = postDictPedido["reprogramada"] as? Bool
                }
                
                miCompra.pedido?.append(pedidoCompra)
            }
            
            /*var i = 0
            
            for compra in modelUsuario.misCompras
            {
                if compra.idCompra == miCompra.idCompra
                {
                    modelUsuario.misCompras.remove(at: i)
                }
                
                i+=1
            }*/
            
            modelUsuario.misCompras.append(miCompra)
            modelUsuario.misCompras.sort(by: {$0.timestamp! < $1.timestamp!})
            
            /*var j = 0
            
            for compra in modelUsuario.misComprasAbiertas
            {
                if compra.idCompra == miCompra.idCompra
                {
                    modelUsuario.misComprasAbiertas.remove(at: i)
                }
                
                j+=1
            }*/
            
            modelUsuario.misComprasAbiertas.append(miCompra)
            modelUsuario.misComprasAbiertas.sort(by: {$0.timestamp! > $1.timestamp!})
            
            NotificationCenter.default.post(name: Notification.Name("cargoMisComprasUsuario"), object: nil)
        })
        
        let refHandle2  = Database.database().reference().child("compras/cerradas")
        let ref2 = refHandle2.queryOrdered(byChild: "/idCliente").queryEqual(toValue: uid)
        
        ref2.observe(.childAdded, with: {(snap) -> Void in
            
            let miCompra = CompraUsuario()
            let postDict = snap.value as! [String : AnyObject]
            
            miCompra.fecha = postDict["fecha"] as? String
            miCompra.idCliente = postDict["idCliente"] as? String
            miCompra.idCompra = snap.key
            miCompra.idOferente = postDict["idOferente"] as? String
            miCompra.metodoPago = postDict["metodoPago"] as? String
            miCompra.timestamp = postDict["timestamp"] as? CLong
            miCompra.valor = postDict["valor"] as? Int
            
            let snapPedidos = snap.childSnapshot(forPath: "pedido")
            let pedidos = snapPedidos.children
            
            while let pedido = pedidos.nextObject() as? DataSnapshot
            {
                let pedidoCompra = PedidoUsuario()
                let postDictPedido = pedido.value as! NSDictionary
                
                pedidoCompra.idPedido = Int(pedido.key)
                pedidoCompra.cantidadCompra = postDictPedido["cantidad"] as? Int
                pedidoCompra.estado = postDictPedido["estado"] as? String
                pedidoCompra.servicio = postDictPedido["servicio"] as? Bool
                
                if pedidoCompra.servicio!
                {
                    pedidoCompra.fechaServicio = postDictPedido["fechaServicio"] as? String
                }
                
                if snapPedidos.hasChild("1/direccion")
                {
                    pedidoCompra.direccion = postDictPedido["direccion"] as? String
                }
                
                pedidoCompra.idPublicacion = postDictPedido["idPublicacion"] as? String
                
                miCompra.pedido?.append(pedidoCompra)
            }
            
            /*var i = 0
            
            for compra in modelUsuario.misCompras
            {
                if compra.idCompra == miCompra.idCompra
                {
                    modelUsuario.misCompras.remove(at: i)
                }
                
                i+=1
            }*/
            
            modelUsuario.misCompras.append(miCompra)
            modelUsuario.misCompras.sort(by: {$0.timestamp! < $1.timestamp!})
            
            /*var j = 0
            
            for compra in modelUsuario.misComprasCerradas
            {
                if compra.idCompra == miCompra.idCompra
                {
                    modelUsuario.misComprasCerradas.remove(at: i)
                }
                
                j+=1
            }*/
            
            modelUsuario.misComprasCerradas.append(miCompra)
            modelUsuario.misComprasCerradas.sort(by: {$0.timestamp! > $1.timestamp!})
            
            NotificationCenter.default.post(name: Notification.Name("cargoMisComprasUsuario"), object: nil)
        })
    }
    
    class func  getCalificacionesPublicaciones()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        modelUsuario.calificacionesPublicaciones.removeAll()
        
        let refHandle:DatabaseReference! = Database.database().reference().child("calificaciones")
        
        refHandle.queryOrdered(byChild: "fecha").observeSingleEvent(of: .value, with: {snap in
            
            let calificaciones = snap.children
            
            while let CalificacionChild = calificaciones.nextObject() as? DataSnapshot
            {
                let postDict = CalificacionChild.value as! [String : AnyObject]
                let calificacionCompra = Calificacion()
                
                calificacionCompra.calificacion = postDict["calificacion"] as! Int
                calificacionCompra.comentario = postDict["comentario"] as! String
                calificacionCompra.fecha = postDict["fecha"] as! String
                calificacionCompra.idCalificacion = CalificacionChild.key
                calificacionCompra.idCliente = postDict["idCliente"] as! String
                ComandoPreguntasOferente.getMiniUsuario(uid: calificacionCompra.idCliente)
                calificacionCompra.idCompra = postDict["idCompra"] as! String
                calificacionCompra.idOferente = postDict["idOferente"] as! String
                calificacionCompra.idPublicacion = postDict["idPublicacion"] as! String
                calificacionCompra.timestamp = postDict["timestamp"] as? CLong
                
                var i = 0
                
                for calificacion in modelUsuario.calificacionesPublicaciones
                {
                    if calificacion.idCalificacion == calificacionCompra.idCalificacion
                    {
                        modelUsuario.calificacionesPublicaciones.remove(at: i)
                    }
                    
                    i+=1
                }
                
                modelUsuario.calificacionesPublicaciones.append(calificacionCompra)
                modelUsuario.calificacionesPublicaciones.sort(by: {$0.timestamp! > $1.timestamp!})
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoCalificacionesPublicaciones"), object: nil)
            
        })
    }
    
    class func calificarCompra(calificacionCompra:Calificacion)
    {
        let refHandle  = Database.database().reference().child("calificaciones").childByAutoId()
        
        let newItem = ["calificacion":calificacionCompra.calificacion as AnyObject,
                       "comentario":calificacionCompra.comentario as AnyObject,
                       "fecha": calificacionCompra.fecha as AnyObject,
                       "idCliente":calificacionCompra.idCliente as AnyObject,
                       "idCompra":calificacionCompra.idCompra as AnyObject,
                       "idOferente":calificacionCompra.idOferente as AnyObject,
                       "idPublicacion":calificacionCompra.idPublicacion as AnyObject,
                       "timestamp":ServerValue.timestamp()] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    // Funciones para Tpaga
    
    class func eliminarDatosTpaga(uid:String)
    {
        let ref  = Database.database().reference().child("clientes/" + uid + "/datosTpaga")
        // Remove the post from the DB
        ref.removeValue()
        
        let refHandle  = Database.database().reference().child("clientes/" + uid + "/tarjetas" )
        // Remove the post from the DB
        refHandle.removeValue()
    }
    
    class func setIdClienteTpagaEnUsuario(uid:String, idClienteTpaga:String)
    {
        let ref  = Database.database().reference().child("clientes/" + uid + "/datosTpaga/idClienteTpaga")
        
        ref.setValue(idClienteTpaga)
    }
    
    class func setDatosTpagaEnUsuario(uid:String)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        let ref  = Database.database().reference().child("clientes/" + uid + "/datosTpaga")
        
        let newItem = ["nombres":modelUsuario.tpagaUsuario.nombre,
                       "apellidos": modelUsuario.tpagaUsuario.apellido,
                       "telefono": modelUsuario.tpagaUsuario.telefono,
                       "correo":modelUsuario.tpagaUsuario.correo] as [String : Any]
        
        ref.updateChildValues(newItem)
    }
    
    class func getDatosTPagaEnUsuario(uid:String)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        let ref  = Database.database().reference().child("clientes/" + uid + "/datosTpaga")
        
        ref.observeSingleEvent(of: .value, with: {(snap) -> Void in
            
            if snap.value as? [String : AnyObject] != nil
            {
                let value = snap.value as! [String : AnyObject]
                
                modelUsuario.tpagaUsuario.idClienteEnTpaga = value["idClienteTpaga"] as! String
                modelUsuario.tpagaUsuario.nombre = value["nombres"] as! String
                modelUsuario.tpagaUsuario.apellido = value["apellidos"] as! String
                modelUsuario.tpagaUsuario.telefono = value["telefono"] as! String
                modelUsuario.tpagaUsuario.correo = value["correo"] as! String
            }
        })
        
    }
    
    class func desactivarTarjetaEnUsuario(uid:String?, idTarjeta:String)
    {
        let ref  = Database.database().reference().child("clientes/" + uid! + "/tarjetas/" + idTarjeta + "/activo")
        
        ref.setValue(false)
    }
    
    class func crearTarjetaEnUsuario(uid:String, lastFour:String, token : String, cuotas : Int,franquicia: String , activo: Bool  ) -> String
    {
        let ref  = Database.database().reference().child("clientes/" + uid + "/tarjetas" ).childByAutoId()
        
        let newItem = ["lastFour":lastFour,
                       "cuotas": cuotas,
                       "token": token,
                       "franquicia":franquicia,
                       "activo":activo] as [String : Any]
        
        ref.setValue(newItem)
        
        return ref.key
    }
    
    class func getTarjetasEnUsuarios(uid:String)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        var ref  = Database.database().reference().child("clientes/" + uid + "/tarjetas" )
        
        ref.observe(.childAdded, with: { snap in
            
            let tarj = snap.value as! NSDictionary
            
            let mini = MiniTarjeta()
            
            mini.activa = tarj["activo"] as! Bool
            mini.cuotas = tarj["cuotas"] as! Int
            mini.numero = tarj["lastFour"] as! String
            mini.token = tarj["token"] as! String
            mini.franquicia = tarj["franquicia"] as! String
            mini.id = snap.key
            
            modelUsuario.tpagaUsuario.adicionarMiniTarjeta(mini: mini)
        })
        
        //Ademas traemos el idClienteTpaga
        ref  = Database.database().reference().child("clientes/" + uid + "/idClienteTpaga")
        
        ref.observe(.value, with: {snap in
            
            if snap.exists()
            {
                modelUsuario.tpagaUsuario.idClienteEnTpaga = snap.value as! String
            }
        })
    }
    
    class func agregarPagoCliente(idCompra:String , idTarjeta:String, tipoCompra:String)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        let tpaga = modelUsuario.tpagaUsuario
        
        let refi  = Database.database().reference().child("pagosCliente")
        let ref = refi.childByAutoId()
        
        let pago = ["authorizationCode":tpaga.authorizationCode,
                    "paymentTransaction": tpaga.paymentTransaction,
                    "idPago": tpaga.idPago,
                    "idTarjeta":idTarjeta,
                    "metodoPago":"Tarjeta",
                    "idCompra":idCompra,
                    "Descripcion":tipoCompra] as [String : Any]
        
        ref.setValue(pago, withCompletionBlock: { error, snap in
            
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name("pagoExitosoCliente"), object: nil)
                
            }else {
                print(error.debugDescription)
                print(error!.localizedDescription)
                
                NotificationCenter.default.post(name: Notification.Name("pagoFallidoCiente"), object: nil)
            }
        })
    }
    
    //Admin Tips
    class func getTipsDeUso()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        modelUsuario.tipsDeUso?.removeAll()
        
        let ref  = Database.database().reference().child("tipsDeUso")
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let snapTips = snap.value as! NSDictionary
            
            for (idTips, tip) in snapTips
            {
                let tips = Tips()
                
                tips.idTip = idTips as? String
                tips.nombreTip = tip as? String
                
                modelUsuario.tipsDeUso?.append(tips)
                
                modelUsuario.tipsDeUso?.sort { $0.idTip?.localizedCaseInsensitiveCompare($1.idTip!) == ComparisonResult.orderedAscending }
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoTipsDeUso"), object: nil)
            
        });
    }
    
    // Admin Ayuda PQRS
    
    class func generarNumeroSeguimiento(tipoSolicitud:TipoSolicitud)
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        let refHandle = Database.database().reference().child("listados/tiposSolicitudes/" + tipoSolicitud.idTipoSolicitud! + "/consecutivo")
        
        refHandle.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if let value = currentData.value as? Int
            {
                debugPrint("FB BEFORE \(currentData)")
                currentData.value = value + 1
                
                var zeroString:String = ""
                
                if (currentData.value as? Int)! < 10
                {
                    zeroString = "0000"
                }else
                {
                    if (currentData.value as? Int)! < 100
                    {
                        zeroString = "000"
                    }else
                    {
                        if (currentData.value as? Int)! < 1000
                        {
                            zeroString = "00"
                        }else
                        {
                            if (currentData.value as? Int)! < 10000
                            {
                                zeroString = "0"
                            }else
                            {
                                zeroString = ""
                            }
                        }
                    }
                }
                
                modelUsuario.miSolicitud.numeroSeguimiento = "\(tipoSolicitud.siglaConsecutivo!)\(zeroString)\(currentData.value!)"
                debugPrint("FB AFTER \(currentData)")
                NotificationCenter.default.post(name: Notification.Name("generacionExitosa"), object: nil)
                return .success(withValue: currentData)
                
            } else {
                //data.value = 1
                debugPrint("FB EMPTY \(currentData)")
                //return .success(withValue: currentData)
            }
            
            return .success(withValue: currentData)
            
        }){ (error, committed, snapshot) in
            if let error = error {
                debugPrint("FB ERROR: \(error)")
            } else {
                debugPrint("FB COMMITTED \(snapshot)")
            }
        }
    }
    
    class func enviarSolicitud(solicitud:SolicitudCliente)
    {
        let refHandle  = Database.database().reference().child("solicitudes").childByAutoId()
        
        let newItem = ["enunciado":solicitud.enunciado as AnyObject,
                       "estado":solicitud.estado as AnyObject,
                       "fechaGeneracion": solicitud.fechaGeneracion as AnyObject,
                       "idCliente":solicitud.idCliente as AnyObject,
                       "numeroSeguimiento":solicitud.numeroSeguimiento as AnyObject,
                       "tipoSolicitud":solicitud.tipoSolicitud as AnyObject,
                       "timestamp":ServerValue.timestamp()] as [String : AnyObject]
        
        refHandle.updateChildValues(newItem)
    }
    
    class func getMisSolicitudes()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        modelUsuario.misSolicitudes.removeAll()
        
        let refHandle  = Database.database().reference().child("solicitudes")
        let ref = refHandle.queryOrdered(byChild: "/idCliente").queryEqual(toValue: modelUsuario.idUsuario)
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            
            let miSolicitud = SolicitudCliente()
            let postDict = snap.value as! [String : AnyObject]
            
            miSolicitud.enunciado = postDict["enunciado"] as? String
            miSolicitud.estado = postDict["estado"] as? String
            miSolicitud.fechaGeneracion = postDict["fechaGeneracion"] as? String
            
            if snap.hasChild("fechaRespuesta")
            {
                miSolicitud.fechaRespuesta = postDict["fechaRespuesta"] as? String
            }
            
            miSolicitud.idCliente = postDict["idCliente"] as? String
            miSolicitud.idSolicitud = snap.key
            miSolicitud.numeroSeguimiento = postDict["numeroSeguimiento"] as? String
            
            if snap.hasChild("respuesta")
            {
                miSolicitud.respuesta = postDict["respuesta"] as? String
            }
            
            miSolicitud.timestamp = postDict["timestamp"] as? CLong
            miSolicitud.tipoSolicitud = postDict["tipoSolicitud"] as? String
            
            modelUsuario.misSolicitudes.append(miSolicitud)
            modelUsuario.misSolicitudes.sort(by: {$0.timestamp! < $1.timestamp!})
            
            NotificationCenter.default.post(name: Notification.Name("cargoMisSolicitudes"), object: nil)
        })
    }
}





































