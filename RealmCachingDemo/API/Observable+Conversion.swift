//
//  Observable+Conversion.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == Data {

    func convertToModel<Model: Decodable>(_ modelType: Model.Type) -> Observable<Model> {
        return map { data in
            return try JSONDecoder().decode(modelType, from: data)
        }
    }
}
