//
//  UserForm.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class UserForm: SQLiteModel {
    var id: Int?
    var login: String
    var password: String

    init(id: Int? = nil,
         login: String,
         password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
}

extension UserForm: Migration { }
extension UserForm: Content { }
extension UserForm: Parameter { }
