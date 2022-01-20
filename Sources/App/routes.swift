import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let magazinesController = MagazinesController()
    
    try app.register(collection: magazinesController)
}
