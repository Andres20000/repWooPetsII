//
//  ResenaCompradoresViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 26/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ResenaCompradoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let modelUsuario = ModeloUsuario.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var lblReseñas: UILabel!
    @IBOutlet var tableResenas: UITableView!
    
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
            barFixedSpace.width = 25.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 70.0
        }
        
        var sumaCalificacion = 0
        
        for calificacion in modelUsuario.calificacionesPublicacion
        {
            print("calificacion: \(calificacion.calificacion)")
            sumaCalificacion = sumaCalificacion + calificacion.calificacion
            print("suma: \(sumaCalificacion)")
        }
        
        let promedioCalificacion = Float(sumaCalificacion) / Float(modelUsuario.calificacionesPublicacion.count)
        print("suma: \(sumaCalificacion) - Q Calificación: \(modelUsuario.calificacionesPublicacion.count) - promedio: \(promedioCalificacion)")
        
        if modelUsuario.calificacionesPublicacion.count == 0
        {
            lblRating.text = "0"
            lblReseñas.text = "0 reseñas"
        } else
        {
            lblRating.text = "\(promedioCalificacion)"
            
            if modelUsuario.calificacionesPublicacion.count == 1
            {
                lblReseñas.text = "1 reseña"
            } else
            {
                lblReseñas.text = "\(modelUsuario.calificacionesPublicacion.count) reseñas"
            }
        }
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "imgEstrellaVacia")
        self.floatRatingView.fullImage = UIImage(named: "imgEstrellaCompleta")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.minRating = 0
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = promedioCalificacion
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = true
        
        let nib = UINib(nibName: "ResenaTableViewCell", bundle: nil)
        tableResenas.register(nib, forCellReuseIdentifier: "resenaTableViewCell")
        
        tableResenas.rowHeight = UITableViewAutomaticDimension
        tableResenas.estimatedRowHeight = 85
        
        tableResenas.reloadData()
    }

    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if modelUsuario.calificacionesPublicacion.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tableResenas)
            
            tableResenas.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("Actualmente no hay opiniones de otros compradores", tableView: tableResenas)
            
            tableResenas.separatorStyle = .none
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return modelUsuario.calificacionesPublicacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resenaTableViewCell")  as! ResenaTableViewCell
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 0
        {
            cell.imgEstrellaUno.isHidden = true
            cell.imgEstrellaDos.isHidden = true
            cell.imgEstrellaTres.isHidden = true
            cell.imgEstrellaCuatro.isHidden = true
            cell.imgEstrellaCinco.isHidden = true
            
        }
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 1
        {
            cell.imgEstrellaUno.isHidden = false
            cell.imgEstrellaDos.isHidden = true
            cell.imgEstrellaTres.isHidden = true
            cell.imgEstrellaCuatro.isHidden = true
            cell.imgEstrellaCinco.isHidden = true
        }
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 2
        {
            cell.imgEstrellaUno.isHidden = false
            cell.imgEstrellaDos.isHidden = false
            cell.imgEstrellaTres.isHidden = true
            cell.imgEstrellaCuatro.isHidden = true
            cell.imgEstrellaCinco.isHidden = true
        }
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 3
        {
            cell.imgEstrellaUno.isHidden = false
            cell.imgEstrellaDos.isHidden = false
            cell.imgEstrellaTres.isHidden = false
            cell.imgEstrellaCuatro.isHidden = true
            cell.imgEstrellaCinco.isHidden = true
        }
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 4
        {
            cell.imgEstrellaUno.isHidden = false
            cell.imgEstrellaDos.isHidden = false
            cell.imgEstrellaTres.isHidden = false
            cell.imgEstrellaCuatro.isHidden = false
            cell.imgEstrellaCinco.isHidden = true
        }
        
        if modelUsuario.calificacionesPublicacion[indexPath.row].calificacion == 5
        {
            cell.imgEstrellaUno.isHidden = false
            cell.imgEstrellaDos.isHidden = false
            cell.imgEstrellaTres.isHidden = false
            cell.imgEstrellaCuatro.isHidden = false
            cell.imgEstrellaCinco.isHidden = false
        }
        
        cell.lblFecha.text = modelUsuario.calificacionesPublicacion[indexPath.row].fecha
        
        let cliente = modelOferente.misUsuarios[modelUsuario.calificacionesPublicacion[indexPath.row].idCliente]
        
        if cliente != nil
        {
            cell.lblUsuario.text = (cliente?.datosComplementarios![0].nombre)! + " " +  (cliente?.datosComplementarios![0].apellido)!
        }
        else
        {
            ComandoPreguntasOferente.getMiniUsuario(uid: modelUsuario.calificacionesPublicacion[indexPath.row].idCliente)
        }
        
        cell.lblResena.text = modelUsuario.calificacionesPublicacion[indexPath.row].comentario
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionada")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
