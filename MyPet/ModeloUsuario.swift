//
//  ModeloUsuario.swift
//  MyPet
//
//  Created by Jose Aguilar on 12/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation

class Usuario
{
    var correo:String?  = ""
    var datosComplementarios:[DatosComplementarios]? = []
    
    var tieneDatosComplementarios:Bool
    {
        if datosComplementarios == nil
        {
            return false
        }
        return true
    }
}

class DatosComplementarios
{
    var apellido:String?  = ""
    var carrito:[Carrito]? = []
    var celular:String?  = ""
    var direcciones:[Direccion]? = []
    var documento:String?  = ""
    var favoritos:[Favorito]? = []
    var mascotas:[Mascota]? = []
    var nombre:String?  = ""
    var pagoEfectvo:Bool?
}

class Carrito
{
    var cantidadCompra:Int?  = 0
    var fechaHoraReserva:String?  = ""
    var idCarrito:String?  = ""
    var idPublicacion:String?  = ""
    var publicacionCompra = PublicacionOferente()
    var servicio:Bool?
}

class Direccion
{
    var idDireccion:String?  = ""
    var direccion:String?  = ""
    var nombre:String?  = ""
    var porDefecto:Bool?
    var ubicacion:[Ubicacion]? = []
}

class Favorito
{
    var idPublicacion:String?  = ""
    var activo:Bool?
}

class Mascota
{
    var activa:Bool?
    var alertas:[Alerta]? = []
    
    var tieneAlertas:Bool
    {
        if alertas == nil
        {
            return false
        }
        return true
    }
    
    var fechaNacimiento:String?  = ""
    var foto:String?  = ""
    var genero:String?  = ""
    var idMascota:String?  = ""
    var nombre:String?  = ""
    var raza:String?  = ""
    var tipo:String?  = ""
}

class Alerta
{
    var idAlerta:String?  = ""
    var activada:Bool?
    var fechaFin:String?  = ""
    var fechaInicio:String?  = ""
    var frecuencia:String?  = ""
    var hora:String?  = ""
    var nombre:String?  = ""
    var tipoRecordatorio:String?  = ""
}

class UbicacionGoogleMaps
{
    var latitud:Double?
    var longitud:Double?
    var direccion:String?  = ""
}

class CompraUsuario
{
    var fecha:String?  = ""
    var idCompra:String?  = ""
    var idCliente:String?  = ""
    var idOferente:String?  = ""
    var pedido:[PedidoUsuario]? = []
    var timestamp:CLong! = 0
    var valor:Int?  = 0
}

class PedidoUsuario
{
    var cantidadCompra:Int?  = 0
    var estado:String?  = ""
    var fechaServicio:String?  = ""
    var idPedido:Int?  = 0
    var idPublicacion:String?  = ""
    var publicacionCompra = PublicacionOferente()
    var servicio:Bool?
}

class ModeloUsuario
{
    static let sharedInstance:ModeloUsuario =
    {
        
        let instance = ModeloUsuario()
        //Codigo adicional de setup
        
        return instance
    }()
    
    var usuario = [Usuario]()
    
    var registroComplementario = DatosComplementarios()
    
    var direccion1 = Direccion()
    var ubicacion1 = Ubicacion()
    
    var direccion2 = Direccion()
    var ubicacion2 = Ubicacion()
    
    var direccion3 = Direccion()
    var ubicacion3 = Ubicacion()
    
    var mascotas = [Mascota]()
    var tuMascota = Mascota()
    var mascotaSeleccionada = Mascota()
    var alertasMascotaSeleccionada = [Alerta]()
    var alertaMascota = Alerta()
    
    var publicacionCarrito = Carrito()
    
    var misCompras = [CompraUsuario]()
    var misComprasCompleto = [CompraUsuario]()
    var compra = CompraUsuario()
}



