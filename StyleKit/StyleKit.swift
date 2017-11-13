import Foundation

public final class StyleKit {
    private let stylist: Stylist
    
    public init?(fileUrl: URL, styleParser: StyleParsable? = nil, moduleName: String? = nil, logLevel: SKLogLevel = .error) {
        let fileLoader = FileLoader(fileUrl: fileUrl)
        guard let data = fileLoader.load() else { return nil }
        SKLogger.shared.setup(logLevel, showThreadName: true)
        stylist = Stylist(data: data, styleParser: styleParser, moduleName: moduleName)
    }
    
    public func apply() {
        self.stylist.apply()
    }
}
