# 🔍 Git Search — Version History

---

## 🧭 Changelog

### [2.1.1] — 2025-10-21

#### 🚀 New Features

- Added **language filter** support for repository searches using `-l` or `--language`
- Updated argument parser to recognize the new language flag
- GitHub searches now use the `+language:LANG` syntax in API queries
- GitLab results are now filtered by language after data retrieval
- Updated help text and documentation with language filter usage

#### 🧪 Usage Examples

You can now filter repositories by programming language:

```bash
# Search for PHP repositories
./gitsearch.sh -l PHP "cms"

# Search for Python machine learning repositories
./gitsearch.sh -l Python "machine learning" -n 15

# Search for JavaScript repositories on GitHub only
./gitsearch.sh -l JavaScript -p github "web framework"
```

#### 🎯 Summary of Changes

- Added `-l`, `--language` option to argument parsing  
- Modified GitHub search to use language filter in API query  
- Added post-filtering by language for GitLab results  
- Updated help text and usage examples  
- Language filter applies only to repository searches, not user searches  

---

### [2.1.0] — October 2025

#### ✨ Added

- Introduced **user search functionality**
- Added support for both **repository** and **user** searches
- Implemented **combined search mode** (`-t both`)
- Enhanced output formatting for user results
- Included **developer location** and **repository count** in user results

#### 🔧 Changed

- Improved documentation with new examples
- Refined search balancing logic for hybrid queries

#### 🐛 Fixed

- Fixed GitLab pagination issues for large result sets
- Corrected output alignment for long repository descriptions

---

### [2.0.0] — September 2025

#### 🎉 Initial Major Release

- Implemented **repository search** for **GitHub** and **GitLab**
- Added **API token support**
- Introduced **smart result balancing** between platforms
- Added **CLI options** for search limits, tokens, and setup
- Provided **initial documentation and example usage**

---

### 🔮 Upcoming Plans

#### 🧩 Planned Features

- Add **organization search** support  
- Introduce **JSON output format** for integration with other tools  
- Optional **interactive terminal mode** for easier use  
- Add **export to CSV** functionality for search results
