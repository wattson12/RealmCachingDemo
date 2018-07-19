//
//  WalletItemObject.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RealmSwift

final class WalletItemObject: Object, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
     @objc dynamic var cacheExpiry: TimeInterval = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension WalletItemObject: Cacheable {
    typealias ViewStateType = WalletItem

    var viewState: WalletItem {
        return WalletItem(id: id, name: name)
    }
}
