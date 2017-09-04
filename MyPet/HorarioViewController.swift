//
//  HorarioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 3/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class HorarioViewController: UIViewController, UITextFieldDelegate
{
    var model  = ModeloOferente.sharedInstance
    var atencionSemana = ModeloOferente.sharedInstance.horarioAtencionSemana
    var atencionFestivo = ModeloOferente.sharedInstance.horarioAtencionFinSemana
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTop1LayoutConstraint: NSLayoutConstraint?
    @IBOutlet var spaceTop2LayoutConstraint: NSLayoutConstraint?
    
    var datePicker : UIDatePicker!
    var textFieldGenerico: UITextField!
    
    @IBOutlet var btnDiaL: UIButton!
    @IBOutlet var btnDiaM: UIButton!
    @IBOutlet var btnDiaX: UIButton!
    @IBOutlet var btnDiaJ: UIButton!
    @IBOutlet var btnDiaV: UIButton!
    @IBOutlet var txtDesdeSemana: UITextField!
    @IBOutlet var txtHastaSemana: UITextField!
    @IBOutlet var swiJornadaContinuaSemana: UISwitch!
    
    @IBOutlet var btnDiaS: UIButton!
    @IBOutlet var btnDiaD: UIButton!
    @IBOutlet var btnDiaF: UIButton!
    @IBOutlet var txtDesdeFinSemana: UITextField!
    @IBOutlet var txtHastaFinSemana: UITextField!
    @IBOutlet var swiJornadaContinuaFinSemana: UISwitch!
    
    @IBOutlet var btnAceptar: UIButton!
    
    var diaL:Bool = false
    var diaM:Bool = false
    var diaX:Bool = false
    var diaJ:Bool = false
    var diaV:Bool = false
    var diaS:Bool = false
    var diaD:Bool = false
    var diaF:Bool = false
    
    var horarioPara:String?
    
    @IBAction func backView(_ sender: Any)
    {
        setDias()
        if (atencionSemana?.dias.count)! < 1 && (atencionFestivo?.dias.count)! < 1
        {
            if horarioPara == "NegocioOferente"
            {
                if model.oferente[0].horario?.count == 0
                {
                    model.horarioSemana.dias = ""
                    model.horarioFestivo.dias = ""
                }
            } else
            {
                if model.publicacion.horario?.count == 0
                {
                    model.horarioSemana.dias = ""
                    model.horarioFestivo.dias = ""
                }
            }
            
        }
        
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
        
        // Definir espacio para cada dispositivo
        if DeviceType.IS_IPHONE_5
        {
            self.spaceTop1LayoutConstraint?.constant = 50.0
            self.spaceTop2LayoutConstraint?.constant = 50.0
        }
        
        btnDiaL.layer.cornerRadius = 22.0
        btnDiaM.layer.cornerRadius = 22.0
        btnDiaX.layer.cornerRadius = 22.0
        btnDiaJ.layer.cornerRadius = 22.0
        btnDiaV.layer.cornerRadius = 22.0
        btnDiaS.layer.cornerRadius = 22.0
        btnDiaD.layer.cornerRadius = 22.0
        btnDiaF.layer.cornerRadius = 10.0
        btnAceptar.layer.cornerRadius = 10.0
        
        diaL = false
        diaM = false
        diaX = false
        diaJ = false
        diaV = false
        diaS = false
        diaD = false
        diaF = false
        
        diaL = btnDiaL.isOn(active: diaL, button: btnDiaL)
        diaM = btnDiaM.isOn(active: diaM, button: btnDiaM)
        diaX = btnDiaX.isOn(active: diaX, button: btnDiaX)
        diaJ = btnDiaJ.isOn(active: diaJ, button: btnDiaJ)
        diaV = btnDiaV.isOn(active: diaV, button: btnDiaV)
        diaS = btnDiaS.isOn(active: diaS, button: btnDiaS)
        diaD = btnDiaD.isOn(active: diaD, button: btnDiaD)
        diaF = btnDiaF.isOn(active: diaF, button: btnDiaF)
        
        if horarioPara == "NegocioOferente"
        {
            if model.oferente[0].horario?.count == 0
            {
                return
            }else
            {
                if model.oferente[0].horario?.count == 1
                {
                    if atencionSemana == nil {
                        atencionSemana = HorarioAtencion()
                    }
                    
                    atencionSemana?.adicionarDia(dias: (model.oferente[0].horario?[0].dias)!)
                    txtDesdeSemana.text = (model.oferente[0].horario?[0].horaInicio)!
                    txtHastaSemana.text = (model.oferente[0].horario?[0].horaCierre)!
                    swiJornadaContinuaSemana.setOn((model.oferente[0].horario?[0].sinJornadaContinua)!, animated: true)
                    
                } else
                {
                    if atencionSemana == nil {
                        atencionSemana = HorarioAtencion()
                    }
                    
                    atencionSemana?.adicionarDia(dias: (model.oferente[0].horario?[0].dias)!)
                    txtDesdeSemana.text = (model.oferente[0].horario?[0].horaInicio)!
                    txtHastaSemana.text = (model.oferente[0].horario?[0].horaCierre)!
                    swiJornadaContinuaSemana.setOn((model.oferente[0].horario?[0].sinJornadaContinua)!, animated: true)
                    
                    if atencionFestivo == nil {
                        atencionFestivo = HorarioAtencion()
                    }
                    
                    atencionFestivo?.adicionarDia(dias: (model.oferente[0].horario?[1].dias)!)
                    txtDesdeFinSemana.text = (model.oferente[0].horario?[1].horaInicio)!
                    txtHastaFinSemana.text = (model.oferente[0].horario?[1].horaCierre)!
                    swiJornadaContinuaFinSemana.setOn((model.oferente[0].horario?[1].sinJornadaContinua)!, animated: true)
                }
            }
        } else
        {
            if model.publicacion.horario?.count == 0
            {
                return
            }else
            {
                if model.publicacion.horario?.count == 1
                {
                    if atencionSemana == nil {
                        atencionSemana = HorarioAtencion()
                    }
                    
                    atencionSemana?.adicionarDia(dias: (model.publicacion.horario?[0].dias)!)
                    txtDesdeSemana.text = (model.publicacion.horario?[0].horaInicio)!
                    txtHastaSemana.text = (model.publicacion.horario?[0].horaCierre)!
                    swiJornadaContinuaSemana.setOn((model.publicacion.horario?[0].sinJornadaContinua)!, animated: true)
                    
                } else
                {
                    if atencionSemana == nil {
                        atencionSemana = HorarioAtencion()
                    }
                    
                    atencionSemana?.adicionarDia(dias: (model.publicacion.horario?[0].dias)!)
                    txtDesdeSemana.text = (model.publicacion.horario?[0].horaInicio)!
                    txtHastaSemana.text = (model.publicacion.horario?[0].horaCierre)!
                    swiJornadaContinuaSemana.setOn((model.publicacion.horario?[0].sinJornadaContinua)!, animated: true)
                    
                    if atencionFestivo == nil {
                        atencionFestivo = HorarioAtencion()
                    }
                    
                    atencionFestivo?.adicionarDia(dias: (model.publicacion.horario?[1].dias)!)
                    txtDesdeFinSemana.text = (model.publicacion.horario?[1].horaInicio)!
                    txtHastaFinSemana.text = (model.publicacion.horario?[1].horaCierre)!
                    swiJornadaContinuaFinSemana.setOn((model.publicacion.horario?[1].sinJornadaContinua)!, animated: true)
                }
            }
        }
        
        diaL = btnDiaL.isOn(active: (atencionSemana?.esDiaIncluido(miDia: .lunes))!, button: btnDiaL)
        diaM = btnDiaM.isOn(active: (atencionSemana?.esDiaIncluido(miDia: .martes))!, button: btnDiaM)
        diaX = btnDiaX.isOn(active: (atencionSemana?.esDiaIncluido(miDia: .miercoles))!, button: btnDiaX)
        diaJ = btnDiaJ.isOn(active: (atencionSemana?.esDiaIncluido(miDia: .jueves))!, button: btnDiaJ)
        diaV = btnDiaV.isOn(active: (atencionSemana?.esDiaIncluido(miDia: .viernes))!, button: btnDiaV)
        
        if atencionFestivo == nil {
            atencionFestivo = HorarioAtencion()
        }
        
        if (atencionFestivo?.dias.count)! < 1 {
            return
        }
        
        diaS = btnDiaS.isOn(active: (atencionFestivo?.esDiaIncluido(miDia: .sabado))!, button: btnDiaS)
        diaD = btnDiaD.isOn(active: (atencionFestivo?.esDiaIncluido(miDia: .domingo))!, button: btnDiaD)
        diaF = btnDiaF.isOn(active: (atencionFestivo?.esDiaIncluido(miDia: .festivos))!, button: btnDiaF)
    }
    
    // Botones activar/desactivar días
    @IBAction func selectDia(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            diaL = sender.isOn(active: diaL, button: sender)
        }
        
        if sender.tag == 2
        {
            diaM = sender.isOn(active: diaM, button: sender)
        }
        
        if sender.tag == 3
        {
            diaX = sender.isOn(active: diaX, button: sender)
        }
        
        if sender.tag == 4
        {
            diaJ = sender.isOn(active: diaJ, button: sender)
        }
        
        if sender.tag == 5
        {
            diaV = sender.isOn(active: diaV, button: sender)
        }
        
        if sender.tag == 6
        {
            diaS = sender.isOn(active: diaS, button: sender)
        }
        
        if sender.tag == 7
        {
            diaD = sender.isOn(active: diaD, button: sender)
        }
        
        if sender.tag == 8
        {
            diaF = sender.isOn(active: diaF, button: sender)
        }
        
    }
    
    // DatePicker on TextField
    func pickUpDate(_ textField : UITextField)
    {
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.time
        self.datePicker.minuteInterval = 5
        self.datePicker.tag = textField.tag
        self.datePicker.addTarget(self, action: #selector(HorarioViewController.changeTimeText), for: .valueChanged)
        
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HorarioViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        textFieldGenerico = textField
    }
    
    func changeTimeText()
    {
        textFieldGenerico.text = datePicker.date.horaString()
    }
    
    func doneClick()
    {
        textFieldGenerico.resignFirstResponder()
    }
    
    // #pragma mark - textField
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self .pickUpDate(textField)
        animateViewMoving(up: true, moveValue: 145)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(up: false, moveValue: 145)
    }
    
    func setDias()
    {
        var newDiasS:[Dias] = []
        var newDiasF:[Dias] = []
        
        if !diaL {
            newDiasS.append(.lunes)
        }
        
        if !diaM {
            newDiasS.append(.martes)
        }
        
        if !diaX {
            newDiasS.append(.miercoles)
        }
        
        if !diaJ {
            newDiasS.append(.jueves)
        }
        
        if !diaV {
            newDiasS.append(.viernes)
        }
        
        if !diaS {
            newDiasF.append(.sabado)
        }
        
        if !diaD {
            newDiasF.append(.domingo)
        }
        
        if !diaF {
            newDiasF.append(.festivos)
        }
        
        if atencionSemana == nil {
            atencionSemana = HorarioAtencion()
        }
        
        atencionSemana?.dias = newDiasS
        
        if atencionFestivo == nil {
            atencionFestivo = HorarioAtencion()
        }
        
        atencionFestivo?.dias = newDiasF
    }
    
    @IBAction func aceptarHorario(_ sender: Any)
    {
        setDias()
        
        if (atencionSemana?.dias.count)! < 1
        {
            self.mostrarAlerta(titulo: "¡Información Incompleta!", mensaje: "Debes completar todos los campos. Selecciona los días")
        }else
        {
            if (txtDesdeSemana.text?.characters.count)! == 0 || (txtHastaSemana.text?.characters.count)! == 0
            {
                self.mostrarAlerta(titulo: "¡Información Incompleta!", mensaje: "Debes completar todos los campos. Registra los horarios")
            }else
            {
                if (atencionFestivo?.dias.count)! >= 1
                {
                    if (txtDesdeFinSemana.text?.characters.count)! == 0 || (txtHastaFinSemana.text?.characters.count)! == 0
                    {
                        self.mostrarAlerta(titulo: "¡Información Incompleta!", mensaje: "Debes completar todos los campos. Registra los horarios")
                        
                        return
                    }else
                    {
                        model.horarioFestivo.dias = atencionFestivo?.getDiasPegadosLargos()
                        model.horarioFestivo.horaInicio = txtDesdeFinSemana.text
                        model.horarioFestivo.horaCierre = txtHastaFinSemana.text
                        model.horarioFestivo.sinJornadaContinua = swiJornadaContinuaFinSemana.isOn
                        
                        model.horarioFestivo.diasActivos = (atencionFestivo?.dias)!
                        model.horarioFestivo.nombreArbol = "FinDeSemana"
                    }
                }
                
                if (atencionFestivo?.dias.count)! < 1
                {
                    model.horarioFestivo.dias = ""
                }
                
                model.horarioSemana.dias = atencionSemana?.getDiasPegadosLargos()
                model.horarioSemana.horaInicio = txtDesdeSemana.text
                model.horarioSemana.horaCierre = txtHastaSemana.text
                model.horarioSemana.sinJornadaContinua = swiJornadaContinuaSemana.isOn
                
                model.horarioSemana.diasActivos = (atencionSemana?.dias)!
                model.horarioSemana.nombreArbol = "Semana"
                
                dismiss(animated: true, completion: nil)
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

extension UIButton
{
    func isOn(active:Bool, button:UIButton) -> Bool
    {
        if active
        {
            button.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            return false
            
        } else
        {
            button.backgroundColor = UIColor.init(red: 0.901960784313725, green: 0.901960784313725, blue: 0.901960784313725, alpha: 1.0)
            button.setTitleColor(UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0), for: UIControlState.normal)
            return true
        }
    }
}
