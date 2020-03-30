//
//  SmartphoneController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import Vapor
import FluentSQLite

final class SmartphoneController {
    func index(_ req: Request) throws -> Future<[Smartphone]> {
        return Smartphone.query(on: req).all()
    }

    func unit(_ req: Request) throws -> Future<Smartphone> {
        let id = try req.parameters.next(Int.self)
        return Smartphone.find(id, on: req).map(to: Smartphone.self) { smartphone in
            guard let smartphone = smartphone else { throw Abort(HTTPStatus.notFound) }
            return smartphone
        }
    }

    func create(_ req: Request) throws -> Future<Smartphone> {
        return try req.content.decode(Smartphone.self).flatMap { smartphone in
            return Smartphone.query(on: req).filter(\.brandName == smartphone.brandName).filter(\.name == smartphone.name).all().flatMap(to: Smartphone.self) { smartphones in
                if smartphones.isEmpty {
                    return smartphone.save(on: req)
                } else {
                    throw Abort(HTTPStatus.badRequest)
                }
            }
        }
    }

    func update(_ req: Request) throws -> Future<Smartphone> {
        let smartphoneId = try req.parameters.next(Int.self)
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: Smartphone.self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard user.roleRawValue >= User.Role.contentMaker.rawValue else { throw Abort(HTTPResponseStatus.forbidden) }

            return try req.content.decode(Smartphone.self).flatMap { newSmartphone in
                return Smartphone.find(smartphoneId, on: req).flatMap(to: Smartphone.self) { smartphone in
                    guard let oldSmartphoneId = smartphone?.id else { throw Abort(HTTPResponseStatus.notFound) }
                    newSmartphone.id = oldSmartphoneId
                    return newSmartphone.save(on: req)
                }
            }
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Smartphone.self).flatMap { smartphone in
            return smartphone.delete(on: req)
        }.transform(to: .ok)
    }
}
