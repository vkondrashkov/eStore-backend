//
//  CartItemForm.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class CartItemForm: SQLiteModel {
    var id: Int?
    var productId: Int
    var productTypeId: Int

    init(id: Int? = nil,
         productId: Int,
         productTypeId: Int) {
        self.id = id
        self.productId = productId
        self.productTypeId = productTypeId
    }
}

extension CartItemForm: Migration { }
extension CartItemForm: Content { }
extension CartItemForm: Parameter { }
