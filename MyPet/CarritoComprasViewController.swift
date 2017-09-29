//
//  CarritoComprasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class CarritoComprasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var segCtrlCarrito: UISegmentedControl!
    
    @IBOutlet var viewMensaje: UIView!
    @IBOutlet var imgMensaje: UIImageView!
    @IBOutlet var lblMensaje: UILabel!
    
    @IBOutlet var tableProductosServicios: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configuración UISegmentedControl
        
        let attributes = [ NSForegroundColorAttributeName : UIColor.white,
                           NSFontAttributeName : UIFont (name: "HelveticaNeue-Light", size: 15.0)];
        let attributesSelected = [ NSForegroundColorAttributeName : UIColor.white,
                                   NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 15.0)];
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes as Any as? [AnyHashable : Any], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(attributesSelected as Any as? [AnyHashable : Any], for: .selected)
        
        segCtrlCarrito.clipsToBounds = true
        segCtrlCarrito.layer.cornerRadius = 10.0
        segCtrlCarrito.layer.borderWidth = 1.0
        segCtrlCarrito.layer.borderColor = UIColor.white.cgColor
        
        segCtrlCarrito.selectedSegmentIndex = modelUsuario.selectedControlIndex
        
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes ningún producto y/o servicio en tu carrito."
            
            if model.publicacionesEnCarrito.count != 0
            {
                viewMensaje.isHidden = true
            }
            
        case 1:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios en tus compras."
            
            if modelUsuario.misComprasCompleto.count != 0
            {
                viewMensaje.isHidden = true
            }
            
        case 2:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgFavoritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios favoritos."
            
            if model.publicacionesFavoritas.count != 0
            {
                viewMensaje.isHidden = true
            }
            
        default:
            break
        }
        
        let nib = UINib(nibName: "FavoritoTableViewCell", bundle: nil)
        tableProductosServicios.register(nib, forCellReuseIdentifier: "favoritoTableViewCell")
        
        let nib2 = UINib(nibName: "CarritoTableViewCell", bundle: nil)
        tableProductosServicios.register(nib2, forCellReuseIdentifier: "carritoTableViewCell")
        
        let nib3 = UINib(nibName: "MiCompraPendienteTableViewCell", bundle: nil)
        tableProductosServicios.register(nib3, forCellReuseIdentifier: "miCompraPendienteTableViewCell")
        
        let nib4 = UINib(nibName: "MiCompraConfirmadaTableViewCell", bundle: nil)
        tableProductosServicios.register(nib4, forCellReuseIdentifier: "miCompraConfirmadaTableViewCell")
        
        let nib5 = UINib(nibName: "MiCompraFinalizadaTableViewCell", bundle: nil)
        tableProductosServicios.register(nib5, forCellReuseIdentifier: "miCompraFinalizadaTableViewCell")
    }
    
    func refrescarVista(_ notification: Notification)
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes ningún producto y/o servicio en tu carrito."
            
            if model.publicacionesEnCarrito.count != 0
            {
                viewMensaje.isHidden = true
            }
            
            modelUsuario.selectedControlIndex = 0
            
        case 1:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios en tus compras."
            
            if modelUsuario.misComprasCompleto.count != 0
            {
                viewMensaje.isHidden = true
            }
            
            modelUsuario.selectedControlIndex = 1
            
        case 2:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgFavoritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios favoritos."
            
            if model.publicacionesFavoritas.count != 0
            {
                viewMensaje.isHidden = true
            }
            
            modelUsuario.selectedControlIndex = 2
            
        default:
            break
        }
        
        tableProductosServicios.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: AnyObject)
    {
        Comando.getPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            if model.publicacionesEnCarrito.count != 0
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
            
        case 1:
            if modelUsuario.misComprasCompleto.count != 0
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
            
        case 2:
            if model.publicacionesFavoritas.count != 0
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
            
        default:
            break
        }
        
        tableProductosServicios.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            if model.publicacionesEnCarrito.count != 0
            {
                return model.publicacionesEnCarrito.count
            }
        case 1:
            if modelUsuario.misComprasCompleto.count != 0
            {
                return modelUsuario.misCompras.count
            }
            
        case 2:
            return model.publicacionesFavoritas.count
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritoTableViewCell")  as! FavoritoTableViewCell
        
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "carritoTableViewCell")  as! CarritoTableViewCell
            
            let path = "productos/" + (model.publicacionesEnCarrito[indexPath.row].idPublicacion)! + "/" + (model.publicacionesEnCarrito[indexPath.row].publicacionCompra.fotos?[0].nombreFoto)!
            
            cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
            
            cell.lblNombrePublicacion.text = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.nombre
            
            if (model.publicacionesEnCarrito[indexPath.row].servicio!)
            {
                if let amountString = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio?.currencyInputFormatting()
                {
                    cell.lblCostoPublicacion.text = "\(amountString) (Agendado para el: \((model.publicacionesEnCarrito[indexPath.row].fechaHoraReserva)!))"
                    cell.lblTotal.text = amountString
                }
            } else
            {
                if let amountStringDos = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio?.currencyInputFormatting()
                {
                    cell.lblCostoPublicacion.text = "\(amountStringDos) (x\((model.publicacionesEnCarrito[indexPath.row].cantidadCompra)!))"
                }
                
                let costo:Int = Int((model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio!))!
                let Total:Int = (model.publicacionesEnCarrito[indexPath.row].cantidadCompra!) * costo
                let TotalString:String = String(Total)
                cell.lblTotal.text = TotalString
                
                if let amountStringDos = cell.lblTotal.text?.currencyInputFormatting()
                {
                    cell.lblTotal.text = amountStringDos
                }
            }
            
            cell.btnComprar.tag = indexPath.row
            cell.btnComprar.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return cell
        case 1:
            
            if modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].estado == "Pendiente"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "miCompraPendienteTableViewCell")  as! MiCompraPendienteTableViewCell
                
                let path = "productos/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].idPublicacion)! + "/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.fotos?[0].nombreFoto)!
                
                cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
                
                cell.lblTextoInfo.text = "Compra en proceso..."
                
                cell.lblNombrePublicacion.text = modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.nombre
                
                cell.bottomSpaceConstraint?.constant = 15.0
                
                cell.btnConfirmar.isHidden = true
                cell.btnRechazar.isHidden = true
                
                return cell
            }
            
            if modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].estado == "Entregada"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "miCompraPendienteTableViewCell")  as! MiCompraPendienteTableViewCell
                
                let path = "productos/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].idPublicacion)! + "/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.fotos?[0].nombreFoto)!
                
                cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
                
                if (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].servicio)!
                {
                    cell.lblTextoInfo.text = "¿Tu servicio ha sido efectivo?"
                }else
                {
                    cell.lblTextoInfo.text = "¿Tu producto ha llegado?"
                }
                
                cell.lblNombrePublicacion.text = modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.nombre
                
                cell.btnConfirmar.tag = indexPath.row
                cell.btnConfirmar.addTarget(self, action: #selector(confirmarCompra), for: .touchUpInside)
                
                cell.btnRechazar.tag = indexPath.row
                //cell.btnRechazar.addTarget(self, action: #selector(rechazarCompra), for: .touchUpInside)
                
                return cell
            }
            
            if modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].estado == "Cerrada"
            {
                modelUsuario.getCalificacionCompra(posicion: indexPath.row)
                
                if modelUsuario.misComprasCompleto[indexPath.row].calificacion?.count == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "miCompraConfirmadaTableViewCell")  as! MiCompraConfirmadaTableViewCell
                    
                    let path = "productos/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].idPublicacion)! + "/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.fotos?[0].nombreFoto)!
                    
                    cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
                    
                    cell.lblTextoInfo.text = "Compra finalizada"
                    
                    cell.lblNombrePublicacion.text = modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.nombre
                    
                    cell.btnCalificar.tag = indexPath.row
                    cell.btnCalificar.addTarget(self, action: #selector(calificarCompra), for: .touchUpInside)
                    
                    return cell
                    
                } else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "miCompraFinalizadaTableViewCell")  as! MiCompraFinalizadaTableViewCell
                    
                    let path = "productos/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].idPublicacion)! + "/" + (modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.fotos?[0].nombreFoto)!
                    
                    cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
                    
                    cell.lblTextoInfo.text = "Compra finalizada"
                    
                    cell.lblNombrePublicacion.text = modelUsuario.misComprasCompleto[indexPath.row].pedido?[0].publicacionCompra.nombre
                    
                    cell.ratingValue = (modelUsuario.misComprasCompleto[indexPath.row].calificacion?[0].calificacion)!
                    cell.floatRatingView.rating = Float(cell.ratingValue)
                    
                    return cell
                }
            }
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoritoTableViewCell")  as! FavoritoTableViewCell
            
            if let amountString = model.publicacionesFavoritas[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombreProducto.text = model.publicacionesFavoritas[indexPath.row].nombre
            
            if (model.publicacionesFavoritas[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (model.publicacionesFavoritas[indexPath.row].idPublicacion)! + "/" + (model.publicacionesFavoritas[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
            }
            
            return cell
            
        default:
            break
        }
        
        return cell
    }
    
    // Celda con botón
    func buttonAction(sender: UIButton!)
    {
        modelUsuario.publicacionCarrito = (model.publicacionesEnCarrito[sender.tag])
        
        self.performSegue(withIdentifier: "confirmacionUnoDesdeCarritoCompras", sender: self)
    }
    
    func confirmarCompra(sender: UIButton!)
    {
        modelUsuario.compra = modelUsuario.misComprasCompleto[sender.tag]
        
        let alert:UIAlertController = UIAlertController(title: "¡Confirmación!", message: "¿Confirmas dar por cerrada la compra?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
            
            ComandoUsuario.eliminarCompraDeAbierta(compra: self.modelUsuario.compra)
            self.modelUsuario.compra.pedido?[0].estado = "Cerrada"
            ComandoUsuario.confirmarCompra(compra: self.modelUsuario.compra)
            
            if self.readStringFromFile() == ""
            {
                self.performSegue(withIdentifier: "avisoCalificacionDesdeCarrito", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "calificacionPublicacionDesdeCarrito", sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func rechazarCompra(sender: UIButton!)
    {
        let alert:UIAlertController = UIAlertController(title: "", message: "¿Cuál es el motivo de tu rechazo?", preferredStyle: .actionSheet)
        
        let enviarRechazoUno = UIAlertAction(title: "El producto/servicio no ha llegado", style: .default) { (_) -> Void in
            
            print("Esperando acción")
            //UIAlertAction in self .editarTipo()
        }
        
        let enviarRechazoDos = UIAlertAction(title: "El producto no concuerda", style: .default) { (_) -> Void in
            print("Esperando acción")
            //UIAlertAction in self .editarArticulo()
        }
        
        let enviarRechazoTres = UIAlertAction(title: "El producto está en mal estado", style: .default) { (_) -> Void in
            print("Esperando acción")
            //UIAlertAction in self .editarFotos()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(enviarRechazoUno)
        alert.addAction(enviarRechazoDos)
        alert.addAction(enviarRechazoTres)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func calificarCompra(sender: UIButton!)
    {
        modelUsuario.compra = modelUsuario.misComprasCompleto[sender.tag]
        
        if self.readStringFromFile() == ""
        {
            self.performSegue(withIdentifier: "avisoCalificacionDesdeCarrito", sender: self)
        } else
        {
            self.performSegue(withIdentifier: "calificacionPublicacionDesdeCarrito", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            modelOferente.publicacion = (model.publicacionesEnCarrito[indexPath.row].publicacionCompra)
            
            if (modelOferente.publicacion.servicio)!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeVistaCarrito", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeVistaCarrito", sender: self)
            }
        case 1:
            modelUsuario.compra = modelUsuario.misComprasCompleto[indexPath.row]
            
            ComandoOferente.getOferente(uid: modelUsuario.compra.idOferente)
            
            NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.verCompra(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
            
        case 2:
            modelOferente.publicacion = model.publicacionesFavoritas[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeVistaCarrito", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeVistaCarrito", sender: self)
            }
        default:
            break
        }
    }
    
    func verCompra(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "compraExitosaDesdeMisCompras", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            return 90
        case 1:
            return 90
        case 2:
            return 100
        default:
            break
        }
        
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        segCtrlCarrito.selectedSegmentIndex = modelUsuario.selectedControlIndex
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoCalificacionesPublicaciones"), object: nil)
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
        
        if (segue.identifier == "compraExitosaDesdeMisCompras")
        {
            let detailController = segue.destination as! CompraExitosaViewController
            detailController.vistoDesdeMisCompras = true
        }
    }
    
    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
    
    // Leer texto de archivo .txt
    
    func readStringFromFile() -> NSString
    {
        let fileName = "AvisoCalificacion"
        var inString = ""
        
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt")
        {
            // Then reading it back from the file
            
            do {
                inString = try String(contentsOf: fileURL)
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            print("Read from the file: \(inString)")
            
        }
        
        return inString as NSString
    }
}
