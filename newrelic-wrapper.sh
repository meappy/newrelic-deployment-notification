#!/bin/bash
#==============================================================================
#  /opt/newrelic-deployment-notification/newrelic-wrapper.sh
#
#  Syntax:
#    - newrelic-wrapper.sh <deployment message> <disable/enable alerts: true|false>
#    - Typical usage with a crontab entry i.e.:
#      - 0 3 * * * /opt/newrelic-deployment-notification/newrelic-wrapper.sh "Deployment Started on $(hostname -s)" false &> /dev/null && 
#                  /opt/other-location/deployment.sh &> /dev/null &&
#                  /opt/newrelic-deployment-notification/newrelic-wrapper.sh "Deployment Finished on $(hostname -s)" true &> /dev/null
#
#  Description:
#    - Workflow:
#      - Enabled or Disables New Relic Alerts
#
#  Revision history:
#    - 13 Feb 2017, Gerald Sim: Initial release                             
#
#  Todo:
#    - Add flexibility for use with other scripts and customers
#    - Add ability to use with Avamar pre and post script for OS backups
#
#==============================================================================

#
# Config (this is where we set all of the configurables)
#
source /opt/newrelic-deployment-notification/newrelic-wrapper.cfg

#
# Main script
#

# Only send a deployment notification when NR_APP_IDS is set
if [ "${NR_APP_IDS}" = "NOT_SET" ]
then
  echo ERROR: Failed to set deployment notification. Are you running this on the right sewrver? Please recheck variables. 1>&2
  exit 1
else
  # Start New Relic Deployment Marker
  for NR_APP_ID in ${NR_APP_IDS}
  do
    # Set deployment marker
    curl --proxy "${PROXY}" \
         -X POST 'https://api.newrelic.com/v2/applications/'"${NR_APP_ID}"'/deployments.json' \
         -H 'X-Api-Key:'"${NR_API_KEY}"'' -s \
         -H 'Content-Type: application/json' \
         -d \
    '{
      "deployment": {
        "revision": '\"$(date +%u)\"',
        "description": '\""${1}"\"',
        "user": '\""${NR_DEPLOY_USR}"\"'
      }
    }'
  done
fi

# "Repl Lag (High)" notification
curl --proxy "${PROXY}" \
     -X PUT 'https://api.newrelic.com/v2/alerts_plugins_conditions/'"${NR_POLICY_ID1}"'.json' \
     -H 'X-Api-Key:'"${NR_API_KEY}"'' -s \
     -H 'Content-Type: application/json' \
     -d "${NR_DATA1}"

# "Disk IO % (High)" notification
curl --proxy "${PROXY}" \
     -X PUT 'https://api.newrelic.com/v2/alerts_conditions/'"${NR_POLICY_ID2}"'.json' \
     -H 'X-Api-Key:'"${NR_API_KEY}"'' -s \
     -H 'Content-Type: application/json' \
     -d "${NR_DATA2}"
