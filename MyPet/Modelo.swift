//
//  Modelo.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import UIKit

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


class PreguntaFrecuente
{
    var idPregunta:String?  = ""
    var pregunta:String = ""
    var respuesta:String = ""
    
    var cadenaBusqueda:String  {
        return pregunta + " " + respuesta
    }

}

class Mensaje
{
    var idCompra:String?  = ""
    var idCliente:String?  = ""
    var idMensaje:String?  = ""
    var idOferente:String?  = ""
    var idPublicacion:String?  = ""
    var infoAdicional:String?  = ""
    var mensaje:String?  = ""
    var timestamp:CLong?
    var titulo:String?  = ""
    var tipo:String?  = ""
    var token:String?  = ""
    var visto:Bool?
}

class ChatCompraVenta
{
    var emisor:String?  = ""
    var fechaMensaje:String?  = ""
    var idCompra:String?  = ""
    var idChat:String?  = ""
    var mensaje:String?  = ""
    var receptor:String?  = ""
    var timestamp:CLong?
    var visto:Bool?
}

class TipoSolicitud
{
    var consecutivo:Int?  = 0
    var idTipoSolicitud:String?  = ""
    var nombre:String?  = ""
    var siglaConsecutivo:String?  = ""
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
    var publicacionesGeneral = [PublicacionOferente]()
    var publicacionesPopulares = [PublicacionOferente]()
    
    var publicacionesDestacadas = [PublicacionOferente]()
    
    func getPublicacionesDestacadas()
    {
        publicacionesDestacadas.removeAll()
        
        for publicacion in publicacionesPopulares
        {
            if (publicacion.destacado!)
            {
                publicacionesDestacadas.append(publicacion)
            }
        }
    }
    
    var publicacionesFavoritas = [PublicacionOferente]()
    
    func getPublicacionesFavoritas()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        
        publicacionesFavoritas.removeAll()
        
        if modelUsuario.usuario.count != 0
        {
            if modelUsuario.usuario[0].datosComplementarios?.count != 0
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].favoritos?.count != 0
                {
                    for favorito in (modelUsuario.usuario[0].datosComplementarios?[0].favoritos)!
                    {
                        for publicacion in publicacionesPopulares
                        {
                            if favorito.idPublicacion == publicacion.idPublicacion
                            {
                                if favorito.activo!
                                {
                                    publicacionesFavoritas.append(publicacion)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
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
    
    func getPublicacionesPorCategoriaPorMascota()
    {
        publicacionesParaAve.removeAll()
        publicacionesParaExotico.removeAll()
        publicacionesParaGato.removeAll()
        publicacionesParaPerro.removeAll()
        publicacionesParaPez.removeAll()
        publicacionesParaRoedor.removeAll()
        
        publicacionesAccesorios.removeAll()
        publicacionesAccesoriosParaAve.removeAll()
        publicacionesAccesoriosParaExotico.removeAll()
        publicacionesAccesoriosParaGato.removeAll()
        publicacionesAccesoriosParaPerro.removeAll()
        publicacionesAccesoriosParaPez.removeAll()
        publicacionesAccesoriosParaRoedor.removeAll()
        
        publicacionesEsteticaHigiene.removeAll()
        publicacionesEsteticaHigieneParaAve.removeAll()
        publicacionesEsteticaHigieneParaExotico.removeAll()
        publicacionesEsteticaHigieneParaGato.removeAll()
        publicacionesEsteticaHigieneParaPerro.removeAll()
        publicacionesEsteticaHigieneParaPez.removeAll()
        publicacionesEsteticaHigieneParaRoedor.removeAll()
        
        publicacionesFuneraria.removeAll()
        publicacionesFunerariaParaAve.removeAll()
        publicacionesFunerariaParaExotico.removeAll()
        publicacionesFunerariaParaGato.removeAll()
        publicacionesFunerariaParaPerro.removeAll()
        publicacionesFunerariaParaPez.removeAll()
        publicacionesFunerariaParaRoedor.removeAll()
        
        publicacionesGuarderia.removeAll()
        publicacionesGuarderiaParaAve.removeAll()
        publicacionesGuarderiaParaExotico.removeAll()
        publicacionesGuarderiaParaGato.removeAll()
        publicacionesGuarderiaParaPerro.removeAll()
        publicacionesGuarderiaParaPez.removeAll()
        publicacionesGuarderiaParaRoedor.removeAll()
        
        publicacionesMedicamentos.removeAll()
        publicacionesMedicamentosParaAve.removeAll()
        publicacionesMedicamentosParaExotico.removeAll()
        publicacionesMedicamentosParaGato.removeAll()
        publicacionesMedicamentosParaPerro.removeAll()
        publicacionesMedicamentosParaPez.removeAll()
        publicacionesMedicamentosParaRoedor.removeAll()
        
        publicacionesNutricion.removeAll()
        publicacionesNutricionParaAve.removeAll()
        publicacionesNutricionParaExotico.removeAll()
        publicacionesNutricionParaGato.removeAll()
        publicacionesNutricionParaPerro.removeAll()
        publicacionesNutricionParaPez.removeAll()
        publicacionesNutricionParaRoedor.removeAll()
        
        publicacionesPaseador.removeAll()
        publicacionesPaseadorParaAve.removeAll()
        publicacionesPaseadorParaExotico.removeAll()
        publicacionesPaseadorParaGato.removeAll()
        publicacionesPaseadorParaPerro.removeAll()
        publicacionesPaseadorParaPez.removeAll()
        publicacionesPaseadorParaRoedor.removeAll()
        
        publicacionesSalud.removeAll()
        publicacionesSaludParaAve.removeAll()
        publicacionesSaludParaExotico.removeAll()
        publicacionesSaludParaGato.removeAll()
        publicacionesSaludParaPerro.removeAll()
        publicacionesSaludParaPez.removeAll()
        publicacionesSaludParaRoedor.removeAll()
        
        for publicacion in publicacionesPopulares
        {
            if publicacion.categoria == "Accesorios"
            {
                publicacionesAccesorios.append(publicacion)
            }
            
            if publicacion.categoria == "Lind@ y Limpi@"
            {
                publicacionesEsteticaHigiene.append(publicacion)
            }
            
            if publicacion.categoria == "Amiguitos en el cielo"
            {
                publicacionesFuneraria.append(publicacion)
            }
            
            if publicacion.categoria == "Guardería 5 patas"
            {
                publicacionesGuarderia.append(publicacion)
            }
            
            if publicacion.categoria == "Medicamentos"
            {
                publicacionesMedicamentos.append(publicacion)
            }
            
            if publicacion.categoria == "Nutrición"
            {
                publicacionesNutricion.append(publicacion)
            }
            
            if publicacion.categoria == "Paseador"
            {
                publicacionesPaseador.append(publicacion)
            }
            
            if publicacion.categoria == "Vamos al médico"
            {
                publicacionesSalud.append(publicacion)
            }
            
            var tipoMascotas = ModeloOferente.sharedInstance.tipoMascotas
            
            if tipoMascotas == nil {
                
                tipoMascotas = TipoMascotas()
            }
            
            tipoMascotas?.adicionarMascota(mascotas: publicacion.target!)
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .perro))!
            {
                publicacionesParaPerro.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaPerro.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaPerro.append(publicacion)
                }
            }
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .gato))!
            {
                publicacionesParaGato.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaGato.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaGato.append(publicacion)
                }
            }
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .ave))!
            {
                publicacionesParaAve.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaAve.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaAve.append(publicacion)
                }
            }
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .pez))!
            {
                publicacionesParaPez.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaPez.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaPez.append(publicacion)
                }
            }
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .roedor))!
            {
                publicacionesParaRoedor.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaRoedor.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaRoedor.append(publicacion)
                }
            }
            
            if (tipoMascotas?.esMascotaIncluido(miMascota: .exotico))!
            {
                publicacionesParaExotico.append(publicacion)
                
                if publicacion.categoria == "Accesorios"
                {
                    publicacionesAccesoriosParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Lind@ y Limpi@"
                {
                    publicacionesEsteticaHigieneParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Amiguitos en el cielo"
                {
                    publicacionesFunerariaParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Guardería 5 patas"
                {
                    publicacionesGuarderiaParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Medicamentos"
                {
                    publicacionesMedicamentosParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Nutrición"
                {
                    publicacionesNutricionParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Paseador"
                {
                    publicacionesPaseadorParaExotico.append(publicacion)
                }
                
                if publicacion.categoria == "Vamos al médico"
                {
                    publicacionesSaludParaExotico.append(publicacion)
                }
            }
        }
    }
    
    var publicacionSeleccionada = PublicacionOferente()
    
    var publicacionesEnCarrito = [Carrito]()
    
    func getPublicacionesEnCarrito()
    {
        let modelUsuario = ModeloUsuario.sharedInstance
        publicacionesEnCarrito.removeAll()
        
        if modelUsuario.usuario.count != 0
        {
            if modelUsuario.usuario[0].datosComplementarios?.count != 0
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].carrito?.count != 0
                {
                    for publicacion in publicacionesPopulares
                    {
                        for publicacionCarrito in (modelUsuario.usuario[0].datosComplementarios?[0].carrito)!
                        {
                            if publicacionCarrito.idPublicacion == publicacion.idPublicacion
                            {
                                publicacionCarrito.publicacionCompra = publicacion
                                
                                publicacionesEnCarrito.append(publicacionCarrito)
                            }
                        }
                    }
                }
            }
        }
    }
    
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
    func getVersionFirebase(de imagen:ImageFire) -> Int
    {
        return 0
    }
    
    // Notificaciones
    var notificacionesOferente = [Mensaje]()
    var notificacionesUsuario = [Mensaje]()
    
    func getPublicacion(idPublicacion:String) -> PublicacionOferente?
    {
        for publicacion in publicacionesGeneral
        {
            if publicacion.idPublicacion == idPublicacion
            {
                return publicacion
            }
        }
        
        return nil
    }
    
    // Chat Compras/Ventas
    
    var chatsCompraVenta = [ChatCompraVenta]()
    
    // Solicitudes
    
    var tiposSolicitudes = [TipoSolicitud]()
    var tipoSolicitud = TipoSolicitud()
    
    func getTipoSolicitud(idTipo:String) -> TipoSolicitud?
    {
        for tipoSolicitud in tiposSolicitudes
        {
            if tipoSolicitud.idTipoSolicitud == idTipo
            {
                return tipoSolicitud
            }
        }
        
        return nil
    }
    
    // Estado Oferentes
    
    var estadoOferentes = [Oferente]()
    
    func getEstadoOferente(idOferente:String) -> String
    {
        var estado = ""
        
        for oferente in estadoOferentes
        {
            if oferente.idOferente == idOferente
            {
                estado = oferente.aprobacionMyPet!
            }
        }
        
        return estado
    }
}

extension Date
{
    func horaString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func fechaCompletaString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

extension UILabel
{
    private struct AssociatedKeys
    {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}

