import Foundation

class NetworkManager {
    
    func fetchData(completion: @escaping (Response?) -> Void) {
        let urlString = "https://reqres.in/api/users"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Network error:", error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                print("No response or data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("Server error:", response.statusCode)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Response.self, from: data)
                print("success")
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print("Error parsing JSON:", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
        }.resume()
    }
}
