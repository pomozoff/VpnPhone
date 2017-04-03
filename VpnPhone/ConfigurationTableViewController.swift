//
//  ConfigurationTableViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController {

    // MARK: - Properties

    var dataSource: (DataSource & MemoryConsumer)!
    var showConfigurationSegueIdentifier: String!

    // MARK: - Life cycle

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        dataSource.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func didTapOnAddConfiguration(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: showConfigurationSegueIdentifier, sender: nil)
    }

    // MARK: - Segue

    // FIXME: Для упрощения роутера нет - его обязанности выполняет VC.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showConfigurationSegueIdentifier else {
            return
        }

        let vc = segue.destination as! ConfigurationViewController
        vc.dataSource = dataSource

        // FIXME: Этот г@#$код тоже для того, чтобы побыстрей написать.
        if let vpnSource = sender as? VpnConfigured {
            vc.vpn = vpnSource.vpn
        }
    }

}

protocol DataView: class {

    func reloadData()

}
extension ConfigurationTableViewController: DataView {

    // MARK: - Configurable

    func reloadData() {
        tableView.reloadData()
    }

}
