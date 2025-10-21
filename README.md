# Git Search 🔍

A powerful bash script for searching repositories across GitHub and GitLab simultaneously.

---

## ✨ Features

- **Dual Platform Search**: Search both GitHub and GitLab in one command  
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

# Basic search
./gitsearch.sh "machine learning"

# Search with platform filter
./gitsearch.sh -p github "python web framework"

# Limit results
./gitsearch.sh -n 5 "docker kubernetes"
```

---

## 📖 Usage

### Basic Search

```bash
./gitsearch.sh "your search query"
```

### Advanced Options

```bash
# Search only GitHub
./gitsearch.sh -p github "react components"

# Search only GitLab
./gitsearch.sh -p gitlab "rust library"

# Get 20 results (10 from each platform)
./gitsearch.sh -n 20 "api platform"

# Set up API tokens
./gitsearch.sh --setup

# Set tokens directly
./gitsearch.sh --github-token "ghp_xxx" --gitlab-token "glpat_xxx" "query"
```

---

## 🧾 Output Format

```text
repository_name|repository_url|description|stars|forks|language
owner/repo|https://github.com/owner/repo|Repo description|150|25|JavaScript
```

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

## 🎯 Examples

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

---

## 🔍 Search Tips

- Use specific keywords for better results  
- Combine technologies: `"python machine learning tensorflow"`  
- Search for companies: `"netflix open source"`  
- Use platform-specific searches when looking for particular ecosystems  

---

## ⚙️ Options

| Option | Description | Default |
|--------|--------------|----------|
| `-p, --platform` | Platform: github, gitlab, or both | both |
| `-n, --number` | Number of results | 10 |
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

**Debug Mode**

Add `set -x` at the top of the script for detailed debugging.

---

## 📄 License

MIT License — feel free to use and modify for your projects.
