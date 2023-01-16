//
//  MappingCoordinatorDecodeHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - MappingCoordinatorDecodeHelper

class MappingCoordinatorDecodeHelper {

    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    private let appContext: Context?
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?

    // MARK: Lifecycle

    init(appContext: MappingCoordinatorDecodeHelper.Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error ?? Errors.fetchResultIsNotPresented)
            return
        }
        guard let jsonMap = jsonMap else {
            completion?(fetchResult, Errors.contextPredicateIsNotDefined)
            return
        }

        guard let managedObject = fetchResult.managedObject() as? JSONDecodableProtocol else {
            completion?(fetchResult, Errors.fetchResultIsNotJSONDecodable(fetchResult))
            return
        }
        //
        do {
            try managedObject.decode(using: jsonMap, managedObjectContextContainer: fetchResult, appContext: appContext)

            appContext?.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
                self.completion?(fetchResult, error)
            }
        } catch {
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + MappingCoordinatorDecodeHelper.Errors

extension MappingCoordinatorDecodeHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case fetchResultIsNotPresented
        case contextPredicateIsNotDefined
        case fetchResultIsNotJSONDecodable(FetchResultProtocol?)

        public var description: String {
            switch self {
            case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
            case .contextPredicateIsNotDefined: return "\(type(of: self)): Context predicate is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }

}
