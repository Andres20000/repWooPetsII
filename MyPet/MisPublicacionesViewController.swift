//
//  MisPublicacionesViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class MisPublicacionesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var btnActivas: UIButton!
    @IBOutlet var btnInactivas: UIButton!
    
    let model = ModeloOferente.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    var publicaciones = [PublicacionOferente]()
    
    var estadoPublicacion = ""
    
    @IBOutlet var tableMisPublicaciones: UITableView!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "PublicacionTableViewCell", bundle: nil)
        tableMisPublicaciones.register(nib, forCellReuseIdentifier: "publicacionTableViewCell")
        
        estadoPublicacion = "activas"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXPregunta), name:NSNotification.Name(rawValue:"cargoPregunta"), object: nil)
        
        
    }
    
    @objc func cargarPublicaciones(_ notification: Notification)
    {
        if estadoPublicacion == "activas"
        {
            publicaciones = model.publicacionesActivas
        }else
        {
            publicaciones = model.publicacionesInactivas
        }
        
        tableMisPublicaciones.reloadData()
    }
    
    
    @objc func repintarXPregunta(){
        if estadoPublicacion == "activas"
        {
            publicaciones = model.publicacionesActivas
        }else
        {
            publicaciones = model.publicacionesInactivas
        }
        
        tableMisPublicaciones.reloadData()
        
    }
    
    
    @IBAction func mostrarPublicaciones(_ sender: Any)
    {
        let btnEstado:UIButton = sender as! UIButton
        
        if btnEstado.tag == 1
        {
            btnActivas.setImage(UIImage(named: "btnActivoAzul"), for: UIControlState.normal)
            btnInactivas.setImage(UIImage(named: "btnInactivoGris"), for: UIControlState.normal)
            
            estadoPublicacion = "activas"
            
        } else
        {
            btnActivas.setImage(UIImage(named: "btnActivoGris"), for: UIControlState.normal)
            btnInactivas.setImage(UIImage(named: "btnInactivoAzul"), for: UIControlState.normal)
            
            estadoPublicacion = "inactivas"
        }
        
        model.publicacionesActivas.removeAll()
        model.publicacionesInactivas.removeAll()
        
        ComandoPublicacion.getPublicacionesOferente(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MisPublicacionesViewController.cargarPublicaciones(_:)), name:NSNotification.Name(rawValue:"cargoPublicacionesOferente"), object: nil)
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if publicaciones.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tableMisPublicaciones)
            
            tableMisPublicaciones.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("No tienes publicaciones \(estadoPublicacion)", tableView: tableMisPublicaciones)
            
            tableMisPublicaciones.separatorStyle = .none
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return publicaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        model.publicacion = publicaciones[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicacionTableViewCell")  as! PublicacionTableViewCell
        
        if let amountString = model.publicacion.precio?.currencyInputFormatting()
        {
            cell.lblPrecio.text = amountString
        }
        
        cell.lblNombreProducto.text = model.publicacion.nombre
        
        
        //Pintamos si numero de preguntas sin contestar  --- 
        // Nota como el dibujo de las peguntas y el de las ventas es el mismo entonces aca en publicaciones no se pone nada.
        //let preguntas = model.numeroPreguntasSinRespuesta(idPublicacion: model.publicacion.idPublicacion!)
        
        //if  preguntas == 0 {
            cell.imgCirculo.isHidden = true
        //}
        //else {
          //  cell.imgCirculo.isHidden = false
            //cell.numeroPreguntas.text = String(preguntas)
        //}

        
        
        if model.publicacion.destacado!
        {
            cell.imgDestacado.isHidden = false
        } else
        {
            cell.imgDestacado.isHidden = true
        }
        
        if (model.publicacion.fotos?.count)! > 0
        {
            let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (model.publicacion.fotos?[0].nombreFoto)!
            
            cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        model.publicacion = publicaciones[(indexPath as NSIndexPath).row]
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "verDetallePublicacionDesdeMisPublicaciones", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        model.publicacionesActivas.removeAll()
        model.publicacionesInactivas.removeAll()
        
        ComandoPublicacion.getPublicacionesOferente(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MisPublicacionesViewController.cargarPublicaciones(_:)), name:NSNotification.Name(rawValue:"cargoPublicacionesOferente"), object: nil)
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
        
        if (segue.identifier == "verDetallePublicacionDesdeMisPublicaciones")
        {
            let detailController = segue.destination as! DetallePublicacionOferenteViewController
            detailController.vistoDesde = "MisPublicaciones"
        }
    }

}
