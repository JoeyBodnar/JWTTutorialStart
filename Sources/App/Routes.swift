import Vapor

extension Droplet {
    func setupRoutes() throws {
        let userController = UserController(droplet: self)
        userController.addRoutes()
        
        let jwtMiddleware = JSONWebTokenMiddleware()
        let authed = grouped(jwtMiddleware)
        
        authed.get("protectedroute") { request in
            return "authenticated"
        }
        
    }
}
