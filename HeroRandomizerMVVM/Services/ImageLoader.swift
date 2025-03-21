import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .sink { [weak self] loadedImage in
                guard let self = self, let loadedImage = loadedImage else { return }
                self.imageCache.setObject(loadedImage, forKey: NSString(string: urlString))
                self.image = loadedImage
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
