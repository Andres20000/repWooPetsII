//
//  InfoVendedorViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class InfoVendedorViewController: UIViewController
{
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    
    @IBOutlet var scrollContent: UIScrollView!
    
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var lblTelefono: UILabel!
    @IBOutlet var lblCelular: UILabel!
    @IBOutlet var lblWeb: UILabel!
    @IBOutlet var lblCorreo: UILabel!
    
    @IBOutlet var lblDiasSemana: UILabel!
    @IBOutlet var lblHorarioDiasSemana: UILabel!
    @IBOutlet var lblJornadaContinuaSemana: UILabel!
    @IBOutlet var lblDiasFestivos: UILabel!
    @IBOutlet var lblHorarioDiasFestivos: UILabel!
    @IBOutlet var lblJornadaContinuaFestivos: UILabel!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            barFixedSpace.width = 45.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 85.0
        }
        
        scrollContent.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 623.0)
        
        lblNombre.text = modelOferente.oferente[0].razonSocial
        lblDireccion.text = modelOferente.oferente[0].direccion
        lblTelefono.text = modelOferente.oferente[0].telefono
        lblCelular.text = modelOferente.oferente[0].celular
        
        if modelOferente.oferente[0].paginaWeb != ""
        {
            lblWeb.text = modelOferente.oferente[0].paginaWeb
        }
        
        lblCorreo.text = modelOferente.oferente[0].correo
        
        print("Llega aquí: \((modelOferente.oferente[0].horario?.count)!)")
        
        for horario in (modelOferente.oferente[0].horario)!
        {
            print("Entra aquí")
            if horario.nombreArbol == "Semana"
            {
                lblDiasSemana.text = horario.dias
                lblHorarioDiasSemana.text = (horario.horaInicio)! + " - " + (horario.horaCierre)!
                
                if horario.sinJornadaContinua!
                {
                    lblJornadaContinuaSemana.text = "Cerramos entre 12 y 2 pm"
                } else
                {
                    lblJornadaContinuaSemana.text = "Jornada continua"
                }
                
            } else
            {
                lblDiasFestivos.isHidden = false
                lblHorarioDiasFestivos.isHidden = false
                lblJornadaContinuaFestivos.isHidden = false
                
                lblDiasFestivos.text = horario.dias
                lblHorarioDiasFestivos.text = (horario.horaInicio)! + " - " + (horario.horaCierre)!
                
                if horario.sinJornadaContinua!
                {
                    lblJornadaContinuaFestivos.text = "Cerramos entre 12 y 2 pm"
                } else
                {
                    lblJornadaContinuaFestivos.text = "Jornada continua"
                }
            }
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
