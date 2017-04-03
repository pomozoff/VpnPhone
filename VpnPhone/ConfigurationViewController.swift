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

class ConfigurationViewController: UITableViewController,
                                   VpnConfigured,
                                   ServerAddressStorage {

    // MARK: - Outlets

    @IBOutlet var serverAddressLabel: UILabel!

    // MARK: - VpnConfigured

    var vpn: VpnConfiguration?

    // MARK: - Properties

    var serverAddress: String? {
        didSet {
            guard let address = serverAddress else {
                return
            }
            updateData(with: address)
        }
    }

    weak var dataSource: (DataSource & MemoryConsumer)?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vpn = vpn else {
            return
        }

        updateData(with: vpn.address)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        dataSource?.didReceiveMemoryWarning()
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("Show Server Address Segue"):
            let vc = segue.destination as! ServerAddressEditor
            vc.serverAddress = serverAddressLabel.text
            vc.serverAddressStorage = self
        case .some("Show Certificate URL Segue"):
            break
        default:
            print("Unknown segue with the identifier: \(String(describing: segue.identifier))")
            break
        }
    }

    // MARK: - Actions

    @IBAction func didTapOnSaveButton(_ sender: UIBarButtonItem) {
        guard let address = serverAddressLabel.text else {
            return
        }

        var vpn = self.vpn == nil ? VpnConfiguration() : self.vpn!

        vpn.address = address
        dataSource?.insert(new: vpn)

        navigationController?.popViewController(animated: true)
    }

    private func updateData(with text: String) {
        serverAddressLabel.text = text
        title = text
    }

}
