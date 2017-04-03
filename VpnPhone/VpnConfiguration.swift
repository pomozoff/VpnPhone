//
//  VpnConfiguration.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import Foundation

struct VpnConfiguration {

    var uuid = UUID()
    var address: String = ""
    var identity: Data?

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
