//
//  DireccionTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 23/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DireccionTableViewCell: UITableViewCell
{
    @IBOutlet var lblNombreDireccion: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var swEstadoDireccion: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        lblDireccion.layer.masksToBounds = true
        lblDireccion.layer.cornerRadius = 7.0
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
