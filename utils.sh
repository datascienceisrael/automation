# utils.sh
# -----------------------------------------------
# [Data Science Group Ltd.]
# https://www.datascience.co.il/
#
# Utility Functions
# ------------------------------------------------

HOSTS_FILE_PATH=conf/hosts.txt

##################################################################
# Description: create dropdown menu from array
# Arguments:
#   $1 -> array
##################################################################
create_hosts_menu()
{
  # user notifications
  prompt="Pick an option:"
  echo "=== Host Selection ==="
  PS3="$prompt "
  select host in "$@" "exit"
  do
    if [ "$REPLY" -eq "$(($#+1))" ];
      then
      echo "Exiting..."
      exit;
    elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le "$(($#))" ];
      then
      echo "Setting up $host connection"
      break;
    else
      echo "Invalid Input: Select a number between 1-$(($#+1))"
    fi
  done
}
##################################################################
# Description: prompt for username
# Arguments:
#   None
##################################################################
prompt_for_user()
{
  read -p "Enter your remote username [$USER]: " username
  username=${username:-$USER}
}
##################################################################
# Description: prompt for hostname
# Arguments:
#   None
##################################################################
prompt_for_host()
{
  read -p "Enter host name: " ssh_host
}
