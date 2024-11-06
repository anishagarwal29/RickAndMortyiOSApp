//
//  CharacterListViewVM.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 3/11/24.
//

import UIKit

protocol CharacterListViewVMDelegate: AnyObject {
    /// Notifies the delegate that the initial set of characters has loaded.
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    
    /// Notifies the delegate that a character has been selected.
    /// - Parameter character: The character that was selected.
    func didSelectCharacter(_ character: RMCharacter)
}

/// View Model to handle character list view logic
final class CharacterListViewVM: NSObject {
    
    // MARK: - Properties
    
    /// The delegate to receive events from the view model.
    public weak var delegate: CharacterListViewVMDelegate?
    
    /// Indicates whether more characters are being loaded.
    private var isLoadingMoreCharacters = false
    
    /// Holds the list of characters. Updates `cellViewModels` when set.
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellVM(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    /// Holds the cell view models for each character.
    private var cellViewModels: [CharacterCollectionViewCellVM] = []
    
    /// Stores API pagination information, such as the URL for the next page of results.
    private var apiInfo: GetAllCharactersResponse.Info? = nil
    
    // MARK: - Methods
    
    /// Fetches the initial set of characters (20) and notifies the delegate on success.
    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: GetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Fetches additional characters for pagination when needed, based on the provided URL.
    /// - Parameter url: The URL for fetching additional characters.
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }

        isLoadingMoreCharacters = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        RMService.shared.execute(request, expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                
                let moreResults = responseModel.results
                let info = responseModel.info
                
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(
                        with: indexPathsToAdd
                    )
                    strongSelf.isLoadingMoreCharacters = false
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    
    /// Indicates whether to show a loading indicator for more data based on the API pagination info.
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

/// Extension for `CharacterListViewVM` to conform to `UICollectionViewDataSource`, `UICollectionViewDelegate`, and `UICollectionViewDelegateFlowLayout`.
extension CharacterListViewVM: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// Returns the number of items in the section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The number of the section.
    /// - Returns: The number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    /// Configures and returns a cell for the specified item at the given index path.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the cell.
    ///   - indexPath: The index path of the item.
    /// - Returns: A configured `UICollectionViewCell` for the specified index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    /// Provides a supplementary view for the specified element kind (e.g., footer).
    /// - Parameters:
    ///   - collectionView: The collection view requesting the supplementary view.
    ///   - kind: The kind of supplementary view (footer or header).
    ///   - indexPath: The index path of the supplementary view.
    /// - Returns: A configured `UICollectionReusableView` for the specified kind and index path.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? FooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    /// Sets the size for the footer in the section.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the size for the footer.
    ///   - collectionViewLayout: The layout object for the collection view.
    ///   - section: The section number.
    /// - Returns: A `CGSize` representing the width and height for the footer.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    /// Sets the size for each item in the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting the size for the item.
    ///   - collectionViewLayout: The layout object for the collection view.
    ///   - indexPath: The index path of the item.
    /// - Returns: A `CGSize` representing the width and height for each item.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    /// Handles the selection of an item at a specific index path.
    /// - Parameters:
    ///   - collectionView: The collection view where the selection occurred.
    ///   - indexPath: The index path of the selected item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - ScrollView

/// Extension for `CharacterListViewVM` to handle scroll view events.
extension CharacterListViewVM: UIScrollViewDelegate {
    
    /// Monitors scroll events to determine if more characters should be fetched when the user scrolls near the bottom.
    /// - Parameter scrollView: The scroll view whose content offset is being observed.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
