# Main

## Project Overview
This project is a Roblox game built using Luau scripting. It is structured to separate client, server, and shared code for better organization and maintainability.

## Project Structure
The project follows this structure:
```
.gitignore
aftman.toml
default.project.json
README.md
src/
	client/
		init.client.luau
	server/
		init.server.luau
	shared/
		Hello.luau
```

- **`src/client`**: Contains scripts that run on the client side.
- **`src/server`**: Contains scripts that run on the server side.
- **`src/shared`**: Contains code shared between the client and server.

## Coding Style Guide
To maintain consistency and readability, follow these guidelines:
1. **Use Descriptive Names**: Name variables, functions, and files clearly to describe their purpose.
2. **Indentation**: Use 4 spaces for indentation.
3. **Comments**: Add comments to explain complex logic or important sections of the code.
4. **Avoid Global Variables**: Use local variables to prevent conflicts.
5. **Organize Code**: Group related functions and logic together.

### Example
```luau
-- Good Example
local function greet(name)
	print("Hello, " .. name .. "!")
end

greet("Player")
```

## How to Use GitHub
GitHub is used for version control and collaboration. Here’s how to get started:

### 1. Clone the Repository
To clone the repository to your local machine:
```sh
git clone https://github.com/Monsoon-Arts/Main
```

### 2. Make Changes
Edit files in your local repository. Use meaningful commit messages to describe your changes:
```sh
git add .
git commit -m "Add new feature"
```

### 3. Push Changes
Push your changes to the remote repository:
```sh
git push origin main
```

### 4. Create Pull Requests
If you’re working in a team, create a pull request to propose changes. This allows others to review your code before merging.

### 5. Resolve Conflicts
If there are conflicts, resolve them by editing the conflicting files and committing the changes.

## How to Run the Project
1. Install [Rojo](https://github.com/rojo-rbx/rojo) using Aftman:
   ```sh
   aftman install
   ```
2. Start Rojo to sync your project with Roblox Studio:
   ```sh
   rojo serve default.project.json
   ```
3. Open Roblox Studio and connect to Rojo.

## Contributing
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## License
This project is licensed under the MIT License. See `LICENSE` for details.