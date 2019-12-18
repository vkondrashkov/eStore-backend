import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let smartphoneController = SmartphoneController()
    router.get("smartphone", use: smartphoneController.index)
    router.get("smartphone", Int.parameter, use: smartphoneController.unit)
    router.post("smartphone", Int.parameter, use: smartphoneController.update)
    router.post("smartphone", use: smartphoneController.create)
    router.delete("smartphone", Smartphone.parameter, use: smartphoneController.delete)

    let laptopController = LaptopController()
    router.get("laptop", use: laptopController.index)
    router.get("laptop", Int.parameter, use: laptopController.unit)
    router.post("laptop", Int.parameter, use: laptopController.update)
    router.post("laptop", use: laptopController.create)
    router.delete("laptop", Laptop.parameter, use: laptopController.delete)

    let tvController = TVController()
    router.get("tv", use: tvController.index)
    router.get("tv", Int.parameter, use: tvController.unit)
    router.post("tv", Int.parameter, use: tvController.update)
    router.post("tv", use: tvController.create)
    router.delete("tv", TV.parameter, use: tvController.delete)

    let userController = UserController()
    router.get("user", use: userController.index)
    router.post("user", use: userController.update)
    router.post("user/authorize", use: userController.authorize)
    router.post("user/register", use: userController.register)
    router.post("user/guest", use: userController.authorizeAsGuest)
    router.delete("user", User.parameter, use: userController.delete)

    let cartController = CartController()
    router.get("cart", use: cartController.index)
    router.post("cart", use: cartController.add)
    router.delete("cart", CartItem.parameter, use: cartController.delete)
}
