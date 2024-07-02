import UIKit

class Router {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showTabView()
    }
    
    func showTabView() {
        let tabViewController = NavigationBar()
        
        let movieCategoriesListController = MovieCategoriesListController(router: self)
        let movieListNavigationController = UINavigationController(rootViewController: movieCategoriesListController)
        movieListNavigationController.tabBarItem = UITabBarItem(title: "Movie List", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let favoritesViewController = FavoriteViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        

        tabViewController.viewControllers = [movieListNavigationController, favoritesNavigationController]
        
        navigationController.setViewControllers([tabViewController], animated: true)
    }
    
    func showMovieDetails(movieId: Int) {
        guard
            let currentViewController = navigationController.topViewController as? NavigationBar,
            let navigationController = currentViewController.selectedViewController as? UINavigationController
        else { return }
        
        let vc = MovieDetailsViewController(movieID: movieId)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
