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
}
