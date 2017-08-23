//
//  Modelo.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation

class Sistema
{
    var version = "1.0"
    var build = 0
    var link = ""
    var updateMandatorio = false
    var capacidadCopada = false
    var activarAlertasHorario = true
}

class TiposMascota
{
    var nombreTipo:String?  = ""
}

class RazasPerro
{
    var nombreRaza:String?  = ""
}

class RazasGato
{
    var nombreRaza:String?  = ""
}

class TipoRecordatorio
{
    var nombreTipo:String?  = ""
}

class FrecuenciaRecordatorio
{
    var nombreFrecuencia:String?  = ""
}

class Pregunta
{
    var fechaPregunta:String?  = ""
    var fechaRespuesta:String?  = ""
    var idCliente:String?  = ""
    var idOferente:String?  = ""
    var idPregunta:String?  = ""
    var idPublicacion:String?  = ""
    var pregunta:String?  = ""
    var respuesta:String?  = ""
    var timestamp:CLong?
    
    
    func tieneRespuesta() -> Bool {
    
        if respuesta != "" {
            return true
        }

        return false
        
    }
    
}

class Modelo
{
    static let sharedInstance:Modelo =
    {
        let instance = Modelo()
        //Codigo adicional de setup
        
        return instance
    }()
    
    // Datos Publicaciones
    var publicacionesFavoritas = [PublicacionOferente]()
    
    var publicacionesDestacadas = [PublicacionOferente]()
    
    var publicacionesPopulares = [PublicacionOferente]()
    
    var publicacionesParaAve = [PublicacionOferente]()
    var publicacionesParaExotico = [PublicacionOferente]()
    var publicacionesParaGato = [PublicacionOferente]()
    var publicacionesParaPerro = [PublicacionOferente]()
    var publicacionesParaPez = [PublicacionOferente]()
    var publicacionesParaRoedor = [PublicacionOferente]()
    
    var publicacionesAccesorios = [PublicacionOferente]()
    var publicacionesAccesoriosParaAve = [PublicacionOferente]()
    var publicacionesAccesoriosParaExotico = [PublicacionOferente]()
    var publicacionesAccesoriosParaGato = [PublicacionOferente]()
    var publicacionesAccesoriosParaPerro = [PublicacionOferente]()
    var publicacionesAccesoriosParaPez = [PublicacionOferente]()
    var publicacionesAccesoriosParaRoedor = [PublicacionOferente]()
    
    var publicacionesEsteticaHigiene = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaAve = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaExotico = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaGato = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaPerro = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaPez = [PublicacionOferente]()
    var publicacionesEsteticaHigieneParaRoedor = [PublicacionOferente]()
    
    var publicacionesFuneraria = [PublicacionOferente]()
    var publicacionesFunerariaParaAve = [PublicacionOferente]()
    var publicacionesFunerariaParaExotico = [PublicacionOferente]()
    var publicacionesFunerariaParaGato = [PublicacionOferente]()
    var publicacionesFunerariaParaPerro = [PublicacionOferente]()
    var publicacionesFunerariaParaPez = [PublicacionOferente]()
    var publicacionesFunerariaParaRoedor = [PublicacionOferente]()
    
    var publicacionesGuarderia = [PublicacionOferente]()
    var publicacionesGuarderiaParaAve = [PublicacionOferente]()
    var publicacionesGuarderiaParaExotico = [PublicacionOferente]()
    var publicacionesGuarderiaParaGato = [PublicacionOferente]()
    var publicacionesGuarderiaParaPerro = [PublicacionOferente]()
    var publicacionesGuarderiaParaPez = [PublicacionOferente]()
    var publicacionesGuarderiaParaRoedor = [PublicacionOferente]()
    
    var publicacionesMedicamentos = [PublicacionOferente]()
    var publicacionesMedicamentosParaAve = [PublicacionOferente]()
    var publicacionesMedicamentosParaExotico = [PublicacionOferente]()
    var publicacionesMedicamentosParaGato = [PublicacionOferente]()
    var publicacionesMedicamentosParaPerro = [PublicacionOferente]()
    var publicacionesMedicamentosParaPez = [PublicacionOferente]()
    var publicacionesMedicamentosParaRoedor = [PublicacionOferente]()
    
    var publicacionesNutricion = [PublicacionOferente]()
    var publicacionesNutricionParaAve = [PublicacionOferente]()
    var publicacionesNutricionParaExotico = [PublicacionOferente]()
    var publicacionesNutricionParaGato = [PublicacionOferente]()
    var publicacionesNutricionParaPerro = [PublicacionOferente]()
    var publicacionesNutricionParaPez = [PublicacionOferente]()
    var publicacionesNutricionParaRoedor = [PublicacionOferente]()
    
    var publicacionesPaseador = [PublicacionOferente]()
    var publicacionesPaseadorParaAve = [PublicacionOferente]()
    var publicacionesPaseadorParaExotico = [PublicacionOferente]()
    var publicacionesPaseadorParaGato = [PublicacionOferente]()
    var publicacionesPaseadorParaPerro = [PublicacionOferente]()
    var publicacionesPaseadorParaPez = [PublicacionOferente]()
    var publicacionesPaseadorParaRoedor = [PublicacionOferente]()
    
    var publicacionesSalud = [PublicacionOferente]()
    var publicacionesSaludParaAve = [PublicacionOferente]()
    var publicacionesSaludParaExotico = [PublicacionOferente]()
    var publicacionesSaludParaGato = [PublicacionOferente]()
    var publicacionesSaludParaPerro = [PublicacionOferente]()
    var publicacionesSaludParaPez = [PublicacionOferente]()
    var publicacionesSaludParaRoedor = [PublicacionOferente]()
    
    var publicacionesPorCategoria = [PublicacionOferente]()
    var publicacionesPorCategoriaPorMascota = [PublicacionOferente]()
    
    var publicacionSeleccionada = PublicacionOferente()
    
    var publicacionesEnCarrito = [Carrito]()
    
    // Datos Preguntas y Respuestas
    var preguntasPublicacion = [Pregunta]()
    
    // Datos Mascota
    var tiposMascota = [TiposMascota]()
    var razasPerro = [RazasPerro]()
    var razasGato = [RazasGato]()
    
    // Datos Alertas
    var tiposRecordatorio = [TipoRecordatorio]()
    var frecuenciasRecordatorio = [FrecuenciaRecordatorio]()
    
    // Datos Sistema
    var myApp = Sistema()
    var sistema = Sistema()
    
    // La idea es guardar en este mismo cache las imagenes tanto de cliente como de oferente.
    let cache = NSCache<NSString, NSData>()
    
    func existeActualizacion() -> Bool
    {
        let dictionary = Bundle.main.infoDictionary!
        myApp.version = dictionary["CFBundleShortVersionString"] as! String
        myApp.build = Int(dictionary["CFBundleVersion"] as! String)!
        
        if sistema.version.compare(myApp.version, options: NSString.CompareOptions .numeric) == ComparisonResult.orderedDescending
        {
            return true
        }
        
        if myApp.version == sistema.version  && myApp.build < sistema.build
        {
            return true
        }
        
        return false
        
    }
    
    
    
    // MARK: Imagenes
    func getVersionFirebase(de imagen:ImageFire) -> Int {
        
        return 0
        
    }
    
    
}

extension Date
{
    func horaString() -> String
    {
        //let newfecha  = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    
    
    /*func fechaString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }*/
}

