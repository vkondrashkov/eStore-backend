//
//  Smartphone.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import FluentSQLite
import Vapor

final class Smartphone: SQLiteModel {
    var id: Int?
    var imageUrl: String?
    var name: String
    var brandName: String
    var operatingSystemRawValue: Int
    var resolutionWidth: Int
    var resolutionHeight: Int
    var ramCapacity: Int
    var memoryCapacity: Int
    var processorName: String
    var color: String
    var batteryCapacity: Int
    var price: Int

    init(id: Int? = nil,
         imageUrl: String?,
         name: String,
         brandName: String,
         operatingSystemRawValue: Int,
         resolutionWidth: Int,
         resolutionHeight: Int,
         ramCapacity: Int,
         memoryCapacity: Int,
         processorName: String,
         color: String,
         batteryCapacity: Int,
         price: Int) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
        self.brandName = brandName
        self.operatingSystemRawValue = operatingSystemRawValue
        self.resolutionWidth = resolutionWidth
        self.resolutionHeight = resolutionHeight
        self.ramCapacity = ramCapacity
        self.memoryCapacity = memoryCapacity
        self.processorName = processorName
        self.color = color
        self.batteryCapacity = batteryCapacity
        self.price = price
    }
}

extension Smartphone: Migration { }
extension Smartphone: Content { }
extension Smartphone: Parameter { }
