//
//  UserController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor
import FluentSQLite

final class UserController {
    func index(_ req: Request) throws -> Future<[UserResponse]> {
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: [UserResponse].self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard user.roleRawValue >= User.Role.moderator.rawValue else { throw Abort(HTTPResponseStatus.forbidden) }
            return User.query(on: req).all().map(to: [UserResponse].self) { users in
                return users.compactMap { UserResponse(user: $0) }
            }
        }
    }

    func authorize(_ req: Request) throws -> Future<UserResponse> {
        return try req.content.decode(UserForm.self).flatMap(to: UserResponse.self) { userForm in
            return User.query(on: req).group(.or) { user in
                user.filter(\User.email == userForm.login).filter(\User.username == userForm.login)
            }.first().map(to: UserResponse.self) { user in
                guard let user = user else { throw Abort(HTTPResponseStatus.notFound) }
                guard user.password == userForm.password else { throw Abort(HTTPResponseStatus.forbidden) }
                guard let response = UserResponse(user: user) else { throw Abort(HTTPResponseStatus.noContent) }
                return response
            }
        }
    }

    func authorizeAsGuest(_ req: Request) throws -> Future<UserResponse> {
        return try registerUser(req, role: .guest)
    }

    func register(_ req: Request) throws -> Future<UserResponse> {
        return try registerUser(req, role: .authorized)
    }

    private func registerUser(_ req: Request, role: User.Role) throws -> Future<UserResponse> {
        return try req.content.decode(UserForm.self).flatMap(to: UserResponse.self) { userForm in
            return User.query(on: req).group(.or) { user in
                user.filter(\User.email == userForm.login).filter(\User.username == userForm.login)
            }.first().flatMap(to: UserResponse.self) { user in
                guard user == nil else { throw Abort(HTTPResponseStatus.badRequest) }
                let user = User(id: nil, username: "", password: userForm.password, email: userForm.login, fullname: nil, roleRawValue: role.rawValue)
                return user.save(on: req).flatMap(to: UserResponse.self) { user in
                    guard let userId = user.id else { throw Abort(HTTPResponseStatus.badRequest) }
                    user.username = "user\(userId)"
                    return user.update(on: req).map(to: UserResponse.self) { user in
                        guard let response = UserResponse(user: user) else { throw Abort(HTTPResponseStatus.badRequest) }
                        return response
                    }
                }
            }
        }
    }

    func update(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.update(on: req)
        }
    }

    func testUpdate(_ req: Request) throws -> Future<UserResponse> {
        return try req.content.decode(UserResponse.self).flatMap { userResponse in
            return User.find(userResponse.id, on: req).flatMap(to: UserResponse.self) { user in
                guard let user = user else { throw Abort(HTTPResponseStatus.notFound) }
                let newUser = User(
                    id: user.id,
                    username: userResponse.username,
                    password: user.password,
                    email: userResponse.email,
                    fullname: userResponse.fullname,
                    roleRawValue: userResponse.roleRawValue
                )
                return newUser.update(on: req).map(to: UserResponse.self) { user in
                    guard let response = UserResponse(user: user) else { throw Abort(HTTPResponseStatus.badRequest) }
                    return response
                }
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }
}
