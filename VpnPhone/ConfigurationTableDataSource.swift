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
        self.cellReuseIdentidier = cellReuseIdentidier
        self.data = self.savedData

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

    private let cellReuseIdentidier: String
    private let savedData = {
        // TODO: Read from User​Defaults
        return [VpnConfiguration]()
    }()

}

extension ConfigurationTableDataSource: MemoryConsumer {

    func didReceiveMemoryWarning() {

    }

}
