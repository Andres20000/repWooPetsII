//
//  AvisoCalificacionViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AvisoCalificacionViewController: UIViewController
{
    @IBOutlet var btnCalificar: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnCalificar.layer.cornerRadius = 10.0
    }
    
    @IBAction func calificar(_ sender: Any)
    {
        self.performSegue(withIdentifier: "calificacionPublicacionDesdeAvisoCalificacion", sender: self)
    }
    
    @IBAction func omitirAviso(_ sender: Any)
    {
        self.writeStringToFile()
        self.performSegue(withIdentifier: "calificacionPublicacionDesdeAvisoCalificacion", sender: self)
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
    
    // Crear archivo .txt
    
    func writeStringToFile()
    {
        let fileName = "AvisoCalificacion"
        
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            
            // Write to the file Test
            let outString = "No"
            do {
                try outString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
    }

}
