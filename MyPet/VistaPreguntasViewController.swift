//
//  VistaPreguntasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class VistaPreguntasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var tablePreguntasRespuestas: UITableView!

    var tituloVista = ""
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            barFixedSpace.width = 20.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 60.0
        }
        
        barItemTitulo.title = tituloVista
        
        let nib = UINib(nibName: "PreguntaRespuestaTableViewCell", bundle: nil)
        tablePreguntasRespuestas.register(nib, forCellReuseIdentifier: "preguntaRespuestaTableViewCell")
        
        let nib2 = UINib(nibName: "PreguntaTableViewCell", bundle: nil)
        tablePreguntasRespuestas.register(nib2, forCellReuseIdentifier: "preguntaTableViewCell")
        
        tablePreguntasRespuestas.rowHeight = UITableViewAutomaticDimension
        tablePreguntasRespuestas.estimatedRowHeight = 75
    }
    
    func refrescarVista(_ notification: Notification)
    {
        tablePreguntasRespuestas.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if model.preguntasPublicacion.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tablePreguntasRespuestas)
         
            tablePreguntasRespuestas.separatorStyle = .singleLine
         
            return 1
         } else
         {
            Comando.init().EmptyMessage("Actualmente no hay preguntas, pero puedes ser el(la) primero(a).", tableView: tablePreguntasRespuestas)
            
            tablePreguntasRespuestas.separatorStyle = .none
            
            return 1
         }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.preguntasPublicacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if model.preguntasPublicacion[indexPath.row].respuesta == ""
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preguntaTableViewCell")  as! PreguntaTableViewCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            let datePregunta = dateFormatter.date(from: model.preguntasPublicacion[indexPath.row].fechaPregunta!)
            
            cell.lblFechaPregunta.text = self.timeAgoSinceDate(datePregunta!, numericDates: true)
            
            cell.lblPreguntaUsuario.text = model.preguntasPublicacion[indexPath.row].pregunta
            
            return cell
            
        } else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preguntaRespuestaTableViewCell")  as! PreguntaRespuestaTableViewCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            let datePregunta = dateFormatter.date(from: model.preguntasPublicacion[indexPath.row].fechaPregunta!)
            
            cell.lblFechaPregunta.text = self.timeAgoSinceDate(datePregunta!, numericDates: true)
            
            cell.lblPreguntaUsuario.text = model.preguntasPublicacion[indexPath.row].pregunta
            
            let dateRespuesta = dateFormatter.date(from: model.preguntasPublicacion[indexPath.row].fechaRespuesta!)
            cell.lblFechaRespuesta.text = self.timeAgoSinceDate(dateRespuesta!, numericDates: true)
            
            cell.lblRespuestaOferente.text = model.preguntasPublicacion[indexPath.row].respuesta
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionada")
    }
    
    @IBAction func preguntar(_ sender: Any)
    {
        if modelUsuario.usuario.count == 0
        {
            self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para formular tu pregunta debes estar registrado y así poder enviarte una notificación cuando haya una respuesta")
        }else
        {
            if modelUsuario.usuario[0].datosComplementarios?.count == 0
            {
                self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para formular tu pregunta debes estar completamente registrado y así poder enviarte una notificación cuando haya una respuesta")
            } else
            {
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                
                self.performSegue(withIdentifier: "preguntarDesdeVistaPreguntas", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tablePreguntasRespuestas.reloadData()
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
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String
    {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now as Date) ? date : now as Date
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "Hace \(components.year!) años"
        } else if (components.year! >= 1){
            if (numericDates){
                return "Hace un año"
            } else {
                return "El año pasado"
            }
        } else if (components.month! >= 2) {
            return "Hace \(components.month!) meses"
        } else if (components.month! >= 1){
            if (numericDates){
                return "Hace un mes"
            } else {
                return "Último mes"
            }
        } else if (components.weekOfYear! >= 2) {
            return "Hace \(components.weekOfYear!) semanas"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "Hace una semana"
            } else {
                return "La semana pasada"
            }
        } else if (components.day! >= 2) {
            return "Hace \(components.day!) días"
        } else if (components.day! >= 1){
            if (numericDates){
                return "Hace un día"
            } else {
                return "Ayer"
            }
        } else if (components.hour! >= 2) {
            return "Hace \(components.hour!) horas"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "Hace una hora"
            } else {
                return "Hace una hora"
            }
        } else if (components.minute! >= 2) {
            return "Hace \(components.minute!) minutos"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "Hace un minuto"
            } else {
                return "Hace un minuto"
            }
        } else if (components.second! >= 55) {
            return "Hace \(components.second!) segundos"
        } else {
            return "Justo ahora"
        }
        
    }

    // Validación de datos
    
    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
}
