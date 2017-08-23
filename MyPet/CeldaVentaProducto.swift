//
//  CeldaVentaProducto.swift
//  MyPet
//
//  Created by Andres Garcia on 8/16/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CeldaVentaProducto: UITableViewCell {

    
    
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var fecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
