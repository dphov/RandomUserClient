

import NeedleFoundation
import UIKit

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->RUCTabBarComponent") { component in
        return RUCTabBarDependency07a4819c849fe5d89ed4Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->RUCUserInfoComponent") { component in
        return RUCUserInfoDependency4e892684adbc34bdc568Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->RUCTabBarComponent->RUCUsersListComponent") { component in
        return RUCUsersListDependencya64ee3b518c3e35e9a81Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->RUCTabBarComponent->RUCFavoritesComponent") { component in
        return RUCFavoritesDependency2ef0e8dcabff058949acProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootComponent->RUCTabBarComponent
private class RUCTabBarDependency07a4819c849fe5d89ed4Provider: RUCTabBarDependency {
    var realmServiceMethods: RealmServiceMethods {
        return rootComponent.realmServiceMethods
    }
    private let rootComponent: RootComponent
    init(component: NeedleFoundation.Scope) {
        rootComponent = component.parent as! RootComponent
    }
}
/// ^->RootComponent->RUCUserInfoComponent
private class RUCUserInfoDependency4e892684adbc34bdc568Provider: RUCUserInfoDependency {
    var realmServiceMethods: RealmServiceMethods {
        return rootComponent.realmServiceMethods
    }
    private let rootComponent: RootComponent
    init(component: NeedleFoundation.Scope) {
        rootComponent = component.parent as! RootComponent
    }
}
/// ^->RootComponent->RUCTabBarComponent->RUCUsersListComponent
private class RUCUsersListDependencya64ee3b518c3e35e9a81Provider: RUCUsersListDependency {
    var realmServiceMethods: RealmServiceMethods {
        return rootComponent.realmServiceMethods
    }
    var rucUserInfoComponent: RUCUserInfoComponent {
        return rootComponent.rucUserInfoComponent
    }
    private let rootComponent: RootComponent
    init(component: NeedleFoundation.Scope) {
        rootComponent = component.parent.parent as! RootComponent
    }
}
/// ^->RootComponent->RUCTabBarComponent->RUCFavoritesComponent
private class RUCFavoritesDependency2ef0e8dcabff058949acProvider: RUCFavoritesDependency {
    var realmServiceMethods: RealmServiceMethods {
        return rootComponent.realmServiceMethods
    }
    var rucUserInfoComponent: RUCUserInfoComponent {
        return rootComponent.rucUserInfoComponent
    }
    private let rootComponent: RootComponent
    init(component: NeedleFoundation.Scope) {
        rootComponent = component.parent.parent as! RootComponent
    }
}
