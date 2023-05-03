/// 服务容器
public protocol Container: AnyObject {
    /// 基于参数的服务注册
    func register<T, A>(_ serviceType: T.Type, name: String?, factory: @escaping (Container, A) -> T)
    /// 基于参数的服务解析
    func resolve<T, A>(_ serviceType: T.Type, name: String?, argument: A) -> T?
}
public extension Container {
    /// 无参数服务注册
    func register<T>(_ serviceType: T.Type = T.self, factory: @escaping (Container) -> T) {
        return register(serviceType, name: nil) { (_: Container, _: Void) in
            factory(self)
        }
    }
    /// 无参数解析
    func resolve<T>(_ serviceType: T.Type = T.self) -> T? {
        return resolve(serviceType, name: nil, argument: ())
    }
}
protocol ServiceProvider {
    associatedtype ServiceType
    func resolve() -> ServiceType
    
    func register()
    func boot()
}

public class RXContainer: Container {
    public func register<T, A>(
        _ serviceType: T.Type,
        name: String?,
        factory: @escaping (Container, A) -> T) {
        let key = SerivceKey(serviceType: serviceType, arg: A.self, name: name)
        let value = BeanFactory(serviceType: serviceType, argumentsType: A.self, factory: factory)
        value.container = self
        factories[key] = value
    }

    public static let shared = RXContainer()
    public init() {}
    internal var factories = [SerivceKey: BeanFactory]()
}

struct SerivceKey: Hashable {
    static func == (lhs: SerivceKey, rhs: SerivceKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(serviceType))
        hasher.combine(ObjectIdentifier(argumentType))
        hasher.combine(name)
    }
    
    let serviceType: Any.Type
    let argumentType: Any.Type
    let name: String?
    init(serviceType: Any.Type, arg: Any.Type, name: String?) {
        self.serviceType = serviceType
        self.argumentType = arg
        self.name = name
    }
    func withoutName() -> SerivceKey {
        return SerivceKey(serviceType: serviceType, arg: argumentType, name: nil)
    }
    func onlyService() -> SerivceKey {
        return SerivceKey(serviceType: serviceType, arg: Void.self, name: nil)
    }
}
