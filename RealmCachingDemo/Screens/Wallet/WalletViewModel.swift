//
//  WalletViewModel.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WalletViewModel {

    let disposeBag = DisposeBag()

    let walletItems: BehaviorSubject<[WalletItem]> = BehaviorSubject(value: [])

    func refresh() {

        Observable<[WalletItemObject]>
            .requestStartingWithCachedValues(usingAPIRequest: Current.api.getWalletItems)
            .debug()
            .catchErrorJustReturn([])
            .persist()
            .convertToViewState()
            .bind(to: walletItems)
            .disposed(by: disposeBag)
    }
}
