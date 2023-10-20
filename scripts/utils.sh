
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

error() {
    printf "${RED}${1}${NC}\n" >> /dev/stderr
}

warn() {
    printf "${ORANGE}${1}${NC}\n"
}

success() {
    printf "${GREEN}${1}${NC}\n"
}

blue() {
    printf "${BLUE}${1}${NC}\n"
}
