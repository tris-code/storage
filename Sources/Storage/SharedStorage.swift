/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

import Log
import Fiber

public class SharedStorage {
    let storage: Storage
    let broadcast: Broadcast<Bool>
    let procedures: StoredProcedures

    public init(for storage: Storage) {
        self.storage = storage
        self.broadcast = .init()
        self.procedures = .init(for: storage)
    }

    var isNewCycle: Bool = true

    func scheduleWALWriter() {
        if isNewCycle {
            isNewCycle = false
            async.task { [unowned self] in
                defer { self.isNewCycle = true }
                // move the task to the end of the loop cycle
                // so it runs after all the clients have been processed
                async.yield()

                guard self.storage.isDirty else {
                    return
                }
                do {
                    Log.debug("writing log")
                    try self.storage.writeLog()
                    self.broadcast.dispatch(true)
                } catch {
                    Log.error("can't write log: \(error)")
                    self.broadcast.dispatch(false)
                }
            }
        }
    }

    func syncronized<T>(_ task: () throws -> T?) rethrows -> T? {
        scheduleWALWriter()

        let result = try task()

        guard let success = broadcast.wait() else {
            Log.error("the task was canceled")
            return nil
        }

        guard success else {
            Log.error("the task failed")
            return nil
        }

        return result
    }

    public func call(
        _ function: String,
        using decoder: Decoder? = nil) throws -> Encodable?
    {
        return try syncronized {
            switch decoder {
            case .some(let decoder):
                return try procedures.call(function, using: decoder)
            case .none:
                return try procedures.call(function)
            }
        }
    }
}

extension SharedStorage {
    public func registerProcedure<T: Entity>(
        name: String,
        requires container: T.Type,
        body: @escaping (Storage.Container<T>) throws -> Encodable)
    {
        procedures.register(
            name: name,
            requires: container,
            body: body)
    }

    public func registerProcedure<Arguments: Decodable, T: Entity>(
        name: String,
        arguments: Arguments.Type,
        requires container: T.Type,
        body: @escaping (Arguments, Storage.Container<T>) throws -> Encodable)
    {
        procedures.register(
            name: name,
            arguments: arguments,
            requires: container,
            body: body)
    }
}

extension SharedStorage {
    public func register<T: Entity>(_ type: T.Type) throws {
        try storage.register(type)
    }
}

extension SharedStorage: PersistentContainer {
    var isDirty: Bool {
        return storage.isDirty
    }

    public func restore() throws {
        try storage.restore()
    }

    func writeLog() throws {
        try storage.writeLog()
    }

    func makeSnapshot() throws {
        try storage.makeSnapshot()
    }
}
