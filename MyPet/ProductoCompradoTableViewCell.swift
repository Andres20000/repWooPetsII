//
//  ProductoCompradoTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 17/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ProductoCompradoTableViewCell: UITableViewCell
{
    @IBOutlet var lblNombrePublicacion: UILabel!
    @IBOutlet var lblCantidad: UILabel!
    @IBOutlet var lblTextoEntrega: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var lblTelefono: UILabel!
    @IBOutlet var lblTotal: UILabel!
    
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
