//
//  CartController.swift
//  App
//
//  Created by Vladislav Kondrashkov on 12/17/19.
//

import Vapor

final class CartController {
    func index(_ req: Request) throws -> Future<[CartItem]> {
        return CartItem.query(on: req).all()
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

    func add(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(CartItemForm.self).flatMap { form -> EventLoopFuture<Void> in
            let result: EventLoopFuture<Void>
//            guard let id = form.productId else { throw Abort(HTTPResponseStatus.badRequest) }
            let id = form.productId
            switch form.productTypeId {
            case 0:
                result = Smartphone.find(id, on: req).flatMap { smartphone -> EventLoopFuture<CartItem> in
                    guard let smartphone = smartphone else { throw Abort(HTTPResponseStatus.badRequest) }
                    let cartItem = CartItem(
                        id: nil,
                        imageUrl: smartphone.imageUrl,
                        productId: 0,
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
                        imageUrl: laptop.imageUrl,
                        productId: 0,
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
                        imageUrl: tv.imageUrl,
                        productId: 0,
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

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(CartItem.self).flatMap { cartItem in
            return cartItem.delete(on: req)
        }.transform(to: .ok)
    }
}
