//
//  CartItem.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class CartItem: SQLiteModel {
    var id: Int?
    var ownerId: Int
    var productId: Int
    var imageUrl: String?
    var name: String
    var brandName: String
    var price: Int

    init(id: Int? = nil,
         ownerId: Int,
         productId: Int,
         imageUrl: String?,
         name: String,
         brandName: String,
         price: Int) {
        self.id = id
        self.ownerId = ownerId
        self.productId = productId
        self.imageUrl = imageUrl
        self.name = name
        self.brandName = brandName
        self.price = price
    }
}

extension CartItem: Migration { }
extension CartItem: Content { }
extension CartItem: Parameter { }
