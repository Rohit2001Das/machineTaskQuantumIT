//
//  ChartViewController.swift
//  MachineTest_QuantumIT
//
//  Created by ROHIT DAS on 03/05/24.
//
import UIKit

class ChartViewController: UIViewController {
    
    let apiUrlString = "https://securityoncalls.com/projects/brad/api/banners"
    
    // UI Components
    var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Before"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "After"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 300, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    var images: [String] = [] // Array to store image URLs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        view.backgroundColor = .white
        
        // Load and display the header image
        setupHeaderImageView()
        fetchHeaderImage()
        
        // Add left and right image views with labels
        setupLeftImageView()
        setupRightImageView()
        
        // Add custom navigation bar
        setupNavigationBar()
        
        // Add collection view
        setupCollectionView()
        
        // Add tap gesture recognizers to image views
        setupTapGestureRecognizers()
        
        // Add buttons
        setupButtons()
        
        // Fetch images for the collection view
        fetchImages()
    }
    
    func setupNavigationBar() {
        // Create custom navigation bar
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        
        // Create left system image button
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(hamBurgerButtonTapped))
        
        // Create right system image buttons
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        let shazamLogoButton = UIBarButtonItem(image: UIImage(systemName: "shazam.logo"), style: .plain, target: self, action: #selector(shazamLogoButtonTapped))
        
        // Set navigation items
        let navigationItem = UINavigationItem(title: "")
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItems = [bellButton, shazamLogoButton]
        
        navigationBar.setItems([navigationItem], animated: false)
        
        // Add navigation bar to view
        view.addSubview(navigationBar)
        
        // Add constraints for navigation bar
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupHeaderImageView() {
        // Add header image view
        view.addSubview(headerImageView)
        
        // Configure constraints for header image view
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44), // Adjust y position below the navigation bar
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 200) // Adjust height as needed
        ])
    }
    
    func fetchHeaderImage() {
        guard let url = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching banner images: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let banners = try JSONDecoder().decode([BannerImage].self, from: data)
                if let banner = banners.first {
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        if let imageUrl = URL(string: banner.image) {
                            self.loadImage(from: imageUrl)
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.headerImageView.image = image
                }
            }
        }.resume()
    }
    
    func setupLeftImageView() {
        // Add left image view and label
        view.addSubview(leftImageView)
        view.addSubview(leftLabel)
        
        // Configure constraints for left image view and label
        NSLayoutConstraint.activate([
            leftImageView.centerXAnchor.constraint(equalTo: headerImageView.leadingAnchor, constant: 50),
            leftImageView.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -90),
            leftImageView.widthAnchor.constraint(equalToConstant: 100),
            leftImageView.heightAnchor.constraint(equalToConstant: 100),
            
            leftLabel.topAnchor.constraint(equalTo: leftImageView.bottomAnchor, constant: 8),
            leftLabel.centerXAnchor.constraint(equalTo: leftImageView.centerXAnchor)
        ])
        
        // Set image and content mode for left image view
        leftImageView.image = UIImage(named: "jane_profile")
    }
    
    func setupRightImageView() {
        // Add right image view and label
        view.addSubview(rightImageView)
        view.addSubview(rightLabel)
        
        // Configure constraints for right image view and label
        NSLayoutConstraint.activate([
            rightImageView.centerXAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: -50),
            rightImageView.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -90),
            rightImageView.widthAnchor.constraint(equalToConstant: 100),
            rightImageView.heightAnchor.constraint(equalToConstant: 100),
            
            rightLabel.topAnchor.constraint(equalTo: rightImageView.bottomAnchor, constant: 8),
            rightLabel.centerXAnchor.constraint(equalTo: rightImageView.centerXAnchor)
        ])
        
        rightImageView.image = UIImage(named: "john_profile")
    }
    
    func setupButtons() {
        // Create and add buttons
        let bodyStatsButton = createButton(title: "Body Stats")
        let chartsButton = createButton(title: "Charts")
        let referralsButton = createButton(title: "Referrals")
        
        // Create six additional buttons
        let mealPlanButton = createCircularButton(imageName: "doc.plaintext", title: "")
        mealPlanButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let workoutButton = createCircularButton(imageName: "dumbbell.fill", title: "")
        workoutButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let weeklyCheckinButton = createCircularButton(imageName: "calendar.circle", title: "")
        weeklyCheckinButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let monthlyCheckinButton = createCircularButton(imageName: "calendar", title: "")
        monthlyCheckinButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let galleryButton = createCircularButton(imageName: "photo.artframe.circle", title: "")
        galleryButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let videoButton = createCircularButton(imageName: "video", title: "")
        videoButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        
        let mealPlanLabel: UILabel = {
            let label = UILabel()
            label.text = "Meal Plan"
            label.numberOfLines = 0

            return label
        }()
        
        let workoutPlanLabel: UILabel = {
            let label = UILabel()
            label.text = "Workout"

            return label
        }()
        
        let weeklyCheckinLabel: UILabel = {
            let label = UILabel()
            label.text = "Weekly Checkin"
            label.numberOfLines = 0

            return label
        }()
        
        let monthlyCheckinLabel: UILabel = {
            let label = UILabel()
            label.text = "Monthly Checkin"
            label.numberOfLines = 0

            return label
        }()
        
        let galleryLabel: UILabel = {
            let label = UILabel()
            label.text = " Gallery"
            label.numberOfLines = 0

            return label
        }()
        
        let videosLabel: UILabel = {
            let label = UILabel()
            label.text = " Videos"
            label.numberOfLines = 0

            return label
        }()
       
        
        // Create vertical stack view for left-side buttons
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.spacing = 20
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add left-side buttons to the stack view
        leftStackView.addArrangedSubview(bodyStatsButton)
        leftStackView.addArrangedSubview(chartsButton)
        leftStackView.addArrangedSubview(referralsButton)
        

        
        let button1StackView = UIStackView()
        button1StackView.axis = .vertical
        button1StackView.spacing = 2
        button1StackView.translatesAutoresizingMaskIntoConstraints = false
        button1StackView.addArrangedSubview(mealPlanButton)
        button1StackView.addArrangedSubview(mealPlanLabel)
        
        let button2StackView = UIStackView()
        button2StackView.axis = .vertical
        button2StackView.spacing = 2
        button2StackView.translatesAutoresizingMaskIntoConstraints = false
        button2StackView.addArrangedSubview(workoutButton)
        button2StackView.addArrangedSubview(workoutPlanLabel)
        
        // Create horizontal stack view for right-side buttons
        let rightStackView1 = UIStackView()
        rightStackView1.axis = .horizontal
        rightStackView1.spacing = 30
        rightStackView1.translatesAutoresizingMaskIntoConstraints = false
        
        // Add right-side buttons to the stack view
        rightStackView1.addArrangedSubview(button1StackView)
        rightStackView1.addArrangedSubview(button2StackView)
       
        
        
        let button3StackView = UIStackView()
        button3StackView.axis = .vertical
        button3StackView.spacing = 2
        button3StackView.translatesAutoresizingMaskIntoConstraints = false
        button3StackView.addArrangedSubview(weeklyCheckinButton)
        button3StackView.addArrangedSubview(weeklyCheckinLabel)
        
        
        let button4StackView = UIStackView()
        button4StackView.axis = .vertical
        button4StackView.spacing = 2
        button4StackView.translatesAutoresizingMaskIntoConstraints = false
        button4StackView.addArrangedSubview(monthlyCheckinButton)
        button4StackView.addArrangedSubview(monthlyCheckinLabel)
    
        
        let rightStackView2 = UIStackView()
        rightStackView2.axis = .horizontal
        rightStackView2.spacing = 30
        rightStackView2.translatesAutoresizingMaskIntoConstraints = false
        
        // Add right-side buttons to the stack view
        rightStackView2.addArrangedSubview(button3StackView)
        rightStackView2.addArrangedSubview(button4StackView)
        
        let button5StackView = UIStackView()
        button5StackView.axis = .vertical
        button5StackView.spacing = 2
        button5StackView.translatesAutoresizingMaskIntoConstraints = false
        button5StackView.addArrangedSubview(galleryButton)
        button5StackView.addArrangedSubview(galleryLabel)
        
        
        let button6StackView = UIStackView()
        button6StackView.axis = .vertical
        button6StackView.spacing = 2
        button6StackView.translatesAutoresizingMaskIntoConstraints = false
        button6StackView.addArrangedSubview(videoButton)
        button6StackView.addArrangedSubview(videosLabel)
        
    
        
        let rightStackView3 = UIStackView()
        rightStackView3.axis = .horizontal
        rightStackView3.spacing = 30
        rightStackView3.translatesAutoresizingMaskIntoConstraints = false
        
    
        rightStackView3.addArrangedSubview(button5StackView)
        rightStackView3.addArrangedSubview(button6StackView)
       
        
        
        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.spacing = 10
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.addArrangedSubview(rightStackView1)
        rightStackView.addArrangedSubview(rightStackView2)
        rightStackView.addArrangedSubview(rightStackView3)
        
        // Add stack views to the view
        view.addSubview(leftStackView)
        view.addSubview(rightStackView)
        
        // Configure constraints for stack views
        NSLayoutConstraint.activate([
            // Left stack view constraints
            leftStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            leftStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            
            // Right stack view constraints
            rightStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            rightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: 40),
            rightStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -70),
            
            // Equal width for right-side buttons
            mealPlanButton.widthAnchor.constraint(equalTo: workoutButton.widthAnchor),
            workoutButton.widthAnchor.constraint(equalTo: weeklyCheckinButton.widthAnchor),
            weeklyCheckinButton.widthAnchor.constraint(equalTo: monthlyCheckinButton.widthAnchor),
            monthlyCheckinButton.widthAnchor.constraint(equalTo: galleryButton.widthAnchor),
            galleryButton.widthAnchor.constraint(equalTo: videoButton.widthAnchor),
            
            
            // Set width for left-side buttons
            bodyStatsButton.widthAnchor.constraint(equalToConstant: 150),
            chartsButton.widthAnchor.constraint(equalToConstant: 150),
            referralsButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    
    func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0 // Add border width
        button.layer.borderColor = UIColor.green.cgColor // Set border color to green
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding to the button title
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    
    func createCircularButton(imageName: String, title: String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1.0
        button.setTitleColor(.black, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
    
        
        // Adjust image and title position
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
      
        
        // Add constraints for circular button
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.clipsToBounds = true
        
        return button
    }
    
    
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            print("\(title) Button tapped")
        }
    }
    
    func setupTapGestureRecognizers() {
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(leftImageViewTapped))
        leftImageView.isUserInteractionEnabled = true
        leftImageView.addGestureRecognizer(leftTapGesture)
        
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(rightImageViewTapped))
        rightImageView.isUserInteractionEnabled = true
        rightImageView.addGestureRecognizer(rightTapGesture)
    }
    
    func setupCollectionView() {
        // Add collection view
        view.addSubview(collectionView)
        
        // Configure constraints for collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func fetchImages() {
        guard let url = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching images: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let imageModels = try JSONDecoder().decode([BannerImage].self, from: data)
                self.images = imageModels.map { $0.image }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    @objc func leftImageViewTapped() {
        showImageDetail(image: leftImageView.image)
    }
    
    @objc func rightImageViewTapped() {
        showImageDetail(image: rightImageView.image)
    }
    
    func showImageDetail(image: UIImage?) {
        guard let image = image else { return }
        
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.image = image
        present(imageDetailVC, animated: true, completion: nil)
    }
    
    @objc func bellButtonTapped() {
        print("Bell Button tapped")
    }
    
    @objc func shazamLogoButtonTapped() {
        print("Shazam Logo Button tapped")
    }
    
    @objc func hamBurgerButtonTapped() {
        print("Hamburger Button tapped")
    }
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageUrl = images[indexPath.item]
        cell.configure(with: imageUrl)
        return cell
    }
}

