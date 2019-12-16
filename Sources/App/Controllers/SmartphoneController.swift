//
//  SmartphoneController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/16/19.
//

import Vapor

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
            return smartphone.save(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Smartphone.self).flatMap { smartphone in
            return smartphone.delete(on: req)
        }.transform(to: .ok)
    }
}
