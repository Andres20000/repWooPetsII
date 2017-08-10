//
//  ModeloOferente.swift
//  MyPet
//
//  Created by Jose Aguilar on 5/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation

class Oferente
{
    var aprobacionMyPet:String?  = ""
    var celular:String?  = ""
    var contactoPrincipal:[ContactoPrincipal]? = []
    var correo:String?  = ""
    var direccion:String?  = ""
    var horario:[Horario]? = []
    var nit:String?  = ""
    var paginaWeb:String?  = ""
    
    var tienePaginaWeb:Bool
    {
        if paginaWeb == nil
        {
            return false
        }
        return true
    }
    
    var razonSocial:String?  = ""
    var telefono:String?  = ""
    var ubicacion:[Ubicacion]? = []
}

class Ubicacion
{
    var latitud:Double?
    var longitud:Double?
}

enum Dias:Int
{
    case domingo = 1
    case lunes
    case martes
    case miercoles
    case jueves
    case viernes
    case sabado
    case festivos
    
    func descripcionLarga() -> String
    {
        switch self {
        case .lunes:
            return "Lunes"
        case .martes:
            return "Martes"
        case .miercoles:
            return "Miércoles"
        case .jueves:
            return "Jueves"
        case .viernes:
            return "Viernes"
        case .sabado:
            return "Sábado"
        case .domingo:
            return "Domingo"
        case .festivos:
            return "Festivos"
            
        /*default:
            return ""*/
        }
    }
    
    func descripcionCorta() -> String
    {
        switch self {
        case .lunes:
            return "Lun"
        case .martes:
            return "Mar"
        case .miercoles:
            return "Mie"
        case .jueves:
            return "Jue"
        case .viernes:
            return "Vie"
        case .sabado:
            return "Sab"
        case .domingo:
            return "Dom"
        case .festivos:
            return "Fes"
            
        /*default:
            return ""*/
        }
    }
}

class HorarioAtencion
{
    var dias:[Dias] = []
    
    init (){
        
    }
    
    //dias es en realidad todos los dias separados por coma
    func adicionarDia(dias:String)
    {
        let losDias = dias.components(separatedBy: ", ")
        
        for dia in losDias
        {
            switch dia
            {
            case "Lunes":
                self.dias.append(.lunes)
            case "Martes":
                self.dias.append(.martes)
            case "Miércoles":
                self.dias.append(.miercoles)
            case "Jueves":
                self.dias.append(.jueves)
            case "Viernes":
                self.dias.append(.viernes)
            case "Sábado":
                self.dias.append(.sabado)
            case "Domingo":
                self.dias.append(.domingo)
            case "Festivos":
                self.dias.append(.festivos)
                
            default:
                print("")
            }
        }
    }
    
    func getDiasPegadosParaFirebase() -> String
    {
        var res = ""
        
        for dia in dias {
            
            res = res + dia.descripcionLarga() + ","
        }
        
        return res
    }
    
    func getDiasPegadosCortos() -> String
    {
        var res = ""
        
        for dia in dias {
            
            res = res + dia.descripcionCorta() + ","
        }
        
        res.characters.removeLast()
        
        return res
    }
    
    func getDiasPegadosLargos() -> String
    {
        var res = ""
        
        for dia in dias {
            
            res = res + dia.descripcionLarga() + ", "
        }
        res.characters.removeLast()
        res.characters.removeLast()
        
        return res
    }
    
    func esDiaIncluido(miDia:Dias) -> Bool
    {
        for dia in dias {
            
            if dia == miDia {
                return true
            }
        }
        
        return false
    }
}

class Horario
{
    var dias:String?  = ""
    var horaCierre:String?  = ""
    var horaInicio:String?  = ""
    
    var diasActivos:[Dias] = []
    var nombreArbol:String?  = ""
}

class ContactoPrincipal
{
    var nombre:String?  = ""
    var tipoDocumento:String?  = ""
    var documento:String?  = ""
    var telefono:String?  = ""
    var celular:String?  = ""
    var correo:String?  = ""
    var contraseña:String?  = ""
}

class PublicacionOferente
{
    var idPublicacion:String?  = ""
    var activo:Bool?
    var categoria:String?  = ""
    var descripcion:String?  = ""
    var destacado:Bool?
    var fotos:[Foto]? = []
    
    var tieneFotos:Bool
    {
        if fotos == nil
        {
            return false
        }
        return true
    }
    
    var horario:[Horario]? = []
    
    var tieneHorario:Bool
    {
        if horario == nil
        {
            return false
        }
        return true
    }
    
    var idOferente:String?  = ""
    var nombre:String?  = ""
    var precio:String?  = ""
    var servicio:Bool?
    var stock:String?  = ""
    
    var tieneStock:Bool
    {
        if stock == nil
        {
            return false
        }
        return true
    }
    
    var subcategoria:String?  = ""
    
    var tieneSubcategoria:Bool
    {
        if subcategoria == nil
        {
            return false
        }
        return true
    }
    
    var target:String?  = ""
}

class Foto
{
    var numeroFoto:Int! = 0
    var idFoto:String?  = ""
    var nombreFoto:String?  = ""
    var urlFoto: String? = ""
}

class Categoria
{
    var imagen:String?  = ""
    var nombre:String?  = ""
    var servicio:Bool?
    var subcategoria:[SubCategoria]? = []
    
    var tieneSubcategoria:Bool
    {
        if subcategoria == nil
        {
            return false
        }
        return true
    }
}

class SubCategoria
{
    var nombre:String?  = ""
}

enum Mascotas:Int
{
    case perro = 1
    case gato
    case ave
    case pez
    case roedor
    case exotico
    
    func descripcionLarga() -> String
    {
        switch self {
        case .perro:
            return "Perro"
        case .gato:
            return "Gato"
        case .ave:
            return "Ave"
        case .pez:
            return "Pez"
        case .roedor:
            return "Roedor"
        case .exotico:
            return "Exótico (otros)"
            
        /*default:
             return ""*/
        }
    }
}

class TipoMascotas
{
    var mascotas:[Mascotas] = []
    
    init (){
        
    }
    
    //mascotas es en realidad todos los mascotas separados por coma
    func adicionarMascota(mascotas:String)
    {
        let lasMascotas = mascotas.components(separatedBy: ", ")
        
        for mascota in lasMascotas
        {
            switch mascota
            {
            case "Perro":
                self.mascotas.append(.perro)
            case "Gato":
                self.mascotas.append(.gato)
            case "Ave":
                self.mascotas.append(.ave)
            case "Pez":
                self.mascotas.append(.pez)
            case "Roedor":
                self.mascotas.append(.roedor)
            case "Exótico (otros)":
                self.mascotas.append(.exotico)
                
            default:
                print("")
            }
        }
    }
    
    func getMascotasPegadosParaFirebase() -> String
    {
        var res = ""
        
        for mascota in mascotas {
            
            res = res + mascota.descripcionLarga() + ","
            
        }
        return res
    }
    
    func getMascotasPegadosLargos() -> String
    {
        var res = ""
        
        for mascota in mascotas {
            
            res = res + mascota.descripcionLarga() + ", "
            
        }
        res.characters.removeLast()
        res.characters.removeLast()
        
        return res
        
    }
    
    func esMascotaIncluido(miMascota:Mascotas) -> Bool
    {
        
        for mascota in mascotas {
            
            if mascota == miMascota {
                return true
            }
        }
        
        return false
    }
}

class ModeloOferente
{
    static let sharedInstance:ModeloOferente =
    {
        
        let instance = ModeloOferente()
        //Codigo adicional de setup
        
        return instance
    }()
    
    var horarioSemana = Horario()
    var horarioFestivo = Horario()
    
    var horarioAtencionSemana:HorarioAtencion?
    var horarioAtencionFinSemana:HorarioAtencion?
    
    var ubicacionGoogle = UbicacionGoogleMaps()
    
    var oferente = [Oferente]()
    
    var publicacionOferente = [PublicacionOferente]()
    
    var publicacion = PublicacionOferente()
    var categorias = [Categoria]()
    var tipoMascotas:TipoMascotas?
    
    var publicacionesActivas = [PublicacionOferente]()
    var publicacionesInactivas = [PublicacionOferente]()
}

extension String
{
    // formatting text for currency textField
    func currencyInputFormatting() -> String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        formatter.locale = Locale(identifier: "es_CL")
        
        let valor:NSNumber = NSNumber(value: Float(self)!)
        return formatter.string(from: valor)!
    }
}
