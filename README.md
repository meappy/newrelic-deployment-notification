## Description:
  - Workflow:
    - Enables or Disables New Relic Alerts

## Syntax:
  - newrelic-wrapper.sh <deployment message> <disable/enable alerts: true|false>
  - Typical usage with a crontab entry i.e.:
    ```bash
    0 3 * * * /opt/newrelic-deployment-notification/newrelic-wrapper.sh "Deployment Started on $(hostname -s)" false &> /dev/null && 
              /opt/other-location/deployment.sh &> /dev/null &&
              /opt/newrelic-deployment-notification/newrelic-wrapper.sh "Deployment Finished on $(hostname -s)" true &> /dev/null
    ```

## Revision history:
  - 13 Feb 2017, Gerald Sim: Initial release                             

## TODO:
  - Add flexibility for use with other scripts and customers
  - Add ability to use with Avamar pre and post script for OS backups
