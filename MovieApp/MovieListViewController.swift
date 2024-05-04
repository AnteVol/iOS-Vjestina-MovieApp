import UIKit
import MovieAppData
import PureLayout

class MovieListViewController: UIViewController {
    let allMovies = MovieAppData.MovieUseCase().allMovies
    let cellIdentifier = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0xF4/255.0, green: 0xF4/255.0, blue: 0xF4/255.0, alpha: 1.0)
        title = "Movie List"
        constructHierarchy()
    }
}

extension MovieListViewController {
    func constructHierarchy() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor(red: 0xF4/255.0, green: 0xF4/255.0, blue: 0xF4/255.0, alpha: 1.0)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as! MovieCell
        
        let movie = allMovies[indexPath.item]
        
        cell.titleLabel.text = movie.name
        cell.loadImage(from: movie.imageUrl)
        cell.descriptionLabel.text = movie.summary
        
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = allMovies[indexPath.item]
        print("Selected movie: \(selectedMovie.id)")
        
        let movieDetailsViewController = MovieDetailsViewController(movieID: selectedMovie.id)
        
        let navigationController = UINavigationController(rootViewController: movieDetailsViewController)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController.navigationBar.standardAppearance = appearance
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        movieDetailsViewController.navigationItem.leftBarButtonItem = backButton
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}


extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 0.07 * view.frame.size.width, height: view.frame.size.height / 4)
    }
}

class MovieCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.systemFont(ofSize: 14)
        description.minimumScaleFactor = 0.5
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = .gray
        return description
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layer.cornerRadius = 20.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true;
        setupViews()
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        designView()
    }
    
    private func designView(){
        imageView.autoPinEdge(toSuperviewEdge: .leading, withInset:0)
        imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        imageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        imageView.autoMatch(.height, to: .height, of: self)
        imageView.autoSetDimension(.width, toSize: 100)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 8)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        descriptionLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 8)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 4)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
}
