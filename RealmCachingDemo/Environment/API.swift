//
//  API.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RxSwift

struct API {

    var fetchData: () -> Observable<Data> = {
        let url = Bundle.main.url(forResource: "response", withExtension: "json")!
        return Observable<Data>.just(try! Data(contentsOf: url)).delay(4, scheduler: SerialDispatchQueueScheduler.init(qos: .background))
    }

    var getWalletItems: () -> Observable<[WalletItemObject]> = {
        return Current.api.fetchData().convertToModel([WalletItemObject].self)
    }
}
