

#!/bin/bash



# Set variables

MONGO_CONFIG_FILE=${PATH_TO_MONGO_CONFIG_FILE}

NEW_TIMEOUT=${NEW_CONNECTION_TIMEOUT}

NEW_POOL_SIZE=${NEW_MAX_POOL_SIZE}



# Update MongoDB connection pool configuration

sed -i "s/^connectionTimeoutMs=.*/connectionTimeoutMs=${NEW_TIMEOUT}/" ${MONGO_CONFIG_FILE}

sed -i "s/^maxPoolSize=.*/maxPoolSize=${NEW_POOL_SIZE}/" ${MONGO_CONFIG_FILE}



# Restart MongoDB service

systemctl restart mongodb



# Verify changes

mongo --eval "printjson(db.runCommand({getParameter: 1, connectionPool: 1}))"