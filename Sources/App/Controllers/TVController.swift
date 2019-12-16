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

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(TV.self).flatMap { tv in
            return tv.delete(on: req)
        }.transform(to: .ok)
    }
}
