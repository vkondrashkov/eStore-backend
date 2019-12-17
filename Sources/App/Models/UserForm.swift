//
//  UserForm.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import FluentSQLite
import Vapor

final class UserForm {
    var login: String
    var password: String

    init(login: String,
         password: String) {
        self.login = login
        self.password = password
    }
}

extension UserForm: Content { }
