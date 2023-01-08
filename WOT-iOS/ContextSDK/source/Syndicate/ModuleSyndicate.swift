//
//  ModuleSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 8.01.23.
//

class ModuleSyndicate {

    init(appContext: Context) {
        self.appContext = appContext
    }

    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

    let appContext: Context
    var managedObjectLinker: ManagedObjectLinkerProtocol?
    var managedObjectExtractor: ManagedObjectExtractable?
    var jsonCollection: JSONCollectionProtocol?
    var contextPredicate: ContextPredicateProtocol?
    var nspredicate: NSPredicate?
    var modelClass: PrimaryKeypathProtocol.Type?
    var managedObjectContext: ManagedObjectContextProtocol?

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    //
    func run() {
        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.managedObjectLinker = managedObjectLinker
        managedObjectLinkerHelper.completion = { fetchResult, error in
            self.completion?(fetchResult, error)
        }

        let mappingCoordinatorDecodeHelper = MappingCoordinatorDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonCollection = jsonCollection
        mappingCoordinatorDecodeHelper.contextPredicate = contextPredicate
        mappingCoordinatorDecodeHelper.managedObjectCreator = managedObjectLinker
        mappingCoordinatorDecodeHelper.managedObjectExtractor = managedObjectExtractor
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.run(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.nspredicate = nspredicate
        datastoreFetchHelper.managedObjectContext = managedObjectContext
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
        }
        datastoreFetchHelper.run()
    }
}
