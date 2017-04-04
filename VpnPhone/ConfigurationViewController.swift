//
//  ConfigurationViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

protocol VpnConfigured {
    var vpn: VpnConfiguration? { get set }
}

protocol ServerAddressStorage: class {
    var serverAddress: String? { get set }
}
protocol CertificateStorage: class {
    var certificate: Certificate? { get set }
}

protocol VpnConfigurationStorage: ServerAddressStorage, CertificateStorage {
}

protocol VpnConfigurationEditor: class {
    var vpnConfigurationStorage: VpnConfigurationStorage? { get set }
}

class ConfigurationViewController: UITableViewController,
                                   VpnConfigured,
                                   VpnConfigurationStorage {

    // MARK: - Outlets

    @IBOutlet var serverAddressLabel: UILabel!
    @IBOutlet var certificateLabel: UILabel!

    // MARK: - VpnConfigured

    var vpn: VpnConfiguration?

    // MARK: - Properties

    var serverAddress: String? {
        didSet {
            guard let address = serverAddress else {
                return
            }
            updateServerAddress(with: address)
        }
    }
    var certificate: Certificate? {
        didSet {
            guard let certificate = certificate, let url = URL(string: certificate.url) else {
                return
            }
            certificateLabel.text = url.lastPathComponent
        }
    }

    weak var dataSource: (DataSource & MemoryConsumer)?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        serverAddress = vpn?.address
        certificate = vpn?.certificate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        dataSource?.didReceiveMemoryWarning()
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("Show Server Address Segue"):
            let vc = segue.destination as! VpnConfigurationEditor & ServerAddressStorage
            vc.serverAddress = serverAddress
            vc.vpnConfigurationStorage = self
        case .some("Show Certificate URL Segue"):
            let vc = segue.destination as! VpnConfigurationEditor & CertificateStorage
            vc.certificate = certificate
            vc.vpnConfigurationStorage = self
        default:
            print("Unknown segue with the identifier: \(String(describing: segue.identifier))")
            break
        }
    }

    // MARK: - Actions

    @IBAction func didTapOnSaveButton(_ sender: UIBarButtonItem) {
        guard let address = serverAddress else {
            print("Server address is nil")
            return
        }
        guard let certificate = certificate else {
            print("Certificate is nil")
            return
        }

        var vpn = self.vpn == nil ? VpnConfiguration() : self.vpn!

        vpn.address = address
        vpn.certificate = certificate

        dataSource?.insert(new: vpn)

        navigationController?.popViewController(animated: true)
    }

    private func updateServerAddress(with text: String) {
        serverAddressLabel.text = text
        title = text
    }

}
