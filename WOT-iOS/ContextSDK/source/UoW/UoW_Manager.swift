//
//  UoW_Manager.swift
//  ContextSDK
//
//  Created by Paul on 20.01.23.
//

// MARK: - UoW_Manager

open class UoW_Manager {

    public typealias Context = LogInspectorContainerProtocol

    private var uowList: [UoW_Protocol] = []

    private let appContext: Context
    public init(appContext: Context) {
        self.appContext = appContext
    }

    private func moveToQueue(_ uow: UoW_Protocol) throws {
        log(.uowAddToQueue(uow))
        uow.status = .inQueue

        log(.uowWillRun(uow))
        try uow.run(forListener: self)
        uow.status = .inProgress
        log(.uowDidRun(uow))
    }

    private func subscribe(to uow: UoW_Protocol) throws {
        log(.uowSubscribed(uow))
        uowList.append(uow)
    }

    private func unsubscribe(from uow: UoW_Protocol) throws {
        //
        log(.uowWillUnsubscribe(uow))
        let cnt = uowList.count
        uowList.removeAll(where: { $0.MD5 == uow.MD5 })
        if cnt == uowList.count {
            throw Errors.failedToUnsubscribe
        }
        log(.uowDidUnsubscribe(uow))
    }
}

// MARK: - UoW_Manager + UoW_ManagerProtocol

extension UoW_Manager: UoW_ManagerProtocol {

    public func uow(by config: UoW_Config_Protocol) throws -> UoW_Protocol {
        let resultType = config.uowClass
        let result = try resultType.init(configuration: config)
        result.status = .initialization
        return result
    }

    public func perform(uow: UoW_Protocol) throws {
        //
        log(.uowWillPerform(uow))

        do {
            //
            try subscribe(to: uow)
            try moveToQueue(uow)

            log(.uowDidPerform(uow))
        } catch {
            try unsubscribe(from: uow)

            log(.error(error))
        }
    }
}

// MARK: - UoW_Manager + UoW_Listener

extension UoW_Manager: UoW_Listener {

    public func didFinishUOW(_ uow: UoW_Protocol, error: Error?) {
        uow.status = .finish

        logFinish(uow, orError: error)

        do {
            try unsubscribe(from: uow)
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}

// MARK: - Logs

extension UoW_Manager {
    private func log(_ loggable: Loggable) {
        appContext.logInspector?.log(loggable, sender: self)
    }

    private func logFinish(_ uow: UoW_Protocol, orError error: Error?) {
        var logs: [String] = []
        logs.append("finished: \(String(describing: uow))")
        if let err = error {
            logs.append("with error: \(err)")
        }
        if error == nil {
            appContext.logInspector?.log(.uow(logs.joined(separator: ";")), sender: self)
        } else {
            appContext.logInspector?.log(.error(logs.joined(separator: ";")), sender: self)
        }
    }

}

extension Loggable {

    static func uowAddToQueue(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("added into queue: \(String(describing: uow))") }
    static func uowWillRun(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("will run: \(String(describing: uow))") }
    static func uowDidRun(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("did run: \(String(describing: uow))") }
    static func uowSubscribed(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("subscribed to: \(String(describing: uow))") }
    static func uowWillUnsubscribe(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("will unsubscribe from: \(String(describing: uow))") }
    static func uowDidUnsubscribe(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("did unsubscribe from: \(String(describing: uow))") }
    static func uowWillPerform(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("will perform: \(String(describing: uow))") }
    static func uowDidPerform(_ uow: UoW_Protocol) -> Loggable { Loggable.uow("did perform: \(String(describing: uow))") }
}

// MARK: - UoW_Manager.Errors

extension UoW_Manager {
    enum Errors: Error {
        case failedToUnsubscribe
    }
}
