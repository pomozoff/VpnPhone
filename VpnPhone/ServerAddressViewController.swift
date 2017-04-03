//
//  ServerAddressViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 04/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

protocol ServerAddressEditor: ServerAddressStorage {
    var serverAddressStorage: ServerAddressStorage? { get set }
}

class ServerAddressViewController: UIViewController,
                                   ServerAddressEditor {

    // MARK: - Outlets

    @IBOutlet weak var serverAddressLabel: UITextField!

    // MARK: - Properties

    var serverAddress: String?

    weak var serverAddressStorage: ServerAddressStorage?

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
        serverAddressStorage?.serverAddress = serverAddressLabel.text
        navigationController?.popViewController(animated: true)
    }

}
