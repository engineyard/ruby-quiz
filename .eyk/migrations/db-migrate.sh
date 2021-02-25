#!/bin/bash
 
# In order to run migrations *only* during deployments and not confgiration changes
# we discrimiate the cases via the variable WORKFLOW_RELEASE_SUMMARY (already existing via eyk):
# deployment: WORKFLOW_RELEASE_SUMMARY=igiannoulas deployed e628573
# configuration: WORKFLOW_RELEASE_SUMMARY=igiannoulas added foo
# configuration: WORKFLOW_RELEASE_SUMMARY=igiannoulas changed foo
# configuration: WORKFLOW_RELEASE_SUMMARY=igiannoulas deleted foo
IN_DEPLOYMENT="no"

if [[ "$WORKFLOW_RELEASE_SUMMARY" == *' added '* ]] || [[ "$WORKFLOW_RELEASE_SUMMARY" == *' changed '* ]] || [[ "$WORKFLOW_RELEASE_SUMMARY" == *' deleted '* ]]
  then
    echo "Migrations won't run because this pod was invoked during a configuration change"
else
    echo "This is a Deployment so we will check if migrations are going to run"
    IN_DEPLOYMENT="yes"
fi

RUN_MIGRATIONS=${migration_pod_config_run_migrations:-no}

if [ "$IN_DEPLOYMENT" = "yes" ]
  then
    if [ "$RUN_MIGRATIONS" = "yes" ]
    then
      echo "Migrations will run because RUN_MIGRATIONS=${RUN_MIGRATIONS}"
      VERBOSE=true bundle exec rake db:migrate:status --trace
      VERBOSE=true bundle exec rake db:migrate --trace ; MIGRATE_STATUS=$?
      sleep 120
      if [ "$MIGRATE_STATUS" -eq 0 ]
        then
        # Mark the migration ready for the Deis readiness probe
        touch /tmp/migration-ready
        echo "Migrations completed successfully with exit status: ${MIGRATE_STATUS}. Continue Deployment."
      else
        echo "Migration error with exit status: ${MIGRATE_STATUS}. Rolling back."
      fi
  else
    echo "Migrations won't run because RUN_MIGRATIONS=${RUN_MIGRATIONS}"
    # No need to block Deployment here. Mark the migration pod ready for the EYK readiness probe
     touch /tmp/migration-ready
  fi
else
  # No need to block Deployment here. Mark the migration pod ready for the EYK readiness probe
  touch /tmp/migration-ready
fi
 
# Get in a loop in order not to restart the pod
while true; do sleep 60; done;