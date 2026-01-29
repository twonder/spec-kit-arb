#!/usr/bin/env bash

set -e

# Source common functions
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

JSON_MODE=false
ADR_TITLE=""
ARGS=()
i=1
while [ $i -le $# ]; do
    arg="${!i}"
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] <adr_title>"
            echo ""
            echo "Options:"
            echo "  --json          Output in JSON format"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 'Use PostgreSQL for primary database'"
            echo "  $0 --json 'Adopt microservices architecture'"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
    i=$((i + 1))
done

ADR_TITLE="${ARGS[*]}"
if [ -z "$ADR_TITLE" ]; then
    echo "Usage: $0 [--json] <adr_title>" >&2
    exit 1
fi

# Function to find the repository root by searching for existing project markers
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/.specify" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to get highest ADR number from directory
get_highest_adr_number() {
    local adr_dir="$1"
    local highest=0

    if [ -d "$adr_dir" ]; then
        for file in "$adr_dir"/ADR-*.md; do
            [ -f "$file" ] || continue
            filename=$(basename "$file")
            # Extract number from ADR-###-slug.md pattern
            if [[ "$filename" =~ ^ADR-([0-9]+)- ]]; then
                number=$((10#${BASH_REMATCH[1]}))
                if [ "$number" -gt "$highest" ]; then
                    highest=$number
                fi
            fi
        done
    fi

    echo "$highest"
}

# Function to clean and format a slug
clean_slug() {
    local name="$1"
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//'
}

# Function to generate slug from title with stop word filtering
generate_slug() {
    local title="$1"

    # Common stop words to filter out
    local stop_words="^(i|a|an|the|to|for|of|in|on|at|by|with|from|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|should|could|can|may|might|must|shall|this|that|these|those|my|your|our|their|want|need|we)$"

    # Convert to lowercase and split into words
    local clean_name=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/ /g')

    # Filter words
    local meaningful_words=()
    for word in $clean_name; do
        [ -z "$word" ] && continue
        if ! echo "$word" | grep -qiE "$stop_words"; then
            if [ ${#word} -ge 2 ]; then
                meaningful_words+=("$word")
            fi
        fi
    done

    # Use first 4-5 meaningful words
    if [ ${#meaningful_words[@]} -gt 0 ]; then
        local max_words=5
        local result=""
        local count=0
        for word in "${meaningful_words[@]}"; do
            if [ $count -ge $max_words ]; then break; fi
            if [ -n "$result" ]; then result="$result-"; fi
            result="$result$word"
            count=$((count + 1))
        done
        echo "$result"
    else
        # Fallback
        clean_slug "$title"
    fi
}

# Resolve repository root
if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
else
    REPO_ROOT="$(find_repo_root "$SCRIPT_DIR")"
    if [ -z "$REPO_ROOT" ]; then
        echo "Error: Could not determine repository root. Please run this script from within the repository." >&2
        exit 1
    fi
fi

cd "$REPO_ROOT"

# Load configuration
load_config "$REPO_ROOT"

# Get ADR directory from config
ADR_DIR="$REPO_ROOT/$(get_adr_dir)"
mkdir -p "$ADR_DIR"

# Get next ADR number
HIGHEST=$(get_highest_adr_number "$ADR_DIR")
ADR_NUM=$((HIGHEST + 1))
ADR_NUM_FORMATTED=$(printf "%03d" "$ADR_NUM")

# Generate slug from title
SLUG=$(generate_slug "$ADR_TITLE")

# Create ADR filename
ADR_FILENAME="ADR-${ADR_NUM_FORMATTED}-${SLUG}.md"
ADR_FILE="$ADR_DIR/$ADR_FILENAME"

# Copy template if it exists, otherwise create empty file
TEMPLATE="$REPO_ROOT/.specify/templates/adr-template.md"
if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$ADR_FILE"
else
    # Check for template in the package templates directory
    PACKAGE_TEMPLATE="$SCRIPT_DIR/../../templates/adr-template.md"
    if [ -f "$PACKAGE_TEMPLATE" ]; then
        cp "$PACKAGE_TEMPLATE" "$ADR_FILE"
    else
        touch "$ADR_FILE"
    fi
fi

# Output result
if $JSON_MODE; then
    printf '{"ADR_NUM":"%s","ADR_FILE":"%s","ADR_TITLE":"%s","ADR_SLUG":"%s"}\n' "$ADR_NUM_FORMATTED" "$ADR_FILE" "$ADR_TITLE" "$SLUG"
else
    echo "ADR_NUM: $ADR_NUM_FORMATTED"
    echo "ADR_FILE: $ADR_FILE"
    echo "ADR_TITLE: $ADR_TITLE"
    echo "ADR_SLUG: $SLUG"
fi
