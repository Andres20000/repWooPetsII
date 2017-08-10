//
//  MascotaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class MascotaTableViewCell: UITableViewCell
{
    @IBOutlet var imgFotoMascota: UIImageView!
    @IBOutlet var btnActivarPerfil: UIButton!
    
    @IBOutlet var lblNombreMascota: UILabel!
    @IBOutlet var lblEdadMascota: UILabel!
    
    @IBOutlet var btnAlarmas: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
