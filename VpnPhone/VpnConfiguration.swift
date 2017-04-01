//
//  VpnConfiguration.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import Foundation

protocol Vpn {

    var address: String? { get set }
    var user: String? { get set }
    var password: String? { get set }

}

struct VpnConfiguration: Vpn {

    var password: String?

    var user: String?

    var address: String?

}
