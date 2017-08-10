//
//  AlertaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 4/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AlertaTableViewCell: UITableViewCell
{
    @IBOutlet var lblTipo: UILabel!
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var lblFechaHora: UILabel!
    @IBOutlet var swEstadoAlarma: UISwitch!
    
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
