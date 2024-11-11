//
//  EpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 7/11/24.
//
//  This view displays detailed information about a selected episode in the Rick and Morty app.
//  It is responsible for showing a collection view with episode information and related characters.
//  The view starts with a loading spinner, which is hidden once data is loaded into the collection view.

import UIKit

protocol EpisodeDetailViewDelegate: AnyObject {
    /// Notifies the delegate when a character cell is selected in the detail view.
    /// - Parameters:
    ///   - detailView: The `EpisodeDetailView` where the selection occurred.
    ///   - character: The selected character.
    func rmEpisodeDetailView(_ detailView: EpisodeDetailView, didSelectCharacter character: RMCharacter)
}

/// `EpisodeDetailView` is a `UIView` subclass designed to display detailed information about a specific episode
/// in the Rick and Morty app. The view contains a collection view with two sections:
/// one for general information and another for related characters. When data is loaded, the view hides
/// the loading spinner and smoothly reveals the content.
final class EpisodeDetailView: UIView {
    
    // MARK: - Properties
    
    public weak var delegate: EpisodeDetailViewDelegate?
    
    /// The view model providing episode data for the view.
    /// When the view model is set, it stops the loading spinner and reloads the collection view with the new data.
    private var viewModel: EpisodeDetailViewVM? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    /// The collection view that displays the episode information and character list.
    private var collectionView: UICollectionView?
    
    /// A loading spinner shown while the data is being fetched.
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    /// Initializes the view with a specified frame.
    /// Sets up the collection view and the loading spinner, starting the spinner on initialization.
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
        
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Layout Setup
    
    /// Adds layout constraints for `collectionView` and `spinner`.
    /// Positions the spinner in the center and expands the collection view to cover the entire view.
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    /// Creates the collection view that will be used to display episode details and character information.
    /// Sets up the layout, hides the view initially, and registers the default cell type.
    /// - Returns: A configured `UICollectionView` instance.
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: EpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    // MARK: - Public
    
    /// Configures the view with a specific `EpisodeDetailViewVM` view model.
    /// Assigns the view model, which triggers data reloads and the collection view display.
    /// - Parameter viewModel: The view model containing episode details and characters.
    public func configure(with viewModel: EpisodeDetailViewVM) {
        self.viewModel = viewModel
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

/// Extension to conform to `UICollectionViewDelegate` and `UICollectionViewDataSource`,
/// which manages the data and interactions in the collection view.
extension EpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// Determines the number of sections in the collection view.
    /// - Parameter collectionView: The collection view requesting this information.
    /// - Returns: The number of sections, based on `cellViewModels` in the view model.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    /// Determines the number of items in a given section of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else { return 0 }
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    /// Configures and returns the cell for a specific item in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell.
    ///   - indexPath: The index path specifying the item’s location.
    /// - Returns: A configured `UICollectionViewCell` instance.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sections = viewModel?.cellViewModels else { fatalError("No viewModel") }
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? EpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
            
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? CharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    /// Handles cell selection, deselecting the item after it is tapped.
    /// - Parameters:
    ///   - collectionView: The collection view where the cell was selected.
    ///   - indexPath: The index path of the selected item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else {
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelectCharacter: character)
        }
    }
}

// MARK: - Layout

/// Extension to define the layout for the collection view sections.
extension EpisodeDetailView {
    
    /// Creates and returns a compositional layout section for the specified index.
    /// Configures each item to take the full width of the group with a fixed height.
    /// - Parameter section: The index of the section to layout.
    /// - Returns: An `NSCollectionLayoutSection` object defining the layout for the section.
    func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    /// Creates the layout for the information section.
    /// Each item in this section occupies the full width of the collection view,
    /// with a fixed height of 80 points, displaying information like the episode title or air date.
    /// - Returns: An `NSCollectionLayoutSection` configured for information display.
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(80)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    /// Creates the layout for the characters section.
    /// Each item is set to take up half the width of the collection view, forming a grid layout.
    /// The group is set to 260 points in height, allowing the display of two character cells side by side.
    /// - Returns: An `NSCollectionLayoutSection` configured for displaying character cells.
    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(260)
            ),
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
