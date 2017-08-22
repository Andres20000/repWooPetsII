    //
//  ChatOferente.swift
//  MyPet
//
//  Created by Andres Garcia on 8/10/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ChatOferente:  UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    @IBOutlet var tabla: UITableView!
    
    @IBOutlet weak var titulo: UIBarButtonItem!
    
    let model = ModeloOferente.sharedInstance
    
    var idPublicacion = ""
    var selectedindexPath:IndexPath?
    var filtroIdCliente:String?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "ChatCelda", bundle: nil)
        tabla.register(nib, forCellReuseIdentifier: "ChatCelda")
        let nib2 = UINib(nibName: "ChatCeldaSinRespuesta", bundle: nil)
        tabla.register(nib2, forCellReuseIdentifier: "ChatCeldaSinRespuesta")
        
        
        let nib1 = UINib(nibName: "HeaderPreguntaCelda", bundle: nil)
        tabla.register(nib1, forCellReuseIdentifier: "HeaderPreguntaCelda")
        
        tabla.rowHeight = UITableViewAutomaticDimension
        tabla.estimatedRowHeight = 100
        
        let ofer = model.getPublicacion(idPublicacion: idPublicacion)
        titulo.title = ofer!.nombre
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintar), name:NSNotification.Name(rawValue:"cargoMiniUsuario"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintar), name:NSNotification.Name(rawValue:"cargoPregunta"), object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tabla.reloadData()
        
        
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

        if filtroIdCliente == nil {
        
            return model.getIdsClientes(de: idPublicacion).count
        }
        else {
            return 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if filtroIdCliente != nil {
            
            let pregus = model.getPreguntas(de: idPublicacion, idCliente: filtroIdCliente!)
            return pregus.count
            
        } else {
            let clientes =  model.getIdsClientes(de: idPublicacion)
            
            let pregus = model.getPreguntas(de: idPublicacion, idCliente: clientes[section])
            
            return pregus.count
            
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var clientes:[String] = []
        
        if filtroIdCliente == nil {
        
            clientes =  model.getIdsClientes(de: idPublicacion)
        } else {
            
            clientes =  [filtroIdCliente!]
        }
        
        
        let pregunta = model.getPreguntas(de: idPublicacion, idCliente: clientes[indexPath.section])[indexPath.row]
        
        
        
        
        print("*******************ROW \(indexPath.row)")
        
        if pregunta.tieneRespuesta() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCelda")  as! ChatCelda
            
            cell.hora.text = pregunta.fechaPregunta
            cell.pregunta.text = pregunta.pregunta
            cell.respuesta.text = pregunta.respuesta
            return cell
            
        }else {
            print("No tiene respuesta: \(pregunta.respuesta)  a la pregunta:  \(pregunta.pregunta!)" )
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCeldaSinRespuesta")  as! ChatCeldaSinRespuesta
            cell.hora.text = pregunta.fechaPregunta
            cell.pregunta.text = pregunta.pregunta
            cell.tag = indexPath.row
            cell.boton.addTarget(self, action: #selector(self.didTapResponder(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    
    
    
    func didTapResponder(_ boton:UIButton) {
        
        let touchPoint = boton.convert(CGPoint.zero, to: self.tabla)
        selectedindexPath = tabla.indexPathForRow(at: touchPoint)
        performSegue(withIdentifier: "ingresarRespuesta", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderPreguntaCelda")  as! HeaderPreguntaCeldaTableViewCell
        
        let clientes =  model.getIdsClientes(de: idPublicacion)
        let idCliente = clientes[section]
        let clie = model.misUsuarios[idCliente]
        
        if clie != nil {
            cell.nombre.text = (clie?.datosComplementarios![0].nombre)! + " " +  (clie?.datosComplementarios![0].apellido)!
        }
        else {
            ComandoPreguntasOferente.getMiniUsuario(uid: idCliente)
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70 
    }
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "ingresarRespuesta"){
            let clientes =  model.getIdsClientes(de: idPublicacion)
            
            let pregunta = model.getPreguntas(de: idPublicacion, idCliente: clientes[selectedindexPath!.section])[selectedindexPath!.row]
            
            let detailController = segue.destination as! RespuestaVC
            detailController.pregunta = pregunta
        }
    }
    
    func repintar() {
        
        tabla.reloadData()
    }
    
    
    
}

    
