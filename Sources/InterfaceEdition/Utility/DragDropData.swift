import Foundation


public final class DragDropData: NSObject, NSItemProviderWriting, NSItemProviderReading {

    public static let writableTypeIdentifiersForItemProvider = ["public.data"]
    public static let readableTypeIdentifiersForItemProvider = ["public.data"]
    
    public let data: Data
    private let progress = Progress()
    
    public init(data: Data) {
        self.data = data
        progress.totalUnitCount = Int64(data.count)
        progress.completedUnitCount = progress.totalUnitCount
    }
    
    public convenience init?<Object>(object: Object, encoder: JSONEncoder = JSONEncoder()) where Object: Encodable {
        guard let data = try? encoder.encode(object) else { return nil }
        self.init(data: data)
    }
    
    public func decode<Object>(_ object: Object.Type, decoder: JSONDecoder = JSONDecoder()) -> Object? where Object: Decodable {
        try? decoder.decode(object, from: data)
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        completionHandler(data, nil)
        return progress
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> DragDropData {
        DragDropData(data: data)
    }
}
