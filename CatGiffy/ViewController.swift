//
//  ViewController.swift
//  CatGiffy
//
//  Created by codebendr on 22/06/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var images = [Image]()
        var refreshControl:UIRefreshControl!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        refreshControl.addTarget(self, action: #selector(fetchImagesFromUrl), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()

        fetchImagesFromUrl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination

        if let detailViewController = destination as? DetailViewController {
            detailViewController.gif = sender as? Image
        }
    }
    
    @objc fileprivate func fetchImagesFromUrl() {
        NetworkUtils.get(from: NetworkUtils.imagesUrl) { data in
            guard let data = data else {
                let alert = UI.showError {
                    self.fetchImagesFromUrl()
                }
                self.present(alert, animated: true)
                return
            }
            do {
                let decoder = JSONDecoder()
                self.images = try decoder.decode([Image].self, from: data)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
                
            } catch {
                let alert = UI.showError {
                    self.fetchImagesFromUrl()
                }
                self.present(alert, animated: true)
            }
            
        }
    }
  
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          performSegue(withIdentifier: "ImageDetailSegue", sender: images[indexPath.row])
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        
        cell.gif = images[indexPath.row]
        
        return cell
        
    }
}


