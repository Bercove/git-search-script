# Git Search 🔍

A powerful bash script for searching repositories and users across GitHub and GitLab simultaneously.

---

## ✨ Features

- **Dual Platform Search**: Search both GitHub and GitLab in one command  
- **Multiple Search Types**: Search repositories, users, or both  
- **Language Filter Support**: Search repositories by programming language using `-l` or `--language`  
- **User Repository Discovery**: Find users and their public repositories  
- **Smart Result Balancing**: Automatically balances results between platforms  
- **API Token Support**: Higher rate limits with personal access tokens  
- **Flexible Output**: Consistent, parseable output format  
- **Rate Limit Respect**: Built-in delays to prevent API throttling  

---

## 🚀 Quick Start

### Prerequisites

```bash
# Install dependencies on Ubuntu/Debian
sudo apt-get install curl jq

# On macOS
brew install curl jq
```

### Basic Usage

```bash
# Make script executable
chmod +x gitsearch.sh

# Basic repository search
./gitsearch.sh "machine learning"

# Search with platform filter
./gitsearch.sh -p github "python web framework"

# Limit results
./gitsearch.sh -n 5 "docker kubernetes"
```

---

## 📖 Usage

### Basic Search Types

```bash
# Search repositories (default)
./gitsearch.sh "your search query"

# Search for users only
./gitsearch.sh -t users "john"

# Search both repositories and users
./gitsearch.sh -t both "react"
```

### Advanced Options

```bash
# Search only GitHub
./gitsearch.sh -p github "react components"

# Search only GitLab
./gitsearch.sh -p gitlab "rust library"

# Get 20 results (10 from each platform)
./gitsearch.sh -n 20 "api platform"

# User search on GitHub only
./gitsearch.sh -t users -p github "developer"

# Combined search with custom limits
./gitsearch.sh -t both -n 15 "python"

# Set up API tokens
./gitsearch.sh --setup

# Set tokens directly
./gitsearch.sh --github-token "ghp_xxx" --gitlab-token "glpat_xxx" "query"
```

---

## 🧾 Output Formats

### Repository Output

```text
repository_name|repository_url|description|stars|forks|language
owner/repo|https://github.com/owner/repo|Repo description|150|25|JavaScript
```

### User Output

```text
username|profile_url|name|repos_count|location|platform
johnsmith|https://github.com/johnsmith|John Smith|45|New York|GitHub
alexj|https://gitlab.com/alexj|Alex Johnson|23|San Francisco|GitLab
```

---

## 👥 User Search & Repository Discovery

### Find Users and Their Repositories

```bash
# Search for users matching a name or username
./gitsearch.sh -t users "bercove"

# Find developers in a specific location
./gitsearch.sh -t users "san francisco"

# Discover users with many repositories
./gitsearch.sh -t users "python developer"
```

### User Information Includes

- **Username**: Their platform handle  
- **Profile URL**: Direct link to their profile  
- **Full Name**: Real name (if public)  
- **Repository Count**: Number of public repositories  
- **Location**: Geographic location (if provided)  
- **Platform**: GitHub or GitLab  

---

## 🔧 Configuration

### API Tokens (Optional but Recommended)

**Get your tokens:**

- **GitHub:** Settings → Developer settings → Personal access tokens  
- **GitLab:** Preferences → Access tokens  

**Set up tokens interactively:**

```bash
./gitsearch.sh --setup
```

**Or set manually:**

```bash
# They will be saved to ~/.gitsearch_config
./gitsearch.sh --github-token "ghp_yourtoken" --gitlab-token "glpat_yourtoken" "query"
```

---

## 🚀 Usage Examples (with Language Filter)

You can now filter repositories by programming language:

```bash
# Search for PHP repositories
./gitsearch.sh -l PHP "cms"

# Search for Python machine learning repositories
./gitsearch.sh -l Python "machine learning" -n 15

# Search for JavaScript repositories on GitHub only
./gitsearch.sh -l JavaScript -p github "web framework"
```

---

## 🎯 Examples

### Repository Search Examples

```bash
# Find machine learning repositories
./gitsearch.sh "machine learning python"

# Search for a specific company's repos
./gitsearch.sh "itgrepnet api management"

# Look for Docker-related projects
./gitsearch.sh -n 8 "docker compose"

# GitLab only search
./gitsearch.sh -p gitlab "rust web framework"
```

### User Search Examples

```bash
# Find users by name
./gitsearch.sh -t users "alex"

# Search for developers in a specific technology
./gitsearch.sh -t users "react developer"

# Find GitLab users only
./gitsearch.sh -t users -p gitlab "devops"

# Combined search for comprehensive results
./gitsearch.sh -t both "data science"
```

### Advanced User Discovery

```bash
# Find prolific open-source contributors
./gitsearch.sh -t users -n 20 "python"

# Locate developers in specific regions
./gitsearch.sh -t users "london engineer"

# Discover users with specific skills
./gitsearch.sh -t users "kubernetes"
```

---

## 🔍 Search Tips

### For Repository Search

- Use specific keywords for better results  
- Combine technologies: `"python machine learning tensorflow"`  
- Filter by language: `./gitsearch.sh -l JavaScript "framework"`  
- Search for companies: `"netflix open source"`  
- Use platform-specific searches when looking for particular ecosystems  

### For User Search

- Search by username, full name, or location  
- Combine skills and location: `"python developer new york"`  
- Look for prolific contributors with high repository counts  
- Use platform-specific searches to find experts in particular ecosystems  

---

## ⚙️ Options

| Option | Description | Default |
|--------|--------------|----------|
| `-p, --platform` | Platform: github, gitlab, or both | both |
| `-n, --number` | Number of results | 10 |
| `-t, --type` | Search type: repos, users, or both | repos |
| `-l, --language` | Filter repositories by programming language | none |
| `--github-token` | Set GitHub token | - |
| `--gitlab-token` | Set GitLab token | - |
| `--setup` | Interactive token setup | - |
| `-h, --help` | Show help message | - |

---

## 🐛 Troubleshooting

### Common Issues

**Missing dependencies**

```bash
# Install required tools
sudo apt-get install curl jq
```

**API rate limit exceeded**

```bash
# Set up tokens for higher limits
./gitsearch.sh --setup
```

**No results found**

- Try different search terms  
- Check your internet connection  
- Verify API tokens are valid  
- For user search, try variations of names or usernames  

**Debug Mode**

Add `set -x` at the top of the script for detailed debugging.

---

## 💡 Use Cases

### For Recruiters

```bash
# Find Python developers in Berlin
./gitsearch.sh -t users "python berlin"

# Discover React experts on GitHub
./gitsearch.sh -t users -p github "react"
```

### For Open Source Contributors

```bash
# Find active maintainers in your technology stack
./gitsearch.sh -t users "kubernetes maintainer"

# Discover projects by prolific developers
./gitsearch.sh -t both "machine learning"
```

### For Research

```bash
# Study developer distribution across platforms
./gitsearch.sh -t users "rust"

# Analyze repository patterns by location
./gitsearch.sh -t both "san francisco"
```

---

## 📄 License

MIT License — feel free to use and modify for your projects.

---

## 🔄 Version History

See [`CHANGELOG.md`](CHANGELOG.md) for detailed version changes.
