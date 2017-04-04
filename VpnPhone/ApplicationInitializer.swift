//
//  ApplicationInitializer.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

class ApplicationInitializer: NSObject {

    // MARK: - Outlets

    @IBOutlet var navigationController: UINavigationController!

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        assembly()
    }

    // MARK: - Private

    private func assembly() {
        let configurationTableViewController = navigationController.topViewController as! ConfigurationTableViewController
        let configurationDataSource = ConfigurationTableDataSource(cellReuseIdentidier: "Vpn Configuration Cell")

        configurationDataSource.dataView = configurationTableViewController

        configurationTableViewController.tableView.dataSource = configurationDataSource
        configurationTableViewController.dataSource = configurationDataSource
        configurationTableViewController.showConfigurationSegueIdentifier = "Show Configuration Segue"
        configurationTableViewController.vpnManager = VpnManagerImpl()
    }

}
