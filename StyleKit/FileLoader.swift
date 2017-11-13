import Foundation

final class FileLoader {
    static func load(_ styleURL: URL) -> [String:AnyObject]? {
        if let data = try? Data(contentsOf: styleURL) {
            do {
                let contents = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = contents as? [String: AnyObject] {
                    return dictionary
                }
            } catch {
                SKLogger.severe("Issue parsing StyleKit JSON file: \(styleURL.absoluteString)" )
            }
        }
        return nil
    }
    
}
