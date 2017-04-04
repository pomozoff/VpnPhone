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
    var vpnManager: VpnManager!
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

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vpn = dataSource[indexPath.row]

        switch currentState {
        case .connected:
            disconnect()
        case .disconnected:
            connect(to: vpn)
        default:
            break
        }
    }

    // MARK: - Private

    private enum VpnState {
        case disconnected,
             connecting,
             disconnecting,
             connected
    }
    private var currentState: VpnState = .disconnected {
        didSet {
            switch currentState {
            case .disconnected:
                title = "Disconnected"
            case .connecting:
                title = "Connecting"
            case .disconnecting:
                title = "Disconnecting"
            case .connected:
                title = "Connected"
            }
        }
    }
    private func connect(to vpn: VpnConfiguration) {
        currentState = .connecting

        vpnManager.configure(vpn: vpn) { [weak self] succeeded in
            guard succeeded else {
                DispatchQueue.main.async {
                    self?.currentState = .disconnected
                }
                return
            }
            self?.vpnManager.connect { succeeded in
                DispatchQueue.main.async {
                    self?.currentState = succeeded ? .connected : .disconnected
                }
            }
        }
    }
    private func disconnect() {
        currentState = .disconnecting
        vpnManager.disconnect {
            DispatchQueue.main.async { [weak self] in
                self?.currentState = .disconnected
            }
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
