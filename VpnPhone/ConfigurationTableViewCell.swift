//
//  ConfigurationTableViewCell.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

class ConfigurationTableViewCell: UITableViewCell,
                                  VpnConfigured {

    // MARK: - VpnConfigured

    var vpn: Vpn!

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
