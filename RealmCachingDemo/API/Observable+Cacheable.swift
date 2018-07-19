//
//  Observable+Cacheable.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: Cacheable {

    func convertToViewState() -> Observable<Element.ViewStateType> {
        return map { $0.viewState }.observeOn(MainScheduler.instance)
    }
}
