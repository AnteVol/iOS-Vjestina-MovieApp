import UIKit

class NavigationBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        
        let movieCategoriesListController = MovieCategoriesListController()
        let movieListNavigationController = UINavigationController(rootViewController: movieCategoriesListController)
        movieListNavigationController.tabBarItem = UITabBarItem(title: "Movie List", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let favoritesViewController = FavoriteViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        

        viewControllers = [movieListNavigationController, favoritesNavigationController]
    }
}

