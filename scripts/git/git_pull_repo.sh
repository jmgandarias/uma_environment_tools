#!/bin/bash
#
#  Author: Juan M. Gandarias
# email: jmgandarias@uma.es
#
# Thanks to the support of the HRII Technicians
#
# Function that safely pulls the repo given as input
#

yes_to_all=0
remote_update=0

source $HOME/git/uma_github/general/uma_installation_tools/scripts/utils.sh

git_pull_repo()
{
    # Absolute repo path
    repo_folder=$1

    # Automatic pull
    if [[ "$2" == "Y" || "$2" == "y" ]]; then
      yes_to_all=1;
    fi

    cd $repo_folder
    repo_folder=${repo_folder##*/}

    # get status
    status=`git status 2>&1`;

    # check if folder is a git repository
    if echo $status|grep -qoP "fatal: not a git repository"; then
       echo -e "\e[33m$repo_folder \e[39mis not a git repository.\e[39m"
    else

      # update git with server version
      # if [[ $remote_update == 1 ]]; then
        # git remote update > /dev/null;
      # fi

      # Always performing, otherwise not working
      git remote update > /dev/null;

      # clean-up git stale branch
      remote_status=`git remote show origin`;

      if echo $remote_status|grep -q 'stale'; then
        searchstring="stale"
        temp=${remote_status%$searchstring*}
        echo "temp: $temp"
        stale_branch=$(echo $temp|sed 's:.*/::')

        echo -e "Stale case on branch ($stale_branch). Removing it..."
        git fetch --prune origin
        delete_status=$(git branch -d $stale_branch 2>&1);
        #echo "delete_status: $delete_status"

        if echo $delete_status|grep -q 'error: Cannot delete branch'; then
            default_branch_raw=$(git remote show origin | grep "HEAD branch:")
            default_branch=${default_branch_raw:15}

            warn "Branch $stale_branch does not exist anymore. Would you like to checkout on the default branch $default_branch? [Y/n]"
            read ans
            if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
              echo "Checking out to branch $default_branch"
              git checkout $default_branch
              git branch -d $stale_branch
            fi
        fi
        remote_status=`git remote show origin`;
      fi

      # get status
      status=`git status`;

      # assign branch branch_name
      if echo $status|grep -qoP "On branch\s+\K([^\s]+)"; then
        branch_name=`echo $status|grep -oP "On branch\s+\K([^\s]+)"`;
      else if echo $status|grep -q "HEAD detached"; then
             branch_name="HEAD detached";
           fi
      fi

      # Fix possible branch not upstreamed
      if echo "$remote_status"|grep "$branch_name"|grep -q "merges with"; then
        :
      else
        if [ $( echo $status | grep -c "HEAD detached" ) -lt 1 ]; then
          echo "Fixing branch not upstreamed."
          #git push -u origin $branch_name
          git branch --set-upstream-to origin/$branch_name
          git remote show origin
          # update status
          status=`git status`;

        fi
      fi

      ## This needs to be double checked
      if [ $( echo "$status"|grep -c "but the upstream is gone") -gt 0 ] ; then
              default_branch_raw=$(git remote show origin | grep "HEAD branch:")
              default_branch=${default_branch_raw:15}
              echo "Upstream is gone: fixing branch not upstreamed with default branch ($default_branch)."
              #git push -u origin $branch_name
              git branch --set-upstream-to origin/$default_branch
              git checkout $default_branch
              branch_name=$default_branch
              git remote show origin
              # update status
              status=`git status`;
      fi

      echo -e "\e[32m$repo_folder \e[33m($branch_name) \e[39m--> \c"

      if echo $status|grep -q 'Untracked'; then
        echo -e "\e[31mcannot be pulled safely (untracked files).\e[39m"
        repo_count_can_not_be_pulled=$((repo_count_can_not_be_pulled+1))
      else if echo $status|grep -q 'modified'; then
             echo -e "\e[31mcannot be pulled safely (modified files).\e[39m"
             repo_count_can_not_be_pulled=$((repo_count_can_not_be_pulled+1))
           else if echo $status|grep -q 'HEAD detached'; then
                  echo -e "\e[31mcannot be pulled (HEAD detached).\e[39m"
                  repo_count_can_not_be_pulled=$((repo_count_can_not_be_pulled+1))
                else
                  if echo $status|grep -q 'behind'; then
                    echo -e "can be pulled safely. Pull? [Y/n]"
                    if [[ $yes_to_all == 0 ]]; then
                      read ans
                    else
                      ans="Y"
                    fi
                    if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
                      echo "Pulling..."
                      git pull origin $branch_name  > /dev/null;
                      repo_count_pulled=$((repo_count_pulled+1))
                    else
                      echo "Not pulling..."
                      repo_count_notpulled=$((repo_count_notpulled+1))
                    fi
                  else
                    echo "up-to-date."
                    repo_count_uptodate=$((repo_count_uptodate+1))
                  fi
                fi
           fi
      fi
    fi
}
