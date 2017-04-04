//
//  ServerAddressViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 04/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

class ServerAddressViewController: UIViewController,
                                   VpnConfigurationEditor,
                                   ServerAddressStorage {

    // MARK: - Outlets

    @IBOutlet weak var serverAddressLabel: UITextField!

    // MARK: - ServerAddressStorage

    var serverAddress: String?

    // MARK: - VpnConfigurationEditor

    weak var vpnConfigurationStorage: VpnConfigurationStorage?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        serverAddressLabel.text = serverAddress
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        serverAddressLabel.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func didTapOnSaveButton(_ sender: UIBarButtonItem) {
        vpnConfigurationStorage?.serverAddress = serverAddressLabel.text
        navigationController?.popViewController(animated: true)
    }

}
