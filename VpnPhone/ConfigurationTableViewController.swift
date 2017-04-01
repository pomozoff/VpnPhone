//
//  ConfigurationTableViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit
import NetworkExtension

class ConfigurationTableViewController: UITableViewController {

    // MARK: - Properties

    weak var memoryConsumer: MemoryConsumer?
    var showConfigurationSegueIdentifier: String!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        memoryConsumer?.didReceiveMemoryWarning()
    }

    // MARK: - Segue

    // FIXME: Для упрощения роутера нет - его обязанности выполняет VC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showConfigurationSegueIdentifier else {
            return
        }

        let cell = sender as! ConfigurationTableViewCell
        let vc = segue.destination as! ConfigurationViewController

        vc.vpn = cell.vpn
    }

}

protocol Configurable {

    func configure()

}

extension ConfigurationTableViewController: Configurable {

    // MARK: - Configurable

    func configure() {
        configureVpnManager()
    }

    // MARK: - Private

    private func configureVpnManager() {
        let manager = NEVPNManager.shared()
        manager.loadFromPreferences { error in
            guard error == nil else {
                print("Error configuring a vpn manager: \(String(describing: error))")
                return
            }
            print("Successfully configured a vpn manager")
        }
    }

}
