//
//  UserController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor

final class UserController {
//    func index(_ req: Request) throws -> Future<[TV]> {
//        return TV.query(on: req).all()
//    }
//
//    func unit(_ req: Request) throws -> Future<TV> {
//        let id = try req.parameters.next(Int.self)
//        return TV.find(id, on: req).map(to: TV.self) { tv in
//            guard let tv = tv else { throw Abort(HTTPStatus.notFound) }
//            return tv
//        }
//    }

    func create(_ req: Request) throws -> Future<User> {
        let user = User.query(on: req).first().map { user in
            guard user == nil else {
                throw Abort(.badRequest)
            }
        }
        return try req.content.decode(UserForm.self).flatMap { userForm in
            let randId = Int.random(in: 1...10000)
            let user = User(id: nil, username: "user\(randId)", email: userForm.login, fullname: nil, roleRawValue: 1)
            return user.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.update(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }
}
