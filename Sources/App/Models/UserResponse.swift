//
//  UserResponse.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor

final class UserResponse {
    var id: Int
    var username: String
    var email: String?
    var fullname: String?
    var roleRawValue: Int

    init?(user: User) {
        guard let id = user.id else {
            return nil
        }
        self.id = id
        self.username = user.username
        self.email = user.email
        self.fullname = user.fullname
        self.roleRawValue = user.roleRawValue
    }
}

extension UserResponse: Content { }
