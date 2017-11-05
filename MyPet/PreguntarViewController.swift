//
//  PreguntarViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class PreguntarViewController: UIViewController, UITextViewDelegate
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    var preguntaFormulada = Pregunta()
    
    @IBOutlet var barItemOK: UIBarButtonItem!
    @IBOutlet var textPregunta: UITextView!
    
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
        
        barItemOK.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 17.0)!,
            NSForegroundColorAttributeName: UIColor.white],
                                          for: UIControlState.normal)
        
        textPregunta.text = "¿Cuál es tu duda? Escribe aquí."
        self .toolBarTextView(textPregunta)
    }
    
    // #pragma mark - textView
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == "¿Cuál es tu duda? Escribe aquí."
        {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text.characters.count) < 10
        {
            self.mostrarAlerta(titulo: "!Advertencia!", mensaje: "La pregunta debe ser mínimo de 10 caracteres")
            
            textView.text = "¿Cuál es tu duda? Escribe aquí."
            preguntaFormulada.pregunta = ""
            
        }else
        {
            preguntaFormulada.pregunta = textView.text
        }
    }
    
    @IBAction func enviarPregunta(_ sender: Any)
    {
        view.endEditing(true)
        
        if preguntaFormulada.pregunta == ""
        {
            self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Formula tu pregunta para poder enviarla")
        } else
        {
            let  user = Auth.auth().currentUser
            let nowDate = NSDate()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            let dateString = dateFormatter.string(from: nowDate as Date)
            
            preguntaFormulada.fechaPregunta = dateString
            preguntaFormulada.idCliente = (user?.uid)!
            preguntaFormulada.idOferente = modelOferente.publicacion.idOferente
            preguntaFormulada.idPublicacion = modelOferente.publicacion.idPublicacion
            
            ComandoUsuario.preguntarEnPublicacion(pregunta: preguntaFormulada)
            
            let alert:UIAlertController = UIAlertController(title: "¡Envío exitoso!", message: "Tu pregunta ha sido enviada a la persona encargada. Mas adelante te llegará una notificación informándote su respuesta", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "OK", style: .default)
            {
                UIAlertAction in self.avisoPreguntaEnviada()
            }
            
            // Add the actions
            alert.addAction(continuarAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func avisoPreguntaEnviada()
    {
        ComandoPublicacion.getPreguntasRespuestasPublicacionOferente(idPublicacion: modelOferente.publicacion.idPublicacion!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreguntarViewController.cargarPregunta(_:)), name:NSNotification.Name(rawValue:"cargoPreguntasRespuestasPublicacion"), object: nil)
    }
    
    func cargarPregunta(_ notification: Notification)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
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
    
    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
    
    // Toolbar in textField
    func toolBarTextView(_ textView : UITextView)
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Ocultar", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textView.inputAccessoryView = toolBar
    }
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
}
