//
//  ComandoOferente.swift
//  MyPet
//
//  Created by Jose Aguilar on 9/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase

class ComandoOferente
{
    class func crearOferente(uid:String, registro:Oferente)
    {
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid)
        
        var newItem = ["aprobacionMyPet":registro.aprobacionMyPet as AnyObject,
                       "celular":registro.celular as AnyObject,
                       "correo": registro.correo as AnyObject,
                       "direccion":registro.direccion as AnyObject,
                       "nit":registro.nit as AnyObject,
                       "razonSocial":registro.razonSocial as AnyObject,
                       "telefono":registro.telefono as AnyObject] as [String : AnyObject]
        
        for contacto in registro.contactoPrincipal!
        {
            let contactoPrincipal = ["celular" : contacto.celular as AnyObject,
                                     "correo" : contacto.correo as AnyObject,
                                     "documento": contacto.documento as AnyObject,
                                     "nombre": contacto.nombre as AnyObject,
                                     "telefono": contacto.telefono as AnyObject,
                                     "tipoDocumento" : contacto.tipoDocumento as AnyObject] as [String : AnyObject]
            
            newItem["contactoPrincipal"] = contactoPrincipal as AnyObject
        }
        
        for horarioRegistro in registro.horario!
        {
            let horario = ["dias" : horarioRegistro.dias as AnyObject,
                           "horaCierre" : horarioRegistro.horaCierre as AnyObject,
                           "horaInicio" : horarioRegistro.horaInicio as AnyObject] as [String : AnyObject]
            
            newItem["horario/\(horarioRegistro.nombreArbol as AnyObject)"] = horario as AnyObject
        }
        
        if registro.paginaWeb != ""
        {
            newItem["paginaWeb"] = registro.paginaWeb as AnyObject
        }
        
        for ubicacionRegistro in registro.ubicacion!
        {
            let ubicacion = ["lat" : ubicacionRegistro.latitud as AnyObject,
                             "lon" : ubicacionRegistro.longitud as AnyObject] as [String : AnyObject]
            
            newItem["ubicacion"] = ubicacion as AnyObject
        }
        
        ref.updateChildValues(newItem)
        
    }
    
    class func getOferente(uid:String?)
    {
        if uid == nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoOferente"), object: nil)
        }
        
        let model  = ModeloOferente.sharedInstance
        model.oferente.removeAll()
        
        let datosOferente = Oferente()
        let datosContactoOferente = ContactoPrincipal()
        let datosUbicacionOferente = Ubicacion()
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid!)
        
        ref.observeSingleEvent(of: .value, with: {snap in
            
            let value = snap.value as? NSDictionary
            
            datosOferente.correo = value?["correo"] as? String
            
            if datosOferente.correo != nil
            {
                datosOferente.aprobacionMyPet = value?["aprobacionMyPet"] as? String
                datosOferente.celular = value?["celular"] as? String
                
                let snapContacto = snap.childSnapshot(forPath: "contactoPrincipal")
                let valContacto = snapContacto.value as? NSDictionary
                
                datosContactoOferente.celular = valContacto?["celular"] as? String
                datosContactoOferente.correo = valContacto?["correo"] as? String
                datosContactoOferente.documento = valContacto?["documento"] as? String
                datosContactoOferente.nombre = valContacto?["nombre"] as? String
                datosContactoOferente.telefono = valContacto?["telefono"] as? String
                datosContactoOferente.tipoDocumento = valContacto?["tipoDocumento"] as? String
                
                datosOferente.contactoPrincipal?.append(datosContactoOferente)
                
                datosOferente.direccion = value?["direccion"] as? String
                
                if snap.hasChild("horario")
                {
                    let snapHorario = snap.childSnapshot(forPath: "horario").value as! NSDictionary
                    
                    var i = 0
                    
                    for (idHorario, horario) in snapHorario
                    {
                        let postDictHorario = (horario as! [String : AnyObject])
                        
                        if (idHorario as? String == "Semana")
                        {
                            model.horarioSemana.dias = postDictHorario["dias"] as? String
                            model.horarioSemana.horaInicio = postDictHorario["horaInicio"] as? String
                            model.horarioSemana.horaCierre = postDictHorario["horaCierre"] as? String
                            model.horarioSemana.nombreArbol = idHorario as? String
                            
                        }
                        
                        if (idHorario as? String == "FinDeSemana")
                        {
                            model.horarioFestivo.dias = postDictHorario["dias"] as? String
                            model.horarioFestivo.horaInicio = postDictHorario["horaInicio"] as? String
                            model.horarioFestivo.horaCierre = postDictHorario["horaCierre"] as? String
                            model.horarioFestivo.nombreArbol = idHorario as? String
                        }
                        
                        i += 1
                    }
                }
                
                datosOferente.nit = value?["nit"] as? String
                
                if snap.hasChild("paginaWeb")
                {
                    datosOferente.paginaWeb = value?["paginaWeb"] as? String
                }
                
                datosOferente.razonSocial = value?["razonSocial"] as? String
                datosOferente.telefono = value?["telefono"] as? String
                
                let snapUbicacion = snap.childSnapshot(forPath: "ubicacion")
                let valUbicacion = snapUbicacion.value as? NSDictionary
                
                datosUbicacionOferente.latitud = valUbicacion?["lat"] as? Double
                datosUbicacionOferente.longitud = valUbicacion?["lon"] as? Double
                
                datosOferente.ubicacion?.append(datosUbicacionOferente)
                
                model.oferente.append(datosOferente)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoOferente"), object: nil)
        })
        
    }
    
    class func actualizarOferente(uid:String, registro:Oferente)
    {
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid)
        
        var newItem = ["aprobacionMyPet":registro.aprobacionMyPet as AnyObject,
                       "celular":registro.celular as AnyObject,
                       "correo": registro.correo as AnyObject,
                       "direccion":registro.direccion as AnyObject,
                       "nit":registro.nit as AnyObject,
                       "razonSocial":registro.razonSocial as AnyObject,
                       "telefono":registro.telefono as AnyObject] as [String : AnyObject]
        
        for contacto in registro.contactoPrincipal!
        {
            let contactoPrincipal = ["celular" : contacto.celular as AnyObject,
                                     "documento": contacto.documento as AnyObject,
                                     "nombre": contacto.nombre as AnyObject,
                                     "telefono": contacto.telefono as AnyObject,
                                     "tipoDocumento" : contacto.tipoDocumento as AnyObject] as [String : AnyObject]
            
            newItem["contactoPrincipal"] = contactoPrincipal as AnyObject
        }
        
        if registro.paginaWeb != ""
        {
            newItem["paginaWeb"] = registro.paginaWeb as AnyObject
        }
        
        for ubicacionRegistro in registro.ubicacion!
        {
            let ubicacion = ["lat" : ubicacionRegistro.latitud as AnyObject,
                             "lon" : ubicacionRegistro.longitud as AnyObject] as [String : AnyObject]
            
            newItem["ubicacion"] = ubicacion as AnyObject
        }
        
        ref.setValue(newItem)
        
        for horarioRegistro in registro.horario!
        {
            let horario = ["dias" : horarioRegistro.dias as AnyObject,
                           "horaCierre" : horarioRegistro.horaCierre as AnyObject,
                           "horaInicio" : horarioRegistro.horaInicio as AnyObject] as [String : AnyObject]
            
            ref.child("/horario/\(horarioRegistro.nombreArbol as AnyObject)").setValue(horario)
        }
        
    }
    
    
    class func setIdClienteTpaga(uid:String, idClienteTpaga:String) {
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid + "/datosTpaga/idClienteTpaga")
        
        ref.setValue(idClienteTpaga)
        
    }
    
    class func setDatosTpaga(uid:String) {
        
        let model = ModeloOferente.sharedInstance
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid + "/datosTpaga")
        
        let newItem = ["nombres":model.tpaga.nombre,
                       "apellidos": model.tpaga.apellido,
                       "telefono": model.tpaga.telefono,
                       "correo":model.tpaga.correo] as [String : Any]

        
        ref.updateChildValues(newItem)
        
    }
    
    
    
    class func getDatosTPaga(uid:String) {
        
        let model = ModeloOferente.sharedInstance
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid + "/datosTpaga")
        
        ref.observe(.value, with: {(snap) -> Void in
            
            
            let value = snap.value as! [String : AnyObject]
            
            model.tpaga.idClienteEnTpaga = value["idClienteTpaga"] as! String
            model.tpaga.nombre = value["nombres"] as! String
            model.tpaga.apellido = value["apellidos"] as! String
            model.tpaga.telefono = value["telefono"] as! String
            model.tpaga.correo = value["correo"] as! String
            
        })
        
    }
    
    
    class func desactivarTarjeta(uid:String?, idTarjeta:String) {
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid! + "/tarjetas/" + idTarjeta + "/activo")
        ref.setValue(false)
        
    }
    
    class func crearTarjeta(uid:String, lastFour:String, token : String, cuotas : Int,franquicia: String , activo: Bool  ) -> String{
        
        
        
        let ref  = FIRDatabase.database().reference().child("oferentes/" + uid + "/tarjetas" ).childByAutoId()
        
        
        let newItem = ["lastFour":lastFour,
                       "cuotas": cuotas,
                       "token": token,
                       "franquicia":franquicia,
                       "activo":activo] as [String : Any]
        
        
        ref.setValue(newItem)
        
        return ref.key
        
    }
    
    
    class func getTarjetas(uid:String) {
        
        let model = ModeloOferente.sharedInstance
        var ref  = FIRDatabase.database().reference().child("oferentes/" + uid + "/tarjetas" )
        
        ref.observe(.childAdded, with: { snap in
            
            let tarj = snap.value as! NSDictionary
            
            let mini = MiniTarjeta()
            mini.activa = tarj["activo"] as! Bool
            mini.cuotas = tarj["cuotas"] as! Int
            mini.numero = tarj["lastFour"] as! String
            mini.token = tarj["token"] as! String
            mini.franquicia = tarj["franquicia"] as! String
            mini.id = snap.key
            model.tpaga.adicionarMiniTarjeta(mini: mini)
            
            
        })
        
        //Ademas traemos el idClienteTpaga
        ref  = FIRDatabase.database().reference().child("clientes/" + uid + "/idClienteTpaga")
        
        ref.observe(.value, with: {snap in
            
            if snap.exists() {
                model.tpaga.idClienteEnTpaga = snap.value as! String
            }
        })
        
        
    }
    
    
    class func activarDestacado( idPublicacion:String , idTarjeta:String){
        
        let model = ModeloOferente.sharedInstance
        let tpaga = model.tpaga
        
        let refi  = FIRDatabase.database().reference().child("pagosOferente")
        let ref = refi.childByAutoId()
        
        
        
        
        let pago = ["authorizationCode":tpaga.authorizationCode,
                    "paymentTransaction": tpaga.paymentTransaction,
                    "idPago": tpaga.idPago,
                    "idTarjeta":idTarjeta,
                    "metodoPago":"Tarjeta",
                    "idPublicacion":idPublicacion,
                    "Descripcion":"Destacado"] as [String : Any]
        
        
        
        
        
        ref.setValue(pago, withCompletionBlock: { error, snap in
            
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name("pagoExitoso"), object: nil)
                
            }else {
                print(error.debugDescription)
                print(error!.localizedDescription)
                
                NotificationCenter.default.post(name: Notification.Name("pagoFallido"), object: nil)
            }
            
            
        })
        
        
    }

    
    
    
}
