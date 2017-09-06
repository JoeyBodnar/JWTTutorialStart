import Vapor

extension Droplet {
    func setupRoutes() throws {
        let userController = UserController(droplet: self)
        userController.addRoutes()
        
        
    }
}
