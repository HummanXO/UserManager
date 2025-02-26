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
    
    func createUser(first_name: String, email: String, completion: @escaping (User?) -> Void) {
        
        let urlString = "https://reqres.in/api/users"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "first_name": first_name,
            "email": email
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(nil)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            print(String(data: data, encoding: .utf8) ?? "No response data")
            do {
                let newUser = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async { completion(newUser) }
            } catch {
                print("error parsing JSON: \(error)")
            }
        }.resume()
    }
    
    func deleteUser(user: User, completion: @escaping (Bool) -> Void) {
        let urlString = "https://reqres.in/api/users/\(user.id)"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error deleting user: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                print( "User deleted successfully")
                completion(true)
            } else {
                print( "Failed to delete user")
                completion(false)
            }
        }.resume()
    }
}
