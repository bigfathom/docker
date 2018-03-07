#!/bin/bash
VERSIONINFO=20180306.1
echo "Starting $0 v$VERSIONINFO"
echo

cd /var/www/html

MODULE_ROOTPATH="sites/all/modules"
THEMES_ROOTPATH="sites/all/themes"
DRUPAL_ADMIN_NAME="admin"
DRUPAL_ADMIN_PASSWORD="apass2018"
DB_USER_NAME="appuser"
DB_USER_PASSWORD="apass2018"
DB_HOST="db"
DB_NAME="bigfathom_preview"

echo "... DRUPAL_ADMIN_NAME=$DRUPAL_ADMIN_NAME"
echo "... DB_USER_NAME=$DB_USER_NAME"
echo "... DB_HOST=$DB_HOST"
echo "... DB_NAME=$DB_NAME"
echo

#Pause for a few seconds to work around possible timing issue (server services starting)
sleep 10

#Create an initial database structure
echo
cd /var/www/html
echo "Creating baseline target Drupal7 database structure ..."
BASICSETUP_CMD="drush site-install standard --account-name=${DRUPAL_ADMIN_NAME} --account-pass=${DRUPAL_ADMIN_PASSWORD} --db-url=mysql://${DB_USER_NAME}:${DB_USER_PASSWORD}@${DB_HOST}/${DB_NAME} install_configure_form.update_status_module='array(FALSE,FALSE)' --yes"
echo $BASICSETUP_CMD
eval $BASICSETUP_CMD
if [ $? -ne 0 ]; then
    echo
    pwd
    ls
    echo
    echo "Failed basic setup of Drupal --- will try again after a short pause ..."

    sleep 20
    eval $BASICSETUP_CMD
    if [ $? -ne 0 ]; then
        echo
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "ERROR Failed on the site install!!!!!!!!!!!!!!!!"
        echo "Aborting the setup!"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo
        echo "TIP: Retry the startup after shutting the stack down."
        echo
        exit 2
    fi
fi
echo "Basic Drupal is now in place ... going to next steps"

drush vset clean_url 0 --yes

#Enable the modules
echo
echo "Enabling supporting modules..."
for DIRPATH in ${MODULE_ROOTPATH}/additional/*; do

        if [ -d "$DIRPATH" ]; then
                DIRNAME=$(basename $DIRPATH)
                echo "Enabling $DIRNAME"
                drush en $DIRNAME --yes --skip
        fi

done

echo
echo "Enabling Bigfathom modules..."
BFMODS=""
for DIRPATH in ${MODULE_ROOTPATH}/just_bigfathom/*; do

        if [ -d "$DIRPATH" ]; then
                DIRNAME=$(basename $DIRPATH)
                echo "Enabling $DIRNAME"
                drush en $DIRNAME --yes --skip
                BFMODS="$DIRNAME $BFMODS"
        fi

done
if [ -z "$BFMODS" ]; then
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ERROR: BIGFATHOM MODULES NOT FOUND FOR INSTALL!!!!!!!!!!!!!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo
    sleep 5
    echo "Continuing but you have something unhappy happening!"
    echo
fi

#Clear cache
echo "Clearing cache..."
drush cc all
sleep 5

#Configure the settings
echo "Final Drupal and Bigfathom configurations steps..."
drush pm-enable ${THEMES_ROOTPATH}/omega --skip --no
drush pm-enable ${THEMES_ROOTPATH}/omega_bigfathom --skip --no
drush vset theme_default omega_bigfathom --yes
drush vset site_name Bigfathom --yes

echo "Done with $0 v$VERSIONINFO"