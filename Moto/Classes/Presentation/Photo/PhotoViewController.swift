//
//  PhotoViewController.swift
//  Moto
//
//  Created by Андрей Чернышев on 25.06.2022.
//

import UIKit
import Kingfisher

final class PhotoViewController: UIViewController {
    private var imageURL: URL?
    var currentIndex: Int!
    
    var imageScrollView: ImageScrollView!
    
    private var image: UIImage?
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        view.backgroundColor = .black
        
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageScrollView.set(image: image)
                    }
                }
            }
        }
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

// MARK: Make
extension PhotoViewController {
    static func make(imageURL: URL) -> PhotoViewController {
        let controller = PhotoViewController()
        controller.imageURL = imageURL
        return controller
    }
}
