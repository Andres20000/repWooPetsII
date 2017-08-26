//
//  CalificacionPublicacionViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CalificacionPublicacionViewController: UIViewController, FloatRatingViewDelegate, UITextViewDelegate
{
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var textComentario: UITextView!
    @IBOutlet var btnEnviar: UIButton!
    
    @IBAction func backView(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Confirmar!", message: "¿Está seguro de abandonar la vista sin enviar una calificación?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí", style: .default)
        {
            UIAlertAction in self.abandonar()
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
    
    func abandonar()
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeCalificacionPublicacion", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "imgEstrellaVacia")
        self.floatRatingView.fullImage = UIImage(named: "imgEstrellaCompleta")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.minRating = 0
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = 0
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
        
        textComentario.text = "Escribe aquí tus observaciones"
        
        textComentario.layer.cornerRadius = 5.0
        textComentario.layer.borderWidth = 0.5
        textComentario.layer.borderColor = UIColor.init(red: 0.901960784313725, green: 0.901960784313725, blue: 0.901960784313725, alpha: 1.0).cgColor
        
        self .toolBarTextView(textComentario)
        
        btnEnviar.layer.cornerRadius = 10.0
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float)
    {
        self.view.endEditing(true)
        print(NSString(format: "%.f", self.floatRatingView.rating) as String)
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    {
        self.view.endEditing(true)
        print(NSString(format: "%.f", self.floatRatingView.rating) as String)
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    // #pragma mark - textView
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        animateViewMoving(up: true, moveValue: 100)
        
        if textView.text == "Escribe aquí tus observaciones"
        {
            textView.text = ""
            //textView.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        animateViewMoving(up: false, moveValue: 100)
        
        if (textView.text.characters.count) < 15
        {
            self.mostrarAlerta(titulo: "!Advertencia!", mensaje: "Tu observación debe ser mínimo de 15 caracteres")
            
            textView.text = "Escribe aquí tus observaciones"
            
        }else
        {
            print("Guardar observación")
        }
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
    
    // Toolbar in textView
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
    
    // Move show/hide Keypoard
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}
