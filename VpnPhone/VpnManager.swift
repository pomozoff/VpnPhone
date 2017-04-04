//
//  VpnManager.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 04/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import Foundation
import NetworkExtension

protocol VpnManager: class {
    func configure(vpn: VpnConfiguration, completion: @escaping (Bool) -> Void)
    func connect(with completion: @escaping (Bool) -> Void)
    func disconnect(with completion: @escaping () -> Void)
}

class VpnManagerImpl: VpnManager {

    // MARK: - VpnManager

    func configure(vpn: VpnConfiguration, completion: @escaping (Bool) -> Void) {
        guard let certificate = vpn.certificate else {
            print("Certificate is nil")
            return
        }
        guard let identity = KeychainService.loadCertificate(named: certificate.label, passphrase: certificate.passphrase) else {
            print("Identity is nil")
            completion(false)
            return
        }

        let manager = NEVPNManager.shared()
        manager.loadFromPreferences { error in
            guard error == nil else {
                print("Error configuring a vpn manager: \(String(describing: error))")
                completion(false)
                return
            }
            print("Successfully configured a vpn manager")

            let protocolIkev2 = NEVPNProtocolIKEv2()
            protocolIkev2.username = ""
            protocolIkev2.serverAddress = vpn.address
            protocolIkev2.authenticationMethod = .certificate
            protocolIkev2.identityData = identity
            protocolIkev2.localIdentifier = ""
            protocolIkev2.remoteIdentifier = ""
            protocolIkev2.useExtendedAuthentication = true
            protocolIkev2.disconnectOnSleep = false

            manager.protocolConfiguration = protocolIkev2
            manager.isOnDemandEnabled = true
            manager.localizedDescription = certificate.label
            manager.saveToPreferences { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    func connect(with completion: @escaping (Bool) -> Void) {
        let manager = NEVPNManager.shared()

        do {
            try manager.connection.startVPNTunnel()
        } catch {
            print("Failed to start vpn connection: \(error)")
            completion(false)
            return
        }

        print("Connection established")
        completion(true)
    }
    func disconnect(with completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            let manager = NEVPNManager.shared()
            manager.connection.stopVPNTunnel()

            print("Disconnected")
            completion()
        }
    }

}
