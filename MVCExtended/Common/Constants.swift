import Foundation

struct Constants {
    static var baseURL: URL? {
        return (Bundle.main.object(forInfoDictionaryKey: "Base URL") as! String).toURL()
    }
}
