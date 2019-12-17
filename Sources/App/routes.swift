import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let smartphoneController = SmartphoneController()
    router.get("smartphone", use: smartphoneController.index)
    router.get("smartphone", Int.parameter, use: smartphoneController.unit)
    router.post("smartphone", use: smartphoneController.create)
    router.delete("smartphone", Smartphone.parameter, use: smartphoneController.delete)

    let laptopController = LaptopController()
    router.get("laptop", use: laptopController.index)
    router.get("laptop", Int.parameter, use: laptopController.unit)
    router.post("laptop", use: laptopController.create)
    router.delete("laptop", Laptop.parameter, use: laptopController.delete)

    let tvController = TVController()
    router.get("tv", use: tvController.index)
    router.get("tv", Int.parameter, use: tvController.unit)
    router.post("tv", use: tvController.create)
    router.delete("tv", TV.parameter, use: tvController.delete)

    let userController = UserController()
    router.post("user/register", use: userController.create)
    router.delete("user", use: userController.delete)
    router.post("user/update", use: userController.update)

    let cartController = CartController()
    router.get("cart", use: cartController.index)
    router.post("cart", use: cartController.add)
    router.delete("cart", CartItem.parameter, use: cartController.delete)

//    let cartController = CartController()
//    router.get("cart", use: cartController.index)
}
