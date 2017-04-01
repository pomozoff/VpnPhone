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

protocol DataSource {

    associatedtype Element
    var data: [Element] { get set }

}

class ConfigurationTableDataSource: NSObject,
                                    UITableViewDataSource,
                                    DataSource {

    // MARK: - DataSource

    var data: [VpnConfiguration]

    // MARK: - Life cycle

    init(cellReuseIdentidier: String) {
        self.cellReuseIdentidier = cellReuseIdentidier
        self.data = self.savedData

        super.init()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentidier, for: indexPath)
        return cell
    }

    // MARK: - Private

    private let cellReuseIdentidier: String
    private let savedData: [VpnConfiguration] = {
        // TODO: Read from User​Defaults
        return [VpnConfiguration]()
    }()

}

extension ConfigurationTableDataSource: MemoryConsumer {

    func didReceiveMemoryWarning() {

    }

}
