//
//  DetalleMiVenta.swift
//  MyPet
//
//  Created by Andres Garcia on 8/17/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetalleMiVenta: UIViewController {
    
    
    
    @IBOutlet weak var conAltoServico: NSLayoutConstraint!
    @IBOutlet weak var conAltoProducto: NSLayoutConstraint!
    
    @IBOutlet weak var conAltoEstrellas: NSLayoutConstraint!
    
    @IBOutlet weak var vistaServcio: UIView!

    @IBOutlet weak var vistaProducto: UIView!
    
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var descripcion: UILabel!
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var telefono: UILabel!
    
    
    
    
    @IBOutlet weak var servicioFecha: UILabel!
    @IBOutlet weak var servicioHora: UILabel!
    @IBOutlet weak var servicioDuracion: UILabel!
    @IBOutlet weak var estado: UILabel!
    
    @IBOutlet weak var productoFecha: UILabel!
    @IBOutlet weak var productoEstado: UILabel!
    
    @IBOutlet weak var precioUnidad: UILabel!
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var preguntas: UILabel!
    
    @IBOutlet weak var botonBarraTitulo: UIBarButtonItem!
    
    @IBOutlet weak var botonEntregado: UIButton!
    
    @IBOutlet weak var labelEspera: UILabel!
    
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    
    @IBOutlet weak var vistaCalificacion: UIView!
    
    @IBOutlet weak var comentarioCali: UILabel!
    @IBOutlet weak var fechaCali: UILabel!
    
    
    
    var item : ItemCompra?
    var idCliente = ""
    
    let model = ModeloOferente.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        refrescar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func refrescar() {
        
        idCliente = (item?.compra?.idCliente)!
        
        let publicacion = model.getPublicacion(idPublicacion: item!.idPublicacion)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actualizoImagen), name:NSNotification.Name(rawValue: (publicacion?.imagenPrincipal?.pathEnStorage)!), object: nil)
        
        
        
        let cliente = model.misUsuarios[idCliente]
        var complemento:DatosComplementarios? = nil
        
        if cliente != nil {
            complemento = cliente?.datosComplementarios?[0]
            
        }
        else {
            ComandoPreguntasOferente.getMiniUsuario(uid: idCliente)
        }
        
        
        imagen.image = publicacion?.imagenPrincipal?.getImagen(msnNoti: nil)
        
        
        let compra = item?.compra!
        
        nombre.text = publicacion!.nombre
        descripcion.text = publicacion?.descripcion
        if complemento != nil {
            direccion.text = complemento!.direcciones?[0].direccion
            telefono.text = complemento!.celular
            botonBarraTitulo.title = (complemento?.nombre)! + " " +  (complemento?.apellido)!
        }
        precioUnidad.text = publicacion!.precio!.convertToMoney()
        cantidad.text = String(item!.cantidad)
        total.text = String(describing: compra!.valor).convertToMoney()
        
        if item!.servicio {
            
            vistaServcio.isHidden = false
            vistaProducto.isHidden = true
            conAltoProducto.constant = 0
            servicioFecha.text = item?.fechaServicio!
            servicioHora.text = "18 AM"
            servicioDuracion.text = String(describing: publicacion!.duracion!) + " minutos"
            estado.text = item?.estado
            botonEntregado.setTitle("Servicio Entregado", for: .normal)
        }else {
            vistaServcio.isHidden = true
            vistaProducto.isHidden = false
            
            conAltoServico.constant = 0
            productoFecha.text = item?.fechaServicio!
            productoEstado.text = item?.estado
        }
        
        
        let pregun = model.getPreguntas(de: item!.idPublicacion, idCliente: idCliente).count

        if pregun ==  1 {
            
            preguntas.text = String(pregun) + " pregunta"
            
        }
        if pregun > 1 {
            preguntas.text = String(pregun) + " preguntas"
        }
        
        if item?.estado == "Pendiente" {
            
            botonEntregado.isHidden = false
            labelEspera.text = ""
            estado.text = "Pendiente"
            productoEstado.text = "Pendiente"
            estado.textColor = UIColor(red: 237.0/255.0, green: 28/255.0, blue: 36.0/255.0, alpha: 1.0)
            productoEstado.textColor = UIColor(red: 237.0/255.0, green: 28/255.0, blue: 36.0/255.0, alpha: 1.0)
            
        } else if item?.estado == "Entregada" {
            
            botonEntregado.isHidden = true
            productoEstado.text = "Entregado"
            productoEstado.textColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 69/255.0, alpha: 1.0)
            
        } else if item?.estado == "Cerrada" {
            
            botonEntregado.isHidden = true
            labelEspera.text = ""
        
        }
        
        let cali = model.getCalificacionCompra(idCompra: item!.compra!.idCompra)
        
        if cali != nil {
            pintarCalificacion(nota: cali!.calificacion)
            comentarioCali.text = cali!.comentario
            
        }
        else {
            //vistaServcio.isHidden = true
            comentarioCali.text = ""
            fechaCali.text = ""
            conAltoEstrellas.constant = 0
        }
        
        
        
        
    }
    
    
    @objc func  actualizoImagen() {
        
        let publicacion = model.getPublicacion(idPublicacion: item!.idPublicacion)
        
        DispatchQueue.main.async {
            
            if publicacion?.imagenPrincipal?.imageData != nil {
                self.imagen.image = UIImage(data:publicacion!.imagenPrincipal!.imageData!)
            }
            
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didTapPreguntas(_ sender: Any) {
        performSegue(withIdentifier: "verChat", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "verChat"){
            
            let detailController = segue.destination as! ChatOferente
            detailController.idPublicacion = item!.idPublicacion
            detailController.filtroIdCliente = idCliente
        }
    }

    
    
    @IBAction func didTapEntegado(_ sender: Any) {
        
        botonEntregado.isHidden = true
        labelEspera.text = "A espera de confirmación del cliente"
        estado.text = "Entregado"
        estado.textColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 69/255.0, alpha: 1.0)
        productoEstado.text = "Entregado"
        productoEstado.textColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 69/255.0, alpha: 1.0)
        
        ComandoCompras.setEstadoCompraAbierta(item: item!, estado: "Entregada")
        
        
        
    }
    
    
    func pintarCalificacion(nota:Int){
    
        pintarEstrella(1, nota: Float(nota))
        pintarEstrella(2, nota: Float(nota))
        pintarEstrella(3, nota: Float(nota))
        pintarEstrella(4, nota: Float(nota))
        pintarEstrella(5, nota: Float(nota))
        
        
    }
    
    func pintarEstrella(_ posLuz:Int, nota:Float) {
        
        let imagen = getImageDeLuz(posLuz)
        
        if nota >= Float(posLuz) {
            imagen.image = UIImage(named: "imgEstrellaCompleta")
            return
        }
        
      /*  if Float(posLuz) - nota == 0.5 {
            imagen.image = UIImage(named: "star_half")
            return
            
        }*/
        
        
        imagen.image = UIImage(named: "imgEstrellaVacia")
        
        
        
    }
    
    func getImageDeLuz(_ posLuz:Int) ->  UIImageView{
        
        if posLuz == 1 {
            return star1
        }
        
        if posLuz == 2 {
            return star2
        }
        
        if posLuz == 3 {
            return star3
        }
        
        if posLuz == 4 {
            return star4
        }
        
        if posLuz == 5 {
            return star5
        }
        
        return star5
        
    }

    
    
    
}
