//
//  AvisoCarritoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 9/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AvisoCarritoViewController: UIViewController
{
    @IBOutlet var btnEntendido: UIButton!
    @IBOutlet var btnOmitir: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnEntendido.layer.cornerRadius = 10.0
        btnOmitir.layer.cornerRadius = 10.0
    }
    
    @IBAction func continuar(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func omitirAviso(_ sender: Any)
    {
        self.writeStringToFile()
        dismiss(animated: true, completion: nil)
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
        let fileName = "AvisoCarrito"
        
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
