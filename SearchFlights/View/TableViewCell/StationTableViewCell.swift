//
//  StationTableViewCell.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_stationName: UILabel!
    
    @IBOutlet weak var lb_stationCode: UILabel!
    
    @IBOutlet weak var lb_country: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
