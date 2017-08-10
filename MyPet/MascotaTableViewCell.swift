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
        
        imgFotoMascota.translatesAutoresizingMaskIntoConstraints = false
        imgFotoMascota.layer.masksToBounds = true
        imgFotoMascota.contentMode = .scaleAspectFill
        imgFotoMascota.leftAnchor.constraint(equalTo: imgFotoMascota.leftAnchor, constant: 8).isActive = true
        imgFotoMascota.centerYAnchor.constraint(equalTo: imgFotoMascota.centerYAnchor).isActive = true
        imgFotoMascota.widthAnchor.constraint(equalToConstant: imgFotoMascota.frame.width).isActive = true
        imgFotoMascota.heightAnchor.constraint(equalToConstant: imgFotoMascota.frame.height).isActive = true
        imgFotoMascota.layer.cornerRadius = imgFotoMascota.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
