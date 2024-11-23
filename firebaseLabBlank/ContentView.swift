import SwiftUI

// MARK: - Model
struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    let isAdult: Bool
    let age: Int
}

// MARK: - View Models
class UserManager: ObservableObject {
    
    
    @Published var users: [User] = sampleUsers
    //Sample Data we need to change later
    
    static let sampleUsers = [
        User(id: "1", username: "john_doe", email: "john@example.com", isAdult: true, age: 25),
        User(id: "2", username: "jane_smith", email: "jane@example.com", isAdult: true, age: 30)
    ]
    
    // MARK: - Lab Exercise 1
    // TODO: Implement the fetch users function
    // This function should update the users array with fetched data
    func fetchUsers() {
        // Student exercise: Implement fetching logic
        // For now, we'll use sample data to prevent crashes
        users = Self.sampleUsers
    }
    
    // MARK: - Lab Exercise 2
    // TODO: Implement the add user function
    // This function should add a new user to the users array
    func addUser(username: String, email: String, age: Int) {
        // Student exercise: Implement add user logic
        // Basic implementation to prevent crashes
        let newUser = User(
            id: UUID().uuidString,
            username: username,
            email: email,
            isAdult: age >= 18,
            age: age
        )
        users.append(newUser)
    }
    
    // MARK: - Lab Exercise 3
    // TODO: Implement the remove user function
    // This function should remove a user from the users array
    func removeUser(id: String) {
        // Student exercise: Implement remove user logic
        // Basic implementation to prevent crashes
        users.removeAll { $0.id == id }
    }
}

// MARK: - Views
struct ContentView: View {
    @StateObject private var userManager = UserManager()
    @State private var showAddUserSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userManager.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.username).font(.headline)
                        Text(user.email).font(.subheadline)
                        Text("Age: \(user.age) (\(user.isAdult ? "Adult" : "Minor"))")
                            .font(.subheadline)
                            .foregroundColor(user.isAdult ? .green : .red)
                    }
                    .contextMenu {
                        Button("Remove") {
                            userManager.removeUser(id: user.id)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                Button(action: { showAddUserSheet.toggle() }) {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                userManager.fetchUsers()
            }
            .sheet(isPresented: $showAddUserSheet) {
                AddUserView(userManager: userManager)
            }
        }
    }
}

struct AddUserView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userManager: UserManager
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Details")) {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add User")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let userAge = Int(age), !username.isEmpty, !email.isEmpty {
                            userManager.addUser(username: username, email: email, age: userAge)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
