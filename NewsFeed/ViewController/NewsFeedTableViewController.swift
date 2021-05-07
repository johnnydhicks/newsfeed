//
//  NewsFeedTableViewController.swift
//  NewsFeed
//
//  Created by Johnny Hicks on 4/9/21.
//

import UIKit
import SafariServices

class NewsFeedTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let newsFeedController = NewsFeedController()
    let cellIdentifier = "NewsFeedCell"
    
    private var filterMenu: UIMenu {
        let shouldFilter = UserDefaults.standard.bool(forKey: .shouldFilterArticles)
        let showAllAction = UIAction(title: NSLocalizedString("Show All", comment: "Menu item to show all articles"), image: UIImage(systemName: "rectangle.grid.1x2"), handler: { [weak self] (_) in
            UserDefaults.standard.set(false, forKey: .shouldFilterArticles)
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateViews()
        })
        showAllAction.state = shouldFilter ? .off : .on
        
        let showFavoritesAction =  UIAction(title: NSLocalizedString("Show Favorites", comment: "Menu item to show all articles"), image: UIImage(systemName: "heart"), handler: { [weak self] (_) in
            UserDefaults.standard.set(true, forKey: .shouldFilterArticles)
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateViews()
        })
        showFavoritesAction.state = shouldFilter ? .on : .off
        return UIMenu(title: "", children: [showAllAction, showFavoritesAction])
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupViews()
    }
    
    // MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeedController.filteredArticles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsFeedTableViewCell else {
            fatalError("Unable to dequeue cell with identifier: \(self.cellIdentifier)")
        }
        let article = newsFeedController.filteredArticles[indexPath.row]
        cell.article = article
        newsFeedController.fetchImageForArticle(article: article) {
            DispatchQueue.main.async {
                cell.updateViews(with: article)
            }
        }
        return cell
    }
    
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let article = newsFeedController.filteredArticles[indexPath.row]
        let vc = SFSafariViewController(url: article.link)
        self.present(vc, animated: true)
    }
    
    // MARK: - Tableview Row Swipe Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = favoriteSwipeAction(for: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction =  UIContextualAction(style: .normal, title:"", handler: { [weak self] (_, _, _) in
            guard let self = self else { return }
            let article = self.newsFeedController.filteredArticles[indexPath.row]
            self.share(article: article)
        })
        
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        return configuration
    }
    
    private func favoriteSwipeAction(for indexPath: IndexPath) -> UIContextualAction {
        let favoriteAction = UIContextualAction(style: .normal, title: "", handler: { [weak self] (action, _, _) in
            guard let self = self else { return }
            let article = self.newsFeedController.filteredArticles[indexPath.row]
            self.favorite(article: article, indexPath: indexPath)
        })
        favoriteAction.image = UIImage(systemName: "heart.fill")
        favoriteAction.backgroundColor = .systemRed
        return favoriteAction
    }
    
    // MARK: - TableView Context Menu Configuration
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil) { [weak self] () -> UIViewController? in
            guard let self = self else { return nil }
            let article = self.newsFeedController.filteredArticles[indexPath.row]
            let vc = SFSafariViewController(url: article.link)
            return vc
        } actionProvider: { [weak self] (_) -> UIMenu? in
            guard let self = self else { return nil }
            let article = self.newsFeedController.filteredArticles[indexPath.row]
            let favoriteAction = UIAction(title: article.favorite ? NSLocalizedString("Un-Favorite", comment: "Un-Favorite action title") : NSLocalizedString("Favorite", comment: "Favorite action title"), image: article.favorite ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")) { (_) in
                let article = self.newsFeedController.filteredArticles[indexPath.row]
                self.favorite(article: article, indexPath: indexPath)
            }
            let shareAction = UIAction(title: NSLocalizedString("Share", comment: "Share action title"), image: UIImage(systemName: "square.and.arrow.up")) { (_) in
                let article = self.newsFeedController.filteredArticles[indexPath.row]
                self.share(article: article)
            }
            return UIMenu(title: "", children: [favoriteAction, shareAction])
        }
        return configuration
    }
    
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            if let vc = animator.previewViewController {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private Methods
    private func registerCells() {
        tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupViews() {
        self.title = NSLocalizedString("News Feed", comment: "Title for navigation bar")
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemRed]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.tableView.tableFooterView = UIView()
        updateViews()
    }
    
    private func updateViews() {
        let filterButton = UIBarButtonItem(title: "", image: UIImage(systemName: "line.horizontal.3.decrease.circle"), primaryAction: nil, menu: filterMenu)
        filterButton.tintColor = .systemRed
        navigationItem.setRightBarButton(filterButton, animated: true)
    }
    
    private func share(article: Article) {
        let items = [article.link]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true) {
            self.tableView.isEditing = false
        }
    }
    
    private func favorite(article: Article, indexPath: IndexPath) {
        article.favorite.toggle()
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsFeedTableViewCell else { return }
        cell.updateViews(with: article)
        self.tableView.isEditing = false
    }
}

