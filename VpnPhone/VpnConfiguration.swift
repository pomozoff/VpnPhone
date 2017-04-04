//
//  VpnConfiguration.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import Foundation

typealias Certificate = (label: String, passphrase: String, url: String)

struct VpnConfiguration {

    var uuid = UUID().uuidString
    var address = ""
    var certificate: Certificate?

}

extension VpnConfiguration: Equatable {}

func == (lhs: VpnConfiguration, rhs: VpnConfiguration) -> Bool {
    return lhs.uuid == rhs.uuid
}

extension VpnConfiguration: Hashable {

    var hashValue: Int {
        return uuid.hashValue
    }

}
