//
//  User.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class User: SQLiteModel {
    enum Role: Int {
        case guest = 0
        case authorized
        case contentMaker
        case moderator
        case admin
    }

    var id: Int?
    var username: String
    var password: String
    var email: String?
    var fullname: String?
    var roleRawValue: Int

    init(id: Int? = nil,
         username: String,
         password: String,
         email: String?,
         fullname: String?,
         roleRawValue: Int) {
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.fullname = fullname
        self.roleRawValue = roleRawValue
    }
}

extension User: Migration { }
extension User: Parameter { }
