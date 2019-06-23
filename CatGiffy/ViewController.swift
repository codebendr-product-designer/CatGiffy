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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkUtils.get(from: NetworkUtils.textUrl) { data in
            guard let data = data else {
                print("error data")
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            
        }
        
        NetworkUtils.get(from: NetworkUtils.imagesUrl) { data in
            guard let data = data else {
                print("error data")
                return
            }
            do {
                let decoder = JSONDecoder()
                self.images = try decoder.decode([Image].self, from: data)
                DispatchQueue.main.async {
                    // self.activityIndicator.stopAnimating()
                    // self.errorView.isHidden = true
                   // self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
                
            } catch {
                print("error json \(error)")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let destination = segue.destination
//
//        if let contactDetailViewController = destination as? ContactDetailCollectionView {
//            contactDetailViewController.employee = sender as? Employee
//        }
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


