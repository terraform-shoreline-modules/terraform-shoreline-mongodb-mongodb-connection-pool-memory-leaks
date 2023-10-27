
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB connection pool memory leaks
---

This incident type refers to an issue related to MongoDB connection pool that causes memory leaks. A memory leak occurs when the system fails to release memory that is no longer needed, which can eventually result in depleted memory resources and system failure. In this case, the problem is related to MongoDB connection pool, which is a technique used to manage and reuse database connections in order to improve performance and scalability. The memory leaks may occur due to a variety of reasons, such as improper configuration settings, coding errors, or bugs in the database management software.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export PROCESS_ID="PLACEHOLDER"

export PATH_TO_MONGO_CONFIG_FILE="PLACEHOLDER"

export NEW_CONNECTION_TIMEOUT="PLACEHOLDER"

export NEW_MAX_POOL_SIZE="PLACEHOLDER"
```

## Debug

### Check the amount of memory used by MongoDB:
```shell
sudo service mongod status
```

### Check the size of the connection pool:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.serverStatus().connections)"
```

### Check the number of open connections:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.currentOp().inprog)"
```

### Check the number of connections in the pool:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.serverStatus().extra_info.pool)"
```

### Check the amount of memory used by MongoDB connection pool:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.runCommand({connectionStatus : 1}).totalCreated)"
```

### Check the number of active connections:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.runCommand({currentOp : 1, $all : true}).inprog.length)"
```

### Check the connections per process:
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.currentOp(true).inprog.map(function(op) { return op.client; }))"
```

### Check the amount of memory used by a specific process:
```shell
pmap -x ${PROCESS_ID} | grep total
```

## Repair

### Adjust the configuration settings of the MongoDB connection pool to more efficiently manage database connections and prevent memory leaks. This may involve adjusting connection timeouts, max pool size, and other settings.
```shell


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


```