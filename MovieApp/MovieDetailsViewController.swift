import Foundation
import UIKit
import MovieAppData
import PureLayout

class MovieDetailsViewController : UIViewController {

    var imageView = UIImageView()
    let systemSize = UIScreen.main.bounds
    
    let overLayerView = UIView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()
    let scoreLabel = UILabel()
    let userScore = UILabel()
    let releaseDateLabel = UILabel()
    var categoriesLabel = UILabel()
    let durationLabel = UILabel()
    let overiewLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let likeButton = FavoriteButton()
    
    lazy var dateParserFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(imageView)
        
        let movieData = MovieUseCase().getDetails(id: 111161)
        print(movieData)
        
        if let pictureURL = movieData?.imageUrl {
            if let url = URL(string: pictureURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        let movieImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView.image = movieImage
                        }
                    }
                }
            }
        }
        
     // imageView.autoSetDimensions(to: CGSize(width: systemSize.width, height: 0.5 * systemSize.height))
       // imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        imageView.autoPinEdge(toSuperviewEdge: .top)
        imageView.autoPinEdge(toSuperviewEdge: .leading)
        imageView.autoPinEdge(toSuperviewEdge: .trailing)
        imageView.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        overLayerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.addSubview(overLayerView)
        overLayerView.autoPinEdgesToSuperviewEdges()
        
        // NSMutableAttributedString
        titleLabel.text = "movieData?.namemovieData?.namemovieData?.namemovieData?.namemovieData?.namemovieData?.name"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        imageView.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0.25 * systemSize.height)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        
        yearLabel.textColor = UIColor.white
        yearLabel.font = UIFont(name: "Helvetica", size: 20)
        imageView.addSubview(yearLabel)
        yearLabel.autoAlignAxis(.horizontal, toSameAxisOf: titleLabel)
        yearLabel.autoPinEdge(.leading, to: .trailing, of: titleLabel, withOffset: 3)
        yearLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        if let year = movieData?.year{
            yearLabel.text = "(" + String(year) + ")"
        }
        
        if let score = movieData?.rating {
            scoreLabel.text = String(score)
            scoreLabel.font = UIFont(name: "Arial-BoldMT", size: 20)
            scoreLabel.textColor = UIColor(red: 252/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1)
            imageView.addSubview(scoreLabel)
            scoreLabel.autoPinEdge(.bottom, to: .top, of: titleLabel, withOffset: -25)
            scoreLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            userScore.text = "User Score"
            userScore.textColor = UIColor.white
            userScore.font = UIFont(name: "Arial", size: 18)
            imageView.addSubview(userScore)
            userScore.autoAlignAxis(.horizontal, toSameAxisOf: scoreLabel)
            userScore.autoPinEdge(.leading, to: .trailing, of: scoreLabel, withOffset: 3)
        }
        
        if let releaseDate = movieData?.releaseDate{
            if let date = dateParserFormatter.date(from: releaseDate) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "d/M/yyyy"
                let formattedReleaseDate = outputDateFormatter.string(from: date)
                releaseDateLabel.text = formattedReleaseDate
                releaseDateLabel.font = UIFont(name: "Georgia", size: 18)
                releaseDateLabel.textColor = UIColor.white
                imageView.addSubview(releaseDateLabel)
                releaseDateLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 25)
                releaseDateLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            }
        }
        
        if let categories = movieData?.categories{
            var categoriesList = categories.map { $0.localize }
            
            let categoriesToDisplay = categoriesList.joined(separator: ", ")
            categoriesLabel.text = categoriesToDisplay
            categoriesLabel.font = UIFont(name: "Arial", size: 18)
            categoriesLabel.textColor = UIColor.white
            imageView.addSubview(categoriesLabel)
            categoriesLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
            categoriesLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            
            if let duration = movieData?.duration{
                let durationInHourAndMinutes = durationToHourAndMin(durationInMinutes: duration)
                durationLabel.text = "\(durationInHourAndMinutes.hours)h \(durationInHourAndMinutes.minutes)m"
                durationLabel.font = UIFont(name: "Arial-BoldMT", size: 18)
                durationLabel.textColor = UIColor.white
                imageView.addSubview(durationLabel)
                durationLabel.autoAlignAxis(.horizontal, toSameAxisOf: categoriesLabel)
                durationLabel.autoPinEdge(.leading, to: .trailing, of: categoriesLabel, withOffset: 5)
               
            }
        }
        
        imageView.addSubview(likeButton)
        likeButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        likeButton.autoPinEdge(toSuperviewEdge: .leading,withInset: 10)
        
        overiewLabel.text = "Overiew:"
        overiewLabel.textAlignment = .left
        overiewLabel.font = UIFont(name: "Futura-Bold", size: 18)
        overiewLabel.textColor = UIColor(red: 43/255.0, green: 9/255.0, blue: 86/255.0, alpha: 1)
        view.addSubview(overiewLabel)
        overiewLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 10)
        overiewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = movieData?.summary
        descriptionLabel.font = UIFont(name: "Helvetica", size: 15)
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: overiewLabel, withOffset: 5)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
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
                
                for i in 0..<numberOfCrewMembersPerRow {
                    if count < crewMembers.count {
                        let member = crewMembers[count]
                        
                        let roleLabel = UILabel()
                        roleLabel.text = member.role
                        roleLabel.font = UIFont(name: "Helvetica", size: 12)
                        roleLabel.textAlignment = .left
                        
                        let nameLabel = UILabel()
                        nameLabel.text = member.name
                        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 13)
                        nameLabel.textAlignment = .center
                        
                        let memberStackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
                        memberStackView.axis = .vertical
                        memberStackView.alignment = .leading
                        memberStackView.distribution = .fillEqually
                        
                        stackView.addArrangedSubview(memberStackView)
                        
                        count += 1
                    }
                }

                view.addSubview(stackView)
                if count == numberOfCrewMembersPerRow{//if it is the first stackView
                    stackView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 20)
                }else{
                    stackView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: CGFloat(45 * count / 3))
                }
                
                stackView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
                stackView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
            }
        }
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

extension MovieDetailsViewController {
    
    func constructHierarchy() {
        
    }
    
    func styleViews() {
        
    }
    
    func defineLayout() {
        
    }
    
}

extension MovieCategoryModel {
    
    var localize: String {
        switch self {
        case .action:
            "Action"
        case .adventure:
            "Adventure"
        case .comedy:
            "Comedy"
        case .crime:
             "Crime"
        case .drama:
             "Drama"
        case .fantasy:
             "Fantasy"
        case .romance:
             "Romance"
        case .scienceFiction:
             "Science Fiction"
        case .thriller:
             "Thriller"
        case .western:
             "Western"
        }
    }
    
}
