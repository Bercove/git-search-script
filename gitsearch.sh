#!/bin/bash

# Git Search 🔍
# A powerful tool for searching repositories across GitHub and GitLab
# Version: 2.0.1
# Author: Bercove
# License: MIT

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="$HOME/.gitsearch_config"
GITHUB_API="https://api.github.com/search/repositories"
GITLAB_API="https://gitlab.com/api/v4/projects"
VERSION="2.0.1"

# Banner
show_banner() {
    cat << "EOF"
   ____ _ _   ____                           
  / ___(_) |_/ ___|  ___ _ __ __ _ _ __ ___  
 | |  _| | __\___ \ / __| '__/ _` | '_ ` _ \ 
 | |_| | | |_ ___) | (__| | | (_| | | | | | |
  \____|_|\__|____/ \___|_|  \__,_|_| |_| |_|
                                             
EOF
    echo -e "${BLUE}Git Search v${VERSION} - Search GitHub & GitLab${NC}"
    echo
}

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        GITHUB_TOKEN=""
        GITLAB_TOKEN=""
    fi
}

# Show help
show_help() {
    show_banner
    cat << EOF
Usage: $0 [OPTIONS] QUERY

Search for repositories on GitHub and GitLab.

OPTIONS:
    -p, --platform PLATFORM    Search platform: github, gitlab, both (default: both)
    -n, --number NUMBER        Number of results (default: 10)
    --github-token TOKEN       Set GitHub personal access token
    --gitlab-token TOKEN       Set GitLab personal access token
    --setup                    Interactive setup for API tokens
    --version                  Show version information
    -h, --help                 Show this help message

EXAMPLES:
    $0 "machine learning"
    $0 -p github -n 5 "python web framework"
    $0 --setup
    $0 --github-token "ghp_xxx" "docker"

OUTPUT FORMAT:
    name|url|description|stars|forks|language

GETTING TOKENS:
    GitHub: https://github.com/settings/tokens
    GitLab: https://gitlab.com/-/profile/personal_access_tokens

EOF
}

# Show version
show_version() {
    show_banner
    exit 0
}

# Make API request
make_api_request() {
    local url="$1"
    local platform="$2"
    
    local headers=()
    if [[ "$platform" == "github" && -n "$GITHUB_TOKEN" ]]; then
        headers=(-H "Authorization: token $GITHUB_TOKEN")
    elif [[ "$platform" == "gitlab" && -n "$GITLAB_TOKEN" ]]; then
        headers=(-H "Authorization: Bearer $GITLAB_TOKEN")
    fi
    
    if [[ "$platform" == "github" ]]; then
        headers+=(-H "Accept: application/vnd.github.v3+json")
    fi
    
    headers+=(-H "User-Agent: GitSearch/$VERSION")
    
    local response
    response=$(curl -s --connect-timeout 10 --max-time 30 "${headers[@]}" "$url")
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]]; then
        echo -e "${RED}ERROR: Failed to connect to $platform${NC}" >&2
        return 1
    fi
    
    if [[ -z "$response" ]]; then
        echo -e "${RED}ERROR: Empty response from $platform${NC}" >&2
        return 1
    fi
    
    # Check for API errors
    if echo "$response" | jq -e '.message? // empty' >/dev/null 2>&1; then
        local error_msg=$(echo "$response" | jq -r '.message')
        echo -e "${RED}ERROR: $platform API - $error_msg${NC}" >&2
        return 1
    fi
    
    echo "$response"
}

# Search GitHub
search_github() {
    local query="$1"
    local max_results="$2"
    
    if [[ -z "$query" ]]; then
        return
    fi
    
    local encoded_query=$(echo "$query" | sed 's/ /+/g' | sed 's/"/%22/g')
    local url="$GITHUB_API?q=$encoded_query&per_page=$max_results&sort=bestmatch"
    
    echo -e "  ${CYAN}🔍 GitHub:${NC} $query" >&2
    
    local response
    response=$(make_api_request "$url" "github")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    echo "$response" | jq -r '.items[]? | "\(.full_name)|\(.html_url)|\(.description // "No description")|\(.stargazers_count)|\(.forks_count)|\(.language // "Unknown")"' 2>/dev/null
}

# Search GitLab
search_gitlab() {
    local query="$1"
    local max_results="$2"
    
    if [[ -z "$query" ]]; then
        return
    fi
    
    local encoded_query=$(echo "$query" | sed 's/ /+/g')
    local url="$GITLAB_API?search=$encoded_query&per_page=$max_results&order_by=similarity"
    
    echo -e "  ${CYAN}🔍 GitLab:${NC} $query" >&2
    
    local response
    response=$(make_api_request "$url" "gitlab")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    echo "$response" | jq -r '.[]? | "\(.path_with_namespace)|\(.web_url)|\(.description // "No description")|\(.star_count)|\(.forks_count)|\(.language // "Unknown")"' 2>/dev/null
}

# Setup tokens
setup_tokens() {
    show_banner
    echo -e "${YELLOW}🔐 API Token Setup${NC}"
    echo
    echo "Tokens are optional but provide higher rate limits."
    echo
    
    read -p "Enter GitHub token (leave empty to skip): " github_token
    read -p "Enter GitLab token (leave empty to skip): " gitlab_token
    
    cat > "$CONFIG_FILE" << EOF
GITHUB_TOKEN="$github_token"
GITLAB_TOKEN="$gitlab_token"
EOF
    chmod 600 "$CONFIG_FILE"
    
    echo
    echo -e "${GREEN}✅ Configuration saved to $CONFIG_FILE${NC}"
}

# Main search function
main_search() {
    local query="$1"
    local platform="$2"
    local max_results="$3"
    
    if [[ -z "$query" ]]; then
        echo -e "${RED}ERROR: Query is empty${NC}" >&2
        return 1
    fi
    
    load_config
    
    local results=""
    local github_count=0
    local gitlab_count=0
    
    # Calculate per-platform results
    local platform_max=$((max_results / 2))
    if [[ $platform_max -lt 1 ]]; then
        platform_max=1
    fi
    
    echo -e "${BLUE}📦 Search Query:${NC} $query"
    echo -e "${BLUE}🎯 Max Results:${NC} $max_results"
    echo
    
    if [[ "$platform" == "github" || "$platform" == "both" ]]; then
        local github_results
        github_results=$(search_github "$query" "$platform_max")
        if [[ $? -eq 0 && -n "$github_results" ]]; then
            results="${results}${github_results}\n"
            github_count=$(echo -e "$github_results" | grep -c .)
        fi
    fi
    
    if [[ "$platform" == "gitlab" || "$platform" == "both" ]]; then
        local gitlab_results
        gitlab_results=$(search_gitlab "$query" "$platform_max")
        if [[ $? -eq 0 && -n "$gitlab_results" ]]; then
            results="${results}${gitlab_results}\n"
            gitlab_count=$(echo -e "$gitlab_results" | grep -c .)
        fi
    fi
    
    echo
    echo -e "${GREEN}📊 Results:${NC} GitHub($github_count) + GitLab($gitlab_count) = $((github_count + gitlab_count)) total"
    echo
    
    if [[ -z "$results" ]]; then
        echo -e "${YELLOW}No results found${NC}"
        return 1
    fi
    
    # Remove duplicates and limit
    echo -e "$results" | awk -F'|' 'length($2) > 0 && !seen[$2]++' | head -n "$max_results"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    for dep in curl jq; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}ERROR: Missing dependencies: ${missing_deps[*]}${NC}" >&2
        echo "Install with:"
        echo "  Ubuntu/Debian: sudo apt-get install ${missing_deps[*]}"
        echo "  macOS: brew install ${missing_deps[*]}"
        echo "  CentOS/RHEL: sudo yum install ${missing_deps[*]}"
        exit 1
    fi
}

# Main execution
main() {
    local platform="both"
    local max_results=10
    local query=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--platform)
                platform="$2"
                shift 2
                ;;
            -n|--number)
                max_results="$2"
                shift 2
                ;;
            --github-token)
                GITHUB_TOKEN="$2"
                shift 2
                ;;
            --gitlab-token)
                GITLAB_TOKEN="$2"
                shift 2
                ;;
            --setup)
                setup_tokens
                exit 0
                ;;
            --version)
                show_version
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                echo -e "${RED}ERROR: Unknown option $1${NC}" >&2
                show_help
                exit 1
                ;;
            *)
                query="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z "$query" ]]; then
        echo -e "${RED}ERROR: Query is required${NC}" >&2
        show_help
        exit 1
    fi
    
    check_dependencies
    main_search "$query" "$platform" "$max_results"
}

# Run main function
main "$@"