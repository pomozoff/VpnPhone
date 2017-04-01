//
//  ConfigurationViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

protocol VpnConfigured {

    var vpn: Vpn! { get set }

}

class ConfigurationViewController: UIViewController,
                                   VpnConfigured {

    // MARK: - VpnConfigured

    var vpn: Vpn!

}
