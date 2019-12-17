//
//  CartRecordController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor

final class CartRecordController {
//    func index(_ req: Request) throws -> Future<(()> {
//        
//    }

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

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Laptop.self).flatMap { laptop in
            return laptop.delete(on: req)
        }.transform(to: .ok)
    }
}
