//
//  LaptopController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import Vapor

final class LaptopController {
    func index(_ req: Request) throws -> Future<[Laptop]> {
        return Laptop.query(on: req).all()
    }

    func unit(_ req: Request) throws -> Future<Laptop> {
        let id = try req.parameters.next(Int.self)
        return Laptop.find(id, on: req).map(to: Laptop.self) { laptop in
            guard let laptop = laptop else { throw Abort(HTTPStatus.notFound) }
            return laptop
        }
    }

    func create(_ req: Request) throws -> Future<Laptop> {
        return try req.content.decode(Laptop.self).flatMap { laptop in
            return laptop.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<Laptop> {
        let laptopId = try req.parameters.next(Int.self)
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: Laptop.self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard user.roleRawValue >= User.Role.contentMaker.rawValue else { throw Abort(HTTPResponseStatus.forbidden) }

            return try req.content.decode(Laptop.self).flatMap { newLaptop in
                return Laptop.find(laptopId, on: req).flatMap(to: Laptop.self) { laptop in
                    guard let oldLaptopId = laptop?.id else { throw Abort(HTTPResponseStatus.notFound) }
                    newLaptop.id = oldLaptopId
                    return newLaptop.save(on: req)
                }
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Laptop.self).flatMap { laptop in
            return laptop.delete(on: req)
        }.transform(to: .ok)
    }
}
