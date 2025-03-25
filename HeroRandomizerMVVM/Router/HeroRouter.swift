import SwiftUI
import UIKit

final class HeroRouter {
    var rootViewController: UINavigationController?

    func showDetails(for id: Int) {
        let detailVC = makeDetailViewController(id: id)
        rootViewController?.pushViewController(detailVC, animated: true)
    }

    private func makeDetailViewController(id: Int) -> UIViewController {
        let heroService = HeroServiceImpl()
        let viewModel = HeroDetailViewModel(service: heroService, heroId: id)
        
        let detailView = HeroDetailView(viewModel: viewModel)
        let detailVC = UIHostingController(rootView: detailView)
        return detailVC
    }
}
