//
//  ViewController.swift
//  MovieApp
//
//  Created by Ante on 29.03.2024..
//
import MovieAppData
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let details = MovieUseCase().getDetails(id: 111161)
        print(details)
    }


}

