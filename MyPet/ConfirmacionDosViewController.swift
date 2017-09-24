//
//  ConfirmacionDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmacionDosViewController: UIViewController
{
    let modelOferente = ModeloOferente.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var trailingSpaceConstraint: NSLayoutConstraint?
    
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    
    @IBOutlet var lblNombreCompleto: UILabel!
    @IBOutlet var lblCedula: UILabel!
    @IBOutlet var lblTextoDireccion: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var lblCambiar: UILabel!
    @IBOutlet var imgAdelante: UIImageView!
    @IBOutlet var btnCambiar: UIButton!
    @IBOutlet var lblTextoTelefono: UILabel!
    @IBOutlet var lblTelefono: UILabel!
    @IBOutlet var lblMetodoPago: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnFinalizar: UIButton!
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            barFixedSpace.width = 35.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 80.0
        }
        
        lblNombreCompleto.layer.masksToBounds = true
        lblNombreCompleto.layer.cornerRadius = 7.0
        
        lblCedula.layer.masksToBounds = true
        lblCedula.layer.cornerRadius = 7.0
        
        lblTelefono.layer.masksToBounds = true
        lblTelefono.layer.cornerRadius = 7.0
        
        btnFinalizar.layer.cornerRadius = 10.0
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        let TotalString:String = String(Total)
        lblTotal.text = TotalString
        
        if let amountString = lblTotal.text?.currencyInputFormatting()
        {
            lblTotal.text = amountString
        }
    }
    
    @IBAction func cambiarDireccion(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "direccionesDesdeConfirmacionDos", sender: self)
    }
    
    @IBAction func finalizarCompra(_ sender: Any)
    {
        modelUsuario.compra.idCompra = modelUsuario.publicacionCarrito.idCarrito
        
        let nowDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.string(from: nowDate as Date)
        
        modelUsuario.compra.fecha = dateString
        
        modelUsuario.compra.idCliente = (user?.uid)!
        modelUsuario.compra.idOferente = modelUsuario.publicacionCarrito.publicacionCompra.idOferente
        
        modelUsuario.compra.pedido?.removeAll()
        
        let pedido = PedidoUsuario()
        
        pedido.idPublicacion = modelUsuario.publicacionCarrito.idPublicacion
        pedido.servicio = modelUsuario.publicacionCarrito.publicacionCompra.servicio
        pedido.publicacionCompra = modelUsuario.publicacionCarrito.publicacionCompra
        pedido.cantidadCompra = modelUsuario.publicacionCarrito.cantidadCompra
        pedido.estado = "Pendiente"
        
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            pedido.fechaServicio = modelUsuario.publicacionCarrito.fechaHoraReserva
        }
        
        modelUsuario.compra.pedido?.append(pedido)
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        
        modelUsuario.compra.valor = Total
        
        ComandoUsuario.realizarCompra(compra: modelUsuario.compra)
        
        if modelUsuario.compra.idCompra != ""
        {
            ComandoUsuario.eliminarPublicacionCarrito(uid: modelUsuario.compra.idCliente, idPublicacionCarrito: modelUsuario.compra.idCompra)
        }
        
        ComandoUsuario.getMisComprasUsuario(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmacionDosViewController.irACompraExitosa(_:)), name:NSNotification.Name(rawValue:"cargoMisComprasUsuario"), object: nil)
    }
    
    func irACompraExitosa(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "compraExitosaDesdeConfirmacionDos", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        lblNombreCompleto.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].nombre)!) \((modelUsuario.usuario[0].datosComplementarios?[0].apellido)!)"
        
        lblCedula.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].documento)!)"
        
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            if modelUsuario.publicacionCarrito.publicacionCompra.servicioEnDomicilio!
            {
                lblTextoDireccion.text = "Dirección del servicio (tienda)"
                lblDireccion.text = "   \(modelOferente.oferente[0].direccion!)"
                
                lblTextoTelefono.text = "Teléfono contacto del servicio"
                lblTelefono.text = "   \((modelOferente.oferente[0].telefono)!)"
                
                lblCambiar.isHidden = true
                imgAdelante.isHidden = true
                btnCambiar.isHidden = true
                
                self.trailingSpaceConstraint?.constant = -75.0
            } else
            {
                lblTextoDireccion.text = "Dirección del servicio (domicilio)"
                
                for direccion in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
                {
                    if direccion.porDefecto!
                    {
                        lblDireccion.text = "   \(direccion.direccion!)"
                    }
                }
                
                lblTextoTelefono.text = "Teléfono contacto"
                lblTelefono.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].celular)!)"
            }
            
        } else
        {
            lblTextoDireccion.text = "Dirección de entrega"
            
            for direccion in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
            {
                if direccion.porDefecto!
                {
                    lblDireccion.text = "   \(direccion.direccion!)"
                }
            }
            
            lblTextoTelefono.text = "Teléfono contacto"
            lblTelefono.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].celular)!)"
        }
        
        if (modelUsuario.usuario[0].datosComplementarios?[0].pagoEfectvo)!
        {
            lblMetodoPago.text = "   Efectivo"
        } else
        {
            lblMetodoPago.text = "   Tarjeta"
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "compraExitosaDesdeConfirmacionDos")
        {
            let detailController = segue.destination as! CompraExitosaViewController
            detailController.vistoDesdeMisCompras = false
        }
    }

}
