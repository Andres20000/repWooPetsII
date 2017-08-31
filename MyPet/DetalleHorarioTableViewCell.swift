//
//  DetalleHorarioTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 22/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetalleHorarioTableViewCell: UITableViewCell
{
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var lblDiasSemana: UILabel!
    @IBOutlet var lblHorarioDiasSemana: UILabel!
    @IBOutlet var lblJornadaContinuaSemana: UILabel!
    @IBOutlet var lblDiasFestivos: UILabel!
    @IBOutlet var lblHorarioDiasFestivos: UILabel!
    @IBOutlet var lblJornadaContinuaFestivos: UILabel!
    
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
