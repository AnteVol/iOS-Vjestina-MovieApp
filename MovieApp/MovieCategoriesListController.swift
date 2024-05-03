import UIKit
import MovieAppData
import PureLayout

class MovieCategoriesListController: UIViewController {
    let allMovies = MovieAppData.MovieUseCase()
    var popularLabel : UILabel?
    var freeLabel : UILabel?
    var trendingLabel : UILabel?
    
    lazy var popularStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var popularScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(popularStackView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var freeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var freeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(freeStackView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var trendingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var trendingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(trendingStackView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constructHierarchyAndLayout()
        styleViews()
    }

    
    func addMovies(films: [MovieAppData.MovieModel], stackViewToAdd: UIStackView) {
        for movie in films {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            stackViewToAdd.addArrangedSubview(imageView)

            loadImage(from: movie.imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
            
            imageView.heightAnchor.constraint(equalToConstant: 0.25 * UIScreen.main.bounds.size.height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 0.33 * UIScreen.main.bounds.size.width).isActive = true
            
            let heatButton = HeatButton()
            imageView.addSubview(heatButton)
            heatButton.autoPinEdge(toSuperviewEdge: .top, withInset: 30)
            heatButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        }
    }



    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
extension MovieCategoriesListController {
    
    func constructHierarchyAndLayout() {
        view.addSubview(popularScrollView)
        popularLabel = UILabel()
        popularLabel?.text = "What's popular"
        view.addSubview(popularLabel!)
        popularLabel?.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        popularLabel?.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        popularScrollView.autoPinEdge(.top, to: .bottom, of: popularLabel!, withOffset: 10)
        popularScrollView.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        popularScrollView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        popularScrollView.autoPinEdge(toSuperviewEdge: .bottom)
        popularStackView.autoPinEdgesToSuperviewEdges()
        addMovies(films: allMovies.popularMovies, stackViewToAdd: popularStackView)
        
        view.addSubview(freeScrollView)
        freeLabel = UILabel()
        freeLabel?.text = "Free to Watch"
        view.addSubview(freeLabel!)
        freeLabel?.autoPinEdge(.top, to: .bottom, of: popularStackView, withOffset: 20)
        freeLabel?.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        freeScrollView.autoPinEdge(.top, to: .bottom, of: freeLabel!, withOffset: 10)
        freeScrollView.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        freeScrollView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        freeScrollView.autoPinEdge(toSuperviewEdge: .bottom)
        freeStackView.autoPinEdgesToSuperviewEdges()
        addMovies(films: allMovies.freeToWatchMovies, stackViewToAdd: freeStackView)
        
        view.addSubview(trendingScrollView)
        trendingLabel = UILabel()
        trendingLabel?.text = "Trending"
        view.addSubview(trendingLabel!)
        trendingLabel?.autoPinEdge(.top, to: .bottom, of: freeStackView, withOffset: 20)
        trendingLabel?.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        trendingScrollView.autoPinEdge(.top, to: .bottom, of: trendingLabel!, withOffset: 10)
        trendingScrollView.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        trendingScrollView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        trendingScrollView.autoPinEdge(toSuperviewEdge: .bottom)
        trendingStackView.autoPinEdgesToSuperviewEdges()
        addMovies(films: allMovies.trendingMovies, stackViewToAdd: trendingStackView)
    }
    
    func styleViews() {
        freeLabel!.textAlignment = .left
        freeLabel!.font = UIFont(name: "Futura-Bold", size: 18)
        freeLabel!.textColor = UIColor(red: 43/255.0, green: 9/255.0, blue: 86/255.0, alpha: 1)
        trendingLabel!.textAlignment = .left
        trendingLabel!.font = UIFont(name: "Futura-Bold", size: 18)
        trendingLabel!.textColor = UIColor(red: 43/255.0, green: 9/255.0, blue: 86/255.0, alpha: 1)
        popularLabel!.textAlignment = .left
        popularLabel!.font = UIFont(name: "Futura-Bold", size: 18)
        popularLabel!.textColor = UIColor(red: 43/255.0, green: 9/255.0, blue: 86/255.0, alpha: 1)
    }
    
}
