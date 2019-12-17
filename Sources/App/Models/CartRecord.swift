//
//  CartRecord.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class CartRecord: SQLiteModel {
    var id: Int?
    var smartphoneId: Int?
    var laptopId: Int?
    var tvId: Int?

    init(id: Int? = nil,
         smartphoneId: Int?,
         laptopId: Int?,
         tvId: Int?) {
        self.id = id
        self.smartphoneId = smartphoneId
        self.laptopId = laptopId
        self.tvId = tvId
    }
}

extension CartRecord: Migration { }
extension CartRecord: Content { }
extension CartRecord: Parameter { }
