//
//  User.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class User: SQLiteModel {
    var id: Int?
    var username: String
    var email: String?
    var fullname: String?
    var roleRawValue: Int

    init(id: Int? = nil,
         username: String,
         email: String?,
         fullname: String?,
         roleRawValue: Int) {
        self.id = id
        self.username = username
        self.email = email
        self.fullname = fullname
        self.roleRawValue = roleRawValue
    }
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }
