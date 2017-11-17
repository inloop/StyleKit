import Foundation

final class FileLoader {
    static func load(_ styleURL: URL) -> [String: AnyObject]? {
        guard let data = try? Data(contentsOf: styleURL)
            , let json = load(data) else {
                SKLogger.severe("Issue parsing StyleKit JSON file: \(styleURL.absoluteString)" )
                return nil
        }
        return json
    }

    static func load(_ styleData: Data) -> [String: AnyObject]? {
        guard let contents = try? JSONSerialization.jsonObject(with: styleData, options: .allowFragments)
            , let json = contents as? [String: AnyObject] else {
                SKLogger.severe("Unable to serialize StyleKit JSON data." )
                return nil
        }
        return json
    }
}
