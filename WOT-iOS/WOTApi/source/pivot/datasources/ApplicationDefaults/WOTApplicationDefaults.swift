//
//  WOTApplicationDefaults.swift
//  WOTApi
//
//  Created by Paul on 21.01.23.
//

class WOTApplicationDefaults {

    static func registerDefaultSettings() {
//        id<ContextProtocol> appDelegate = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
//        id<DataStoreProtocol> coreDataProvider = appDelegate.dataStore;
//        [coreDataProvider performWithBlock:^(id<ManagedObjectContextProtocol> _Nonnull context) {
//
//            NSString *entityName = NSStringFromClass([ListSetting class]);
//            NSError *error = nil;
//            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
//            [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:WOTApiKeyOrderBy.orderBy ascending:YES]]];
//            NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:nil cacheName:nil];
//            [fetchedResultController performFetch:&error];
//
//            #warning will recreate objects if user has deleted everything
//            if ([[fetchedResultController fetchedObjects] count] == 0) {
//
//                [WOTTankListSettingsDatasource createSortSettingForKey:WOTApiFields.nation ascending:NO orderBy:0 callback:NULL];
//                [WOTTankListSettingsDatasource createSortSettingForKey:WOTApiFields.type ascending:YES orderBy:1 callback:NULL];
//
//
//                [WOTTankListSettingsDatasource createGroupBySettingForKey:WOTApiFields.nation ascending:YES orderBy:0 callback:NULL];
//
//                [WOTTankListSettingsDatasource createFilterBySettingForKey:WOTApiFields.tier value:@"6" callback:NULL];
//
//                [coreDataProvider stashWithManagedObjectContext:context completion:^(id<ManagedObjectContextProtocol> _Nullable context, NSError * _Nullable error) {
//                    if (error != nil) {
//                        NSLog(@"%@",error.localizedDescription);
//                    }
//
//                }];
//            }
//        }];
    }

    static func setLanguage(_: AnyObject) {
//        WOTWEBRequestDefaultLanguage = language;
//        if (language) {
//
//            [[NSUserDefaults standardUserDefaults] setObject:language forKey:WOTApiLanguage.default_login_language];
//        } else {
//
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:WOTApiLanguage.default_login_language];
//        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    static func language() -> AnyObject? {
        nil
//        if ([WOTWEBRequestDefaultLanguage length] == 0){
//
//            NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:WOTApiLanguage.default_login_language];
//            if ([language length] == 0){
//
//                WOTWEBRequestDefaultLanguage =  WOTApiDefaults.languageRU;
//            } else {
//
//                WOTWEBRequestDefaultLanguage = language;
//            }
//        }
//        return WOTWEBRequestDefaultLanguage;
    }
}
