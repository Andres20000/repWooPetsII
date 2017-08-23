//
//  PublicacionesOferenteSinRespuesta.swift
//  MyPet
//
//  Created by Andres Garcia on 8/10/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionesOferenteSinRespuesta: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    @IBOutlet var tabla: UITableView!
    
    let model = ModeloOferente.sharedInstance
    
    var publicaciones:[String] = []
    
    var selectedPublicacion = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "PublicacionTableViewCell", bundle: nil)
        tabla.register(nib, forCellReuseIdentifier: "publicacionTableViewCell")

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXPregunta), name:NSNotification.Name(rawValue:"cargoPregunta"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        publicaciones = model.getIdsPublicacionesSinRespuesta()
        
        
        if publicaciones.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tabla)
            
            tabla.separatorStyle = .singleLine
            
            return 1
        } else
        {
            
            Comando.init().EmptyMessage("No tienes publicaciones con respuesta sin responder.", tableView: tabla)
            tabla.separatorStyle = .none
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        publicaciones = model.getIdsPublicacionesSinRespuesta()
        return publicaciones.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let oferta = model.getPublicacion(idPublicacion: publicaciones[indexPath.row])
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicacionTableViewCell")  as! PublicacionTableViewCell
        
        
        
        if let amountString = oferta?.precio?.currencyInputFormatting()
        {
            cell.lblPrecio.text = amountString
        }
        
        cell.lblNombreProducto.text = oferta?.nombre ?? "--"
        
        
        if oferta == nil {
            return cell
        }
        
        
        //Pintamos si numero de preguntas sin contestar
        let preguntas = model.numeroPreguntasSinRespuesta(idPublicacion: oferta!.idPublicacion!)
        
        if  preguntas == 0 {
            cell.imgCirculo.isHidden = true
        }
        else {
            cell.imgCirculo.isHidden = false
            cell.numeroPreguntas.text = String(preguntas)
        }
        
        //Pintamos si esta destacado
        if oferta!.destacado!
        {
            cell.imgDestacado.isHidden = false
        } else
        {
            cell.imgDestacado.isHidden = true
        }
        
        if (oferta!.fotos?.count)! > 0
        {
            let path = "productos/" + (oferta!.idPublicacion)! + "/" + (oferta!.fotos?[0].nombreFoto)!
            
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
        
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        
        let oferta = model.getPublicacion(idPublicacion: publicaciones[indexPath.row])
        selectedPublicacion = oferta!.idPublicacion!
        
        
        self.performSegue(withIdentifier: "verDetalle", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    
        // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "verDetalle")
        {
            let detailController = segue.destination as! ChatOferente
            detailController.idPublicacion = selectedPublicacion
        }
    }
    
    func repintarXPregunta(){
        tabla.reloadData()
        
    }

    
}
