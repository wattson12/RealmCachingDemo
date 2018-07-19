//
//  Storage.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm.Configuration {

    static var config: Realm.Configuration { return Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in }) }
}

struct RealmEnvironment {

    var create: () throws -> Realm = {
        return try Realm(configuration: .config)
    }
}

struct Cache {

    var cachedWalletItems: () -> [WalletItemObject] = {
        do {
            let realm = try Current.storage.realm.create()
            return Array(realm.objects(WalletItemObject.self))
        } catch {
            return []
        }
    }
}

struct Storage {
    var realm = RealmEnvironment()
    var cache = Cache()
}
