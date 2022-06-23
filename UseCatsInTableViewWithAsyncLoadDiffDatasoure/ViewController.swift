//
//  ViewController.swift
//  UseCatsInTableViewWithAsyncLoadDiffDatasoure
//
//  Created by Steven Hertz on 6/17/22.
//

import UIKit

struct APIResponse: Codable {
  let results: [Post]
}

class ViewController: UIViewController {
    
    
    //  MARK: -  Used for  DiffDataSource
    
    var dataSource: UITableViewDiffableDataSource<Section,Post>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section,Post>! = nil
    
    //  MARK: -  Misc Objects
    var apiResponse = APIResponse(results: [])
        
    //  MARK: -  UI Objects
    
    let tableView = UITableView()
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.text = """
      hello,
      goodbye,
      seeyou
      later
    """
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewSetup()
        tableViewSetup()
        tableView.dataSource = self
        setupView()
        getTheData()
    }
}

extension ViewController {
    
    fileprivate func textViewSetup() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    fileprivate func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.backgroundColor = .darkGray
    }

}

extension ViewController {
    fileprivate func getTheData() {
        
        print("--- in \(#function) at line \(#line)")
    
        let accessKey = "bbc33cc9f86e189e1387e31a57dbd74a2dba4a5f4540f7a0dbcb599fd72f61f2"
        
        guard let theURL = URL(string: "https://api.unsplash.com/search/photos?query=kittens") else {
            fatalError("error converting url")
        }
        
        // initialize the urlRequest
        var req = URLRequest(url: theURL)
        req.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

        // initialize urlSession
        let task = URLSession.shared.dataTask(with: req) {  [weak self] data, response, error in
            
            if error != nil {
                print("there was an error")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(response)
              return
            }

            guard let data = data else {
                fatalError("data not retreived")
            }
            
            //  - - - Things worked we got the data
             //do the decoding from here
            print(" in \(#function) at line \(#line)")
            print(data)
            do {
                let decodedJson = try JSONDecoder().decode(APIResponse.self, from: data)
                decodedJson.results.forEach { item in
                    print(item.urls.regular)
                }
                self?.apiResponse = decodedJson
                print(" in \(#function) at line \(#line)")
                self?.apiResponse.results.forEach { item in
                    print(item.urls.regular)
                }
                DispatchQueue.main.async {
//                    self?.collectionView.reloadData()
                }

            } catch let error {
                print("error decoding the response \(error)")
            }
            
        }
        task.resume()
        
    }

 
}

extension ViewController {
    
    private func setupView() {
        
            // 1. create a button
        let button1 = UIButton(configuration: UIButton.Configuration.filled(),
                               primaryAction: UIAction(title: "Hello From One") { action in
            print(action.title)
//            self.changeItemsandupdateUI()
        }
        )
        
            // 3. create a second buttton
        let button2 = UIButton(configuration: UIButton.Configuration.filled(),
                               primaryAction: UIAction(title: "Hello From The second one") { action in
            print(action.title)
        }
        )
        
        let button3 = UIButton(configuration: UIButton.Configuration.filled(),
                               primaryAction: UIAction(title: "Hello From The third one") { action in
            print(action.title)
        }
        )
        let button4 = UIButton(configuration: UIButton.Configuration.filled(),
                               primaryAction: UIAction(title: "Hello From The fourth one") { action in
            print(action.title)
        }
        )

            // 4. pass it to the stackView
        setupStackView(button1, button2, button3, button4)
        
    }
    
        // stackView gets created and get cofigured into the view
    fileprivate func setupStackView(_ views: UIView...) {
            // Instantiate the StackView
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 16
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            return stackView
        }()
        
        views.forEach { btn in
            stackView.addArrangedSubview(btn)
        }
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apiResponse.results.count
    }
    
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.font = .systemFont(ofSize: 12.0)
        content.text = apiResponse.results[indexPath.row].urls.regular
        content.image = UIImage(systemName: "rectangle")
        
        cell.contentConfiguration = content
        return cell
        
    }
}

/**
 var content = cell.defaultContentConfiguration()

 // Configure content.
 content.image = UIImage(systemName: "star")
 content.text = "Favorites"

 // Customize appearance.
 content.imageProperties.tintColor = .purple

 cell.contentConfiguration = content
 */
