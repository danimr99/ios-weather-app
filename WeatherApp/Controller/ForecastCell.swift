//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Arnau Vives on 19/11/22.
//

import UIKit

class ForecastCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
