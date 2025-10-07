# 📚 SimpleLibrary

**SimpleLibrary** is an educational project focused on learning how to integrate a **Spring Boot** API with a **SwiftUI** mobile app, using **Supabase** as the database.  
The goal is to combine backend and mobile development in one place to better understand how the pieces work together.

---

## 🛠️ Technologies Used

- **Backend:** [Spring Boot](https://spring.io/projects/spring-boot) (Java 21, Gradle)  
- **Database:** [Supabase](https://supabase.com/)  
- **Frontend:** [SwiftUI](https://developer.apple.com/xcode/swiftui/) (iOS)  

---

## ⚙️ Backend Setup (Spring Boot)

### 1. Prerequisites
- Java 21
- Gradle
- A configured Supabase database

### 2. Clone the repository

```bash
git clone https://github.com/Masr3/SimpleLibrary.git
cd SimpleLibrary/backend
```

3. Build the project

   
```bash
./gradlew build
```

4. Run the server

```bash

./gradlew bootRun
```

By default, the API will be available at:

```bash

http://localhost:8080

```


⸻

📱 Frontend Setup (SwiftUI)

1. Open the project in Xcode

```bash

cd ../frontend
```

open SimpleLibrary.xcodeproj



2. Update the base URL if needed

In BookService.swift, make sure the URL points to your backend:

```swift

private let url = "http://localhost:8080"
```

If you’re running on a physical device, use your computer’s local IP address instead of localhost.

3. Run the app

Select a simulator or a physical device and press Run ▶ in Xcode.



🧠 Learning Goals

This project was created for educational purposes, with the following goals:
	•	Learn how to build and expose REST endpoints using Spring Boot.
	•	Practice consuming APIs in SwiftUI using async/await.
	•	Integrate Supabase as a backend-as-a-service solution.
	•	Understand how to structure a project that combines backend and mobile frontend.



🧑‍💻 Author

Manuel Santana
Personal learning project 🌱


📝 License

This project is licensed under the MIT License.
You are free to use it for educational purposes.
