//
//  CertificateUrlViewController.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 04/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit
import Security

class CertificateUrlViewController: UIViewController,
                                    VpnConfigurationEditor,
                                    CertificateStorage {

    // MARK: - Outlets

    @IBOutlet var certificateUrl: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var label: UITextField!

    // MARK: - VpnConfigurationEditor

    weak var vpnConfigurationStorage: VpnConfigurationStorage?

    // MARK: - VpnConfigurationStorage

    var certificate: Certificate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        certificateUrl.text = vpnConfigurationStorage?.certificate?.url
        password.text = vpnConfigurationStorage?.certificate?.passphrase
        label.text = vpnConfigurationStorage?.certificate?.label
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        certificateUrl.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func didTapOnSaveButton(_ sender: UIBarButtonItem) {
        guard let urlString = certificateUrl.text, let url = URL(string: urlString) else {
            print("Failed to create URL from: \(String(describing: certificateUrl.text))")
            return
        }
        fetchKey(for: url)
    }

    // MARK: - Private

    private let keyOfStoredUrl = "Certificate URL"
    private let keyOfStoredPassword = "Certificate Password"
    private let keyOfStoredLabel = "Certificate Label"

    private var isDownloading: Bool = false {
        didSet {
            certificateUrl.isEnabled = !isDownloading
            password.isEnabled = !isDownloading

            UIApplication.shared.isNetworkActivityIndicatorVisible = isDownloading
        }
    }

    private func fetchKey(for url: URL) {
        isDownloading = true

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }
            defer {
                DispatchQueue.main.async {
                    strongSelf.isDownloading = false
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }

            guard let data = data else {
                print("Failed to fetch data, response: \(String(describing: response)), error: \(String(describing: error))")
                return
            }

            strongSelf.save(certificate: data, url: url)
        }

        task.resume()
    }
    private func save(certificate: Data, url: URL) {
        guard let passphrase = password.text else {
            print("Passphrase is nil")
            return
        }
        guard let label = label.text else {
            print("Label is nil")
            return
        }

        guard let _ = KeychainService.saveCertificate(named: label, passphrase: passphrase, data: certificate) else {
            print("Identity is nil")
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.vpnConfigurationStorage?.certificate = (label, passphrase, url.absoluteString)
        }
    }

}
