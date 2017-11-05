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

class Comando
{
    // Datos Publicaciones
    
    class func getPublicaciones()
    {
        let model  = Modelo.sharedInstance
        let modelUsuario = ModeloUsuario.sharedInstance
        
        model.publicacionesDestacadas.removeAll()
        
        model.publicacionesPopulares.removeAll()
        
        model.publicacionesParaAve.removeAll()
        model.publicacionesParaExotico.removeAll()
        model.publicacionesParaGato.removeAll()
        model.publicacionesParaPerro.removeAll()
        model.publicacionesParaPez.removeAll()
        model.publicacionesParaRoedor.removeAll()
        
        model.publicacionesAccesorios.removeAll()
        model.publicacionesAccesoriosParaAve.removeAll()
        model.publicacionesAccesoriosParaExotico.removeAll()
        model.publicacionesAccesoriosParaGato.removeAll()
        model.publicacionesAccesoriosParaPerro.removeAll()
        model.publicacionesAccesoriosParaPez.removeAll()
        model.publicacionesAccesoriosParaRoedor.removeAll()
        
        model.publicacionesEsteticaHigiene.removeAll()
        model.publicacionesEsteticaHigieneParaAve.removeAll()
        model.publicacionesEsteticaHigieneParaExotico.removeAll()
        model.publicacionesEsteticaHigieneParaGato.removeAll()
        model.publicacionesEsteticaHigieneParaPerro.removeAll()
        model.publicacionesEsteticaHigieneParaPez.removeAll()
        model.publicacionesEsteticaHigieneParaRoedor.removeAll()
        
        model.publicacionesFuneraria.removeAll()
        model.publicacionesFunerariaParaAve.removeAll()
        model.publicacionesFunerariaParaExotico.removeAll()
        model.publicacionesFunerariaParaGato.removeAll()
        model.publicacionesFunerariaParaPerro.removeAll()
        model.publicacionesFunerariaParaPez.removeAll()
        model.publicacionesFunerariaParaRoedor.removeAll()
        
        model.publicacionesGuarderia.removeAll()
        model.publicacionesGuarderiaParaAve.removeAll()
        model.publicacionesGuarderiaParaExotico.removeAll()
        model.publicacionesGuarderiaParaGato.removeAll()
        model.publicacionesGuarderiaParaPerro.removeAll()
        model.publicacionesGuarderiaParaPez.removeAll()
        model.publicacionesGuarderiaParaRoedor = [PublicacionOferente]()
        
        model.publicacionesMedicamentos.removeAll()
        model.publicacionesMedicamentosParaAve.removeAll()
        model.publicacionesMedicamentosParaExotico.removeAll()
        model.publicacionesMedicamentosParaGato.removeAll()
        model.publicacionesMedicamentosParaPerro.removeAll()
        model.publicacionesMedicamentosParaPez.removeAll()
        model.publicacionesMedicamentosParaRoedor.removeAll()
        
        model.publicacionesNutricion.removeAll()
        model.publicacionesNutricionParaAve.removeAll()
        model.publicacionesNutricionParaExotico.removeAll()
        model.publicacionesNutricionParaGato.removeAll()
        model.publicacionesNutricionParaPerro.removeAll()
        model.publicacionesNutricionParaPez.removeAll()
        model.publicacionesNutricionParaRoedor.removeAll()
        
        model.publicacionesPaseador.removeAll()
        model.publicacionesPaseadorParaAve.removeAll()
        model.publicacionesPaseadorParaExotico.removeAll()
        model.publicacionesPaseadorParaGato.removeAll()
        model.publicacionesPaseadorParaPerro.removeAll()
        model.publicacionesPaseadorParaPez.removeAll()
        model.publicacionesPaseadorParaRoedor.removeAll()
        
        model.publicacionesSalud.removeAll()
        model.publicacionesSaludParaAve.removeAll()
        model.publicacionesSaludParaExotico.removeAll()
        model.publicacionesSaludParaGato.removeAll()
        model.publicacionesSaludParaPerro.removeAll()
        model.publicacionesSaludParaPez.removeAll()
        model.publicacionesSaludParaRoedor.removeAll()
        
        model.publicacionesEnCarrito.removeAll()
        modelUsuario.misComprasCompleto.removeAll()
        model.publicacionesFavoritas.removeAll()
        
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
                
                if publicacion.hasChild("stock")
                {
                    datosPublicacion.stock = value["stock"] as? String
                }
                
                if publicacion.hasChild("subcategoria")
                {
                    datosPublicacion.subcategoria = value["subcategoria"] as? String
                }
                
                datosPublicacion.target = value["target"] as? String
                
                if modelUsuario.usuario.count != 0
                {
                    if modelUsuario.usuario[0].datosComplementarios?.count != 0
                    {
                        if modelUsuario.usuario[0].datosComplementarios?[0].carrito?.count != 0
                        {
                            for publicacionCarrito in (modelUsuario.usuario[0].datosComplementarios?[0].carrito)!
                            {
                                if publicacionCarrito.idPublicacion == datosPublicacion.idPublicacion
                                {
                                    publicacionCarrito.publicacionCompra = datosPublicacion
                                    
                                    model.publicacionesEnCarrito.append(publicacionCarrito)
                                }
                            }
                        }
                        
                        print("mis Compras: \(modelUsuario.misCompras.count)")
                        
                        if modelUsuario.misCompras.count != 0
                        {
                            for miCompra in (modelUsuario.misCompras)
                            {
                                print("id compra: \(miCompra.idCompra!) - cant. Pedido: \((miCompra.pedido?.count)!)")
                                
                                if miCompra.pedido?.count != 0
                                {
                                    if miCompra.pedido?[0].idPublicacion == datosPublicacion.idPublicacion
                                    {
                                        print("id compraPedido: \((miCompra.pedido?[0].idPublicacion)!) - id. Publicacion: \(datosPublicacion.idPublicacion!)")
                                        
                                        miCompra.pedido?[0].publicacionCompra = datosPublicacion
                                        
                                        modelUsuario.misComprasCompleto.append(miCompra)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if datosPublicacion.activo!
                {
                    if modelUsuario.usuario.count != 0
                    {
                        if modelUsuario.usuario[0].datosComplementarios?.count != 0
                        {
                            if modelUsuario.usuario[0].datosComplementarios?[0].favoritos?.count != 0
                            {
                                for favorito in (modelUsuario.usuario[0].datosComplementarios?[0].favoritos)!
                                {
                                    if favorito.idPublicacion == datosPublicacion.idPublicacion
                                    {
                                        if favorito.activo!
                                        {
                                            model.publicacionesFavoritas.append(datosPublicacion)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    model.publicacionesPopulares.append(datosPublicacion)
                    
                    if datosPublicacion.destacado!
                    {
                        model.publicacionesDestacadas.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Accesorios"
                    {
                        model.publicacionesAccesorios.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Lind@ y Limpi@"
                    {
                        model.publicacionesEsteticaHigiene.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Amiguitos en el cielo"
                    {
                        model.publicacionesFuneraria.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Guardería 5 patas"
                    {
                        model.publicacionesGuarderia.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Medicamentos"
                    {
                        model.publicacionesMedicamentos.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Nutrición"
                    {
                        model.publicacionesNutricion.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Paseador"
                    {
                        model.publicacionesPaseador.append(datosPublicacion)
                    }
                    
                    if datosPublicacion.categoria == "Vamos al médico"
                    {
                        model.publicacionesSalud.append(datosPublicacion)
                    }
                    
                    var tipoMascotas = ModeloOferente.sharedInstance.tipoMascotas
                    
                    if tipoMascotas == nil {
                        
                        tipoMascotas = TipoMascotas()
                    }
                    
                    tipoMascotas?.adicionarMascota(mascotas: datosPublicacion.target!)
                    
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .perro))!
                    {
                        model.publicacionesParaPerro.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaPerro.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaPerro.append(datosPublicacion)
                        }
                    }
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .gato))!
                    {
                        model.publicacionesParaGato.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaGato.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaGato.append(datosPublicacion)
                        }
                    }
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .ave))!
                    {
                        model.publicacionesParaAve.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaAve.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaAve.append(datosPublicacion)
                        }
                    }
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .pez))!
                    {
                        model.publicacionesParaPez.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaPez.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaPez.append(datosPublicacion)
                        }
                    }
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .roedor))!
                    {
                        model.publicacionesParaRoedor.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaRoedor.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaRoedor.append(datosPublicacion)
                        }
                    }
                
                    if (tipoMascotas?.esMascotaIncluido(miMascota: .exotico))!
                    {
                        model.publicacionesParaExotico.append(datosPublicacion)
                        
                        if datosPublicacion.categoria == "Accesorios"
                        {
                            model.publicacionesAccesoriosParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Lind@ y Limpi@"
                        {
                            model.publicacionesEsteticaHigieneParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Amiguitos en el cielo"
                        {
                            model.publicacionesFunerariaParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Guardería 5 patas"
                        {
                            model.publicacionesGuarderiaParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Medicamentos"
                        {
                            model.publicacionesMedicamentosParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Nutrición"
                        {
                            model.publicacionesNutricionParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Paseador"
                        {
                            model.publicacionesPaseadorParaExotico.append(datosPublicacion)
                        }
                        
                        if datosPublicacion.categoria == "Vamos al médico"
                        {
                            model.publicacionesSaludParaExotico.append(datosPublicacion)
                        }
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
            datosPublicacion.idPublicacion = snap.key
            datosPublicacion.nombre = value["nombre"] as? String
            datosPublicacion.precio = value["precio"] as? String
            datosPublicacion.servicio = value["servicio"] as? Bool
            
            if snap.hasChild("stock")
            {
                datosPublicacion.stock = value["stock"] as? String
            }
            
            if snap.hasChild("subcategoria")
            {
                datosPublicacion.subcategoria = value["subcategoria"] as? String
            }
            
            datosPublicacion.target = value["target"] as? String
            
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
            
            while let CategoriaChild = categorias.nextObject() as? DataSnapshot {
                
                let categoria = Categoria()
                let postDict = CategoriaChild.value as! [String : AnyObject]
                
                categoria.imagen = postDict["imagen"] as? String
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
                let providerID = profile.providerID
                let uid = profile.uid;  // Provider-specific UID
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
        
        ref.child("/fechaUltimoLogeo").setValue(Date().fechaString()  as AnyObject)
        ref.child("/horaUltimoLogeo").setValue(Date().horaString()  as AnyObject)
        ref.child("/systemDevice").setValue("iOS")
        ref.child("/version").setValue(version)
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
    
    class func calcularEdadEnAños(birthday:NSDate) -> Int
    {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.year, from: birthday as Date, to: now as Date, options: [])
        let age = calcAge.year
        return age!
    }
    
    class func calcularEdadEnMeses(birthday:NSDate) -> Int
    {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.month, from: birthday as Date, to: now as Date, options: [])
        let month = calcAge.month
        return month!
    }
}
