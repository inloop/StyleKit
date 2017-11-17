import Foundation

public final class StyleKitConfig {
    let fileURL: URL
    public var styleParser: StyleParsable? = nil
    public var moduleName: String? = nil
    public var logLevel: SKLogLevel = .error

    public init(_ fileURL: URL, builder: (StyleKitConfig) -> ()) {
        self.fileURL = fileURL
        builder(self)
    }
}

public final class StyleKit: NSObject {
    private var stylist: Stylist

    public convenience init?(fileUrl: URL) {
        let config = StyleKitConfig(fileUrl, builder: { _ in })
        self.init(config)
    }
    
    public init?(_ config: StyleKitConfig) {
        SKLogger.shared.setup(config.logLevel, showThreadName: true)
        guard let style = FileLoader.load(config.fileURL) else { return nil }
        stylist = Stylist(style: style, styleParser: config.styleParser, moduleName: config.moduleName)
        super.init()
    }
    
    public func apply() {
        self.stylist.apply()
    }

    public func applyStyle(data: Data) {
        guard let style = FileLoader.load(data) else { return }
        stylist.apply(style: style)
        reloadWindows()
    }
}

extension StyleKit {
    private func reloadWindows() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                view.setNeedsLayout()
                view.setNeedsDisplay()
                window.addSubview(view)
            }
        }
    }
}
