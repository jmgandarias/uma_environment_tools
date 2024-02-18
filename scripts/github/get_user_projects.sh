#!/bin/bash

# Intro message
echo -e '|------------------------------------------------------------|'
echo -e "|  Enter your gitlab token created on the Gitlab website at: |"
echo -e "|   https://gitlab.iit.it/-/profile/personal_access_tokens   |"
echo -e "|            Make sure to check the \"api\" scope              |"
echo -e '|------------------------------------------------------------|'

# Get or read TOKEN
if [ -z "$TOKEN" ]; then
    echo -ne '\nInsert token: '
    read TOKEN
    echo -e ''
fi
  
echo '------------------------------------------------------------------------------------------'
PREFIX="ssh_url_to_repo";

# Getting the accessible repos based on the token
# Get number of pages
X_TOTAL_PAGES=$(curl --head  "https://gitlab.iit.it/api/v4/projects?private_token=$TOKEN&per_page=100" | grep x-total-pages)
PAGES=${X_TOTAL_PAGES: -2:1}
echo "PAGES: $PAGES"
REPOS_STRING=""
PAGE_REPOS=""
for ((page = 1 ; page <= $PAGES ; page++)); do

  echo "page: $page"
  PROJ_TMP=$(curl "https://gitlab.iit.it/api/v4/projects?private_token=$TOKEN&per_page=100&page=$page")
  PAGE_REPOS=$(echo $PROJ_TMP | grep -o "\"$PREFIX\":[^ ,]\+"  | grep hrii | awk -F 'gitlab.iit.it:hrii/' '{print $2}' | sed 's/.$//')
  if [ -z "$PAGE_REPOS" ]; then
        echo "Page is empty"
  else
        REPOS_STRING+=$(echo -e "\n$PAGE_REPOS")
  fi
  
  echo '------------------------------------------------------------------------------------------'

done

REPOS_STRING=$(echo $REPOS_STRING | xargs -n1 | sort -u | xargs)

HRII_GITLAB_REPOS=($REPOS_STRING)

# Create file
echo -n "" > create_gitlab_dir.sh
echo -e "#!/bin/bash\n" >> create_gitlab_dir.sh
echo -e "declare -a HRII_GITLAB_REPOS=(" >> create_gitlab_dir.sh

for i in "${HRII_GITLAB_REPOS[@]}"
do
   echo "    \"$i\"" >> create_gitlab_dir.sh
done

echo -e ")\n" >> create_gitlab_dir.sh

# Add repos to be downloaded in the local HRII TREE
echo -e "declare -a HRII_TREE_GITLAB_REPOS=(" >> create_gitlab_dir.sh
echo -e "    \"general/hrii_installation_tools.git\"" >> create_gitlab_dir.sh
echo -e "    \"general/hrii_utils.git\"" >> create_gitlab_dir.sh
echo -e "    \"general/matlogger2.git\"" >> create_gitlab_dir.sh
echo -e "    \"robotics/franka/libfranka.git\"" >> create_gitlab_dir.sh
echo -e "    \"robotics/grippers/qbrobotics-api.git\"" >> create_gitlab_dir.sh
echo -e ")" >> create_gitlab_dir.sh

