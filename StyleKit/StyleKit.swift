import Foundation

public final class StyleKitConfig {
    let fileURL: URL
    public var styleParser: StyleParsable? = nil
    public var moduleName: String? = nil
    public var logLevel: SKLogLevel = .error
    public var watchForChanges = false

    public init(_ fileURL: URL, builder: (StyleKitConfig) -> ()) {
        self.fileURL = fileURL
        builder(self)
    }
}

public final class StyleKit: NSObject {
    private var stylist: Stylist
    private let fileURL: URL
    
    public init?(_ config: StyleKitConfig) {
        SKLogger.shared.setup(config.logLevel, showThreadName: true)
        guard let style = FileLoader.load(config.fileURL) else { return nil }
        fileURL = config.fileURL
        stylist = Stylist(style: style, styleParser: config.styleParser, moduleName: config.moduleName)

        super.init()

        if config.watchForChanges {
            NSFileCoordinator.addFilePresenter(self)
            SKLogger.debug("edit: \(config.fileURL.description)")
        }
    }
    
    public func apply() {
        self.stylist.apply()
    }
}

extension StyleKit: NSFilePresenter {
    public var presentedItemURL: URL? {
        return fileURL
    }

    public var presentedItemOperationQueue: OperationQueue {
        return .main
    }

    public func presentedItemDidChange() {
        SKLogger.debug("reloading...")
        guard let data = FileLoader.load(fileURL) else { return }
        stylist.apply(style: data)
        reloadWindows()
    }

    private func reloadWindows() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
