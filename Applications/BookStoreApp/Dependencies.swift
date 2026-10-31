// Dependencies.swift

import Vapor
import Fluent
import SQLite
import SQLiteFluent

public func configure(_ app: Application) throws {
    // Register providers first
    try app.register(provider: SQLiteProvider())
    try app.register(provider: SQLiteFluentProvider())
    try app.register(provider: FluentProvider())
    
    // Register migrations
    app.migrations.add(CreateBooks())
    
    // Configure router
    let router = EngineRouter.default()
    try routes(router)
    app.middleware.use(router)
}