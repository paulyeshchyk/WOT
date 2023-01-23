//
//  VIPER.swift
//  WOT-iOS
//
//  Created on 8/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public enum VIPERModule: String {
    case Pivot
    case Tree
}

public protocol VIPERViewProtocol: AnyObject {
    var presenter: VIPERPresenterProtocol? { get set }
}

public protocol VIPERInteractorProtocol: AnyObject {
    var presenter: VIPERPresenterProtocol { get set }
}

public protocol VIPERPresenterProtocol: AnyObject {
    var wireFrame: VIPERWireFrameProtocol { get set }
    var interactor: VIPERInteractorProtocol { get set }
    var view: VIPERViewProtocol { get set }
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            UnsafeRawPointer($0).load(as: T.self)
        }
        if next.hashValue == i {
            i += 1
            return next
        } else {
            return nil
        }
    }
}

public typealias InitializedModule = (view: VIPERViewProtocol, interactor: VIPERInteractorProtocol, presenter: VIPERPresenterProtocol, wireFrame: VIPERWireFrameProtocol)

extension VIPERModule {
    func classFor(_ viperEntity: String) -> String {
        let className = self.rawValue + viperEntity
        return Bundle.classWithName(className)
    }

    static func module(for wireFrame: VIPERWireFrame) -> VIPERModule? {
        for module in iterateEnum(self) {
            let lhs = module.classFor("WireFrame")
            let rhs = Bundle.classWithName(String(describing: type(of: wireFrame)))
            if lhs == rhs {
                wireFrame.module = module
                return module
            }
            fatalError("Unknown module")
        }
        return nil
    }

    static func initialize(with view: VIPERViewProtocol,
                           interactor: VIPERInteractorProtocol,
                           presenter: VIPERPresenterProtocol,
                           wireFrame: VIPERWireFrameProtocol) -> InitializedModule {
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.view = view

        view.presenter = presenter

        interactor.presenter = presenter
        wireFrame.presenter = presenter

        return (view, interactor, presenter, wireFrame)
    }

    public var wireFrame: VIPERWireFrame? {
        let classFor = self.classFor("WireFrame")
        guard let classObject = NSClassFromString(classFor) else {
            return nil
        }
        guard let wireframeClass = classObject as? VIPERWireFrame.Type else {
//            fatalError("Failed to create Wireframe for module \(self)")
            return nil
        }
        return wireframeClass.init()
    }
}

// MARK: - Classes
extension Bundle {
    fileprivate static var name: String { // For correct runtime object creation we need this id
        if let productName = main.infoDictionary?["Product module name"] as? String {
            return productName
        }
        fatalError("[Info.plist] Failed to read <Product module name> from Info.plist")
    }

    class func classWithName(_ className: String) -> String {
        return className
//        return (name + "." + className)
//            .replacingOccurrences(of: " ", with: "_")
//            .replacingOccurrences(of: "-", with: "_")
    }
}
