//
//  PublicacionTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 11/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionTableViewCell: UITableViewCell
{
    @IBOutlet var imgProducto: UIImageView!
    @IBOutlet var imgDestacado: UIImageView!
    @IBOutlet var lblPrecio: UILabel!
    @IBOutlet var lblNombreProducto: UILabel!
    @IBOutlet weak var numeroPreguntas: UILabel!    
    @IBOutlet weak var imgCirculo: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        imgProducto.translatesAutoresizingMaskIntoConstraints = false
        imgProducto.layer.masksToBounds = true
        imgProducto.contentMode = .scaleAspectFill
        imgProducto.leftAnchor.constraint(equalTo: imgProducto.leftAnchor, constant: 8).isActive = true
        imgProducto.centerYAnchor.constraint(equalTo: imgProducto.centerYAnchor).isActive = true
        imgProducto.widthAnchor.constraint(equalToConstant: imgProducto.frame.width).isActive = true
        imgProducto.heightAnchor.constraint(equalToConstant: imgProducto.frame.height).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
