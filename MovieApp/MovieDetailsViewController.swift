import Foundation
import UIKit
import MovieAppData
import PureLayout

class MovieDetailsViewController: UIViewController {
    
    var imageView = UIImageView()
    let systemSize = UIScreen.main.bounds
    let help = UIView()
    let overLayerView = UIView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let scoreLabel = UILabel()
    let userScore = UILabel()
    let releaseDateLabel = UILabel()
    var categoriesLabel = UILabel()
    let durationLabel = UILabel()
    let overviewLabel = UILabel()
    let descriptionLabel = UILabel()
    let viewForStackView = UIView()
    
    let likeButton = FavoriteButton()
    
    let movieID: Int
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(imageView)
        title = "Movie Details"
        let movieData = MovieUseCase().getDetails(id: movieID)
        
        if let pictureURL = movieData?.imageUrl,
           let url = URL(string: pictureURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    let movieImage = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = movieImage
                    }
                }
            }
        }
        
        imageView.autoSetDimensions(to: CGSize(width: systemSize.width, height: 0.5 * systemSize.height))
        imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        
        overLayerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.addSubview(overLayerView)
        overLayerView.autoPinEdgesToSuperviewEdges()
        
        imageView.addSubview(help)
        help.autoPinEdgesToSuperviewEdges()
        
        titleLabel.text = movieData?.name
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        help.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0.25 * systemSize.height)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        
        imageView.addSubview(likeButton)
        likeButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        likeButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        
        if let year = movieData?.year {
            yearLabel.text = "(\(year))"
            yearLabel.textColor = UIColor.white
            yearLabel.font = UIFont(name: "Helvetica", size: 20)
            help.addSubview(yearLabel)
            yearLabel.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
            yearLabel.autoPinEdge(.leading, to: .trailing, of: titleLabel, withOffset: 3)
        }
        
        if let score = movieData?.rating {
            scoreLabel.text = "\(score)"
            scoreLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
            scoreLabel.textColor = UIColor(red: 252/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1)
            help.addSubview(scoreLabel)
            scoreLabel.autoPinEdge(.bottom, to: .top, of: titleLabel, withOffset: -25)
            scoreLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            userScore.text = "User Score"
            userScore.textColor = UIColor.white
            userScore.font = UIFont(name: "Arial", size: 18)
            help.addSubview(userScore)
            userScore.autoAlignAxis(.horizontal, toSameAxisOf: scoreLabel)
            userScore.autoPinEdge(.leading, to: .trailing, of: scoreLabel, withOffset: 3)
        }
        
        if let releaseDate = movieData?.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: releaseDate) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "d/M/yyyy"
                let formattedReleaseDate = outputDateFormatter.string(from: date)
                releaseDateLabel.text = formattedReleaseDate
                releaseDateLabel.font = UIFont(name: "Georgia", size: 18)
                releaseDateLabel.textColor = UIColor.white
                help.addSubview(releaseDateLabel)
                releaseDateLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 25)
                releaseDateLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            }
        }
        
        if let categories = movieData?.categories {
            var categoriesList = [String]()
            for c in categories {
                let categoryString: String
                switch c {
                case .action:
                    categoryString = "Action"
                case .adventure:
                    categoryString = "Adventure"
                case .comedy:
                    categoryString = "Comedy"
                case .crime:
                    categoryString = "Crime"
                case .drama:
                    categoryString = "Drama"
                case .fantasy:
                    categoryString = "Fantasy"
                case .romance:
                    categoryString = "Romance"
                case .scienceFiction:
                    categoryString = "Science Fiction"
                case .thriller:
                    categoryString = "Thriller"
                case .western:
                    categoryString = "Western"
                }
                
                categoriesList.append(categoryString)
            }
            let categoriesToDisplay = categoriesList.joined(separator: ", ")
            categoriesLabel.text = categoriesToDisplay
            categoriesLabel.font = UIFont(name: "Arial", size: 18)
            categoriesLabel.textColor = UIColor.white
            help.addSubview(categoriesLabel)
            categoriesLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
            categoriesLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            
            if let duration = movieData?.duration {
                let durationInHourAndMinutes = durationToHourAndMin(durationInMinutes: duration)
                durationLabel.text = "\(durationInHourAndMinutes.hours)h \(durationInHourAndMinutes.minutes)m"
                durationLabel.font = UIFont(name: "Arial-BoldMT", size: 18)
                durationLabel.textColor = UIColor.white
                help.addSubview(durationLabel)
                durationLabel.autoAlignAxis(.horizontal, toSameAxisOf: categoriesLabel)
                durationLabel.autoPinEdge(.leading, to: .trailing, of: categoriesLabel, withOffset: 5)
                
            }
        }
        
        overviewLabel.text = "Overview:"
        overviewLabel.textAlignment = .left
        overviewLabel.font = UIFont(name: "Futura-Bold", size: 18)
        view.addSubview(overviewLabel)
        overviewLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 10)
        overviewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = movieData?.summary
        descriptionLabel.font = UIFont(name: "Helvetica", size: 15)
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: 5)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        view.addSubview(viewForStackView)
        viewForStackView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 0)
        viewForStackView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 0)
        viewForStackView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
        viewForStackView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 0)
        
        if let crewMembers = movieData?.crewMembers {
            let numberOfCrewMembersPerRow = 3
            var count = 0
            let totalCrewMembers = crewMembers.count
            while count < totalCrewMembers {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .fill
                stackView.distribution = .fillEqually
                stackView.spacing = 10
                
                for _ in 0..<numberOfCrewMembersPerRow {
                        let roleLabel = UILabel()
                        roleLabel.font = UIFont(name: "Helvetica", size: 12)
                        roleLabel.textAlignment = .left
                        
                        let nameLabel = UILabel()
                        
                        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 13)
                        nameLabel.textAlignment = .center
                    
                        if count < crewMembers.count {
                            let member = crewMembers[count]
                            nameLabel.text = member.name
                            roleLabel.text = member.role
                        }
                        let memberStackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
                        memberStackView.axis = .vertical
                        memberStackView.alignment = .leading
                        memberStackView.distribution = .fillEqually
                        
                        stackView.addArrangedSubview(memberStackView)
                        
                        count += 1
                }
                viewForStackView.addSubview(stackView)
                if(count == 3){
                    stackView.autoPinEdge(.top, to: .top, of: viewForStackView, withOffset: 20)
                }else{
                    stackView.autoPinEdge(.top, to: .top, of: viewForStackView, withOffset: CGFloat(45 * count / 3))
                }
                
                stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
                stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            }
        }
        
        help.transform = help.transform.translatedBy(x: -view.frame.width, y: 0)
        descriptionLabel.transform = descriptionLabel.transform.translatedBy(x: -view.frame.width, y: 0)
        viewForStackView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.help.transform = .identity
                self.descriptionLabel.transform = .identity
            }, completion: { _ in
                UIView.animate(
                    withDuration: 0.8,
                    delay: 0,
                    options: [.curveEaseIn],
                    animations: {
                        self.viewForStackView.alpha = 1.0
            })
    })
}

func durationToHourAndMin(durationInMinutes: Int) -> (hours: Int, minutes: Int) {
    let hours = durationInMinutes / 60
    let minutes = durationInMinutes % 60
    return (hours, minutes)
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
}

override var shouldAutorotate: Bool {
    return false
}
}
