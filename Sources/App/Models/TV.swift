//
//  TV.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import FluentSQLite
import Vapor

final class TV: SQLiteModel {
    var id: Int?
    var imageUrl: String?
    var name: String
    var brandName: String
    var operatingSystemRawValue: Int
    var resolutionWidth: Int
    var resolutionHeight: Int
    var price: Int

    init(id: Int? = nil,
         imageUrl: String?,
         name: String,
         brandName: String,
         operatingSystemRawValue: Int,
         resolutionWidth: Int,
         resolutionHeight: Int,
         price: Int) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.brandName = brandName
        self.operatingSystemRawValue = operatingSystemRawValue
        self.resolutionWidth = resolutionWidth
        self.resolutionHeight = resolutionHeight
        self.price = price
    }
}

extension TV: Migration { }
extension TV: Content { }
extension TV: Parameter { }
