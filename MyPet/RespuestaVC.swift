//
//  RespuestaVC.swift
//  MyPet
//
//  Created by Andres Garcia on 8/11/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class RespuestaVC: UIViewController {


    @IBOutlet weak var texto: UITextView!

    var pregunta:Pregunta?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        texto.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapOk(_ sender: Any) {
    
    
        if texto.text != ""  {
            
            pregunta!.respuesta = texto.text
            ComandoPreguntasOferente.updateRespuesta(respuesta: texto.text!, idPregunta: pregunta!.idPregunta!)
            dismiss(animated: true, completion: nil)
        }
        
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


}
