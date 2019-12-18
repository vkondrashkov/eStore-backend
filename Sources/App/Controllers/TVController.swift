//
//  TVController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import Vapor

final class TVController {
    func index(_ req: Request) throws -> Future<[TV]> {
        return TV.query(on: req).all()
    }

    func unit(_ req: Request) throws -> Future<TV> {
        let id = try req.parameters.next(Int.self)
        return TV.find(id, on: req).map(to: TV.self) { tv in
            guard let tv = tv else { throw Abort(HTTPStatus.notFound) }
            return tv
        }
    }

    func create(_ req: Request) throws -> Future<TV> {
        return try req.content.decode(TV.self).flatMap { smartphone in
            return smartphone.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<TV> {
        let tvId = try req.parameters.next(Int.self)
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: TV.self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard user.roleRawValue >= User.Role.contentMaker.rawValue else { throw Abort(HTTPResponseStatus.forbidden) }

            return try req.content.decode(TV.self).flatMap { newTV in
                return TV.find(tvId, on: req).flatMap(to: TV.self) { tv in
                    guard let oldTVId = tv?.id else { throw Abort(HTTPResponseStatus.notFound) }
                    newTV.id = oldTVId
                    return newTV.save(on: req)
                }
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(TV.self).flatMap { tv in
            return tv.delete(on: req)
        }.transform(to: .ok)
    }
}
