//
//  ConfigurationTableDataSource.swift
//  VpnPhone
//
//  Created by Anton Pomozov on 01/04/2017.
//  Copyright © 2017 Anton Pomozov. All rights reserved.
//

import UIKit

protocol MemoryConsumer: class {

    func didReceiveMemoryWarning()

}

protocol DataSource: class {

    func insert(new element: VpnConfiguration)

}

class ConfigurationTableDataSource: NSObject,
                                    UITableViewDataSource,
                                    DataSource {

    // MARK: - Proeprties

    weak var dataView: DataView?

    // MARK: - DataSource

    var data: [VpnConfiguration] {
        didSet {
            let exportData = data.map { [$0.uuid, $0.address, $0.certificate?.label, $0.certificate?.passphrase, $0.certificate?.url] }
            UserDefaults.standard.set(exportData, forKey: keyOfStoredUrl)

            // FIXME: Для быстроты.
            dataView?.reloadData()
        }
    }

    func insert(new element: VpnConfiguration) {
        if let index = data.index(of: element) {
            data[index] = element
        } else {
            data.append(element)
        }
    }

    // MARK: - Life cycle

    init(cellReuseIdentidier: String) {
        let data: [VpnConfiguration]
        if let importData = UserDefaults.standard.value(forKey: keyOfStoredUrl) as? [Any] {
            data = importData.map {
                let element = $0 as! [String]
                let vpn = VpnConfiguration( uuid: element[0],
                                            address: element[1],
                                            certificate: (label: element[2], passphrase: element[3], url: element[4]) )
                return vpn
            }
        } else {
            data = [VpnConfiguration]()
        }

        self.cellReuseIdentidier = cellReuseIdentidier
        self.data = data

        super.init()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentidier, for: indexPath) as! ConfigurationTableViewCell

        cell.vpn = data[indexPath.row]

        return cell
    }

    // MARK: - Private

    private let keyOfStoredUrl = "VPN Configurations"
    private let cellReuseIdentidier: String

}

extension ConfigurationTableDataSource: MemoryConsumer {

    func didReceiveMemoryWarning() {

    }

}
