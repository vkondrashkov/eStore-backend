//
//  CartController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor
import FluentSQLite

final class CartController {
    func index(_ req: Request) throws -> Future<[CartItem]> {
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: [CartItem].self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard let userId = user.id else { throw Abort(HTTPResponseStatus.badRequest) }
            return CartItem.query(on: req).filter(\CartItem.ownerId == userId).all()
        }
    }

    func unit(_ req: Request) throws -> Future<TV> {
        let id = try req.parameters.next(Int.self)
        return TV.find(id, on: req).map(to: TV.self) { tv in
            guard let tv = tv else { throw Abort(HTTPStatus.notFound) }
            return tv
        }
    }

    func add(_ req: Request) throws -> Future<HTTPStatus> {
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: HTTPStatus.self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard let ownerId = user.id else { throw Abort(HTTPResponseStatus.badRequest) }
            return try req.content.decode(CartItemForm.self).flatMap { form -> EventLoopFuture<Void> in
                let result: EventLoopFuture<Void>
                let id = form.productId
                switch form.productTypeId {
                case 0:
                    result = Smartphone.find(id, on: req).flatMap { smartphone -> EventLoopFuture<CartItem> in
                        guard let smartphone = smartphone else { throw Abort(HTTPResponseStatus.badRequest) }
                        guard let productId = smartphone.id else { throw Abort(HTTPResponseStatus.badRequest) }
                        let cartItem = CartItem(
                            id: nil,
                            ownerId: ownerId,
                            productId: productId,
                            imageUrl: smartphone.imageUrl,
                            name: smartphone.name,
                            brandName: smartphone.brandName,
                            price: smartphone.price
                        )
                        return cartItem.save(on: req)
                    }.map(to: Void.self) { _ in }
                case 1:
                    result = Laptop.find(id, on: req).flatMap { laptop -> EventLoopFuture<CartItem> in
                        guard let laptop = laptop else { throw Abort(HTTPResponseStatus.badRequest) }
                        let cartItem = CartItem(
                            id: nil,
                            ownerId: ownerId,
                            productId: 1,
                            imageUrl: laptop.imageUrl,
                            name: laptop.name,
                            brandName: laptop.brandName,
                            price: laptop.price
                        )
                        return cartItem.save(on: req)
                    }.map(to: Void.self) { _ in }
                case 2:
                    result = TV.find(id, on: req).flatMap { tv -> EventLoopFuture<CartItem> in
                        guard let tv = tv else { throw Abort(HTTPResponseStatus.badRequest) }
                        let cartItem = CartItem(
                            id: nil,
                            ownerId: ownerId,
                            productId: 2,
                            imageUrl: tv.imageUrl,
                            name: tv.name,
                            brandName: tv.brandName,
                            price: tv.price
                        )
                        return cartItem.save(on: req)
                    }.map(to: Void.self) { _ in }
                default:
                    throw Abort(HTTPResponseStatus.badRequest)
                }
                return result
            }.transform(to: .ok)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        guard let userId = Int(req.http.headers["userId"].first ?? "") else { throw Abort(HTTPResponseStatus.unauthorized) }
        return User.find(userId, on: req).flatMap(to: HTTPStatus.self) { user in
            guard let user = user else { throw Abort(HTTPResponseStatus.badRequest) }
            guard let ownerId = user.id else { throw Abort(HTTPResponseStatus.badRequest) }
            return try req.parameters.next(CartItem.self).flatMap { cartItem -> EventLoopFuture<Void> in
                guard cartItem.ownerId == ownerId else { throw Abort(HTTPResponseStatus.forbidden) }
                return cartItem.delete(on: req)
            }.transform(to: .ok)
        }
    }
}
