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
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var tableResenas: UITableView!
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblRating.text = "0"
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "imgEstrellaVacia")
        self.floatRatingView.fullImage = UIImage(named: "imgEstrellaCompleta")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.minRating = 0
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = 0.0
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
        let nib = UINib(nibName: "ResenaTableViewCell", bundle: nil)
        tableResenas.register(nib, forCellReuseIdentifier: "resenaTableViewCell")
    }

    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        /*if model.alertasMascotaSeleccionada.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tableResenas)
            
            tableResenas.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("Actualmente no hay opiniones de otros compradores", tableView: tableResenas)
            
            tableResenas.separatorStyle = .none
            
            return 1
        }*/
        Comando.init().EmptyMessage("Actualmente no hay opiniones de otros compradores", tableView: tableResenas)
        
        tableResenas.separatorStyle = .none
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return model.alertasMascotaSeleccionada.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resenaTableViewCell")  as! ResenaTableViewCell
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionada")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
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
