#!/bin/bash
set -e

# Access environment variables from Elastic Beanstalk
export ZABBIX_SERVER_IP=${ZABBIX_SERVER_IP}
export ZABBIX_AGENT_CONF=${ZABBIX_AGENT_CONF}
export ZABBIX_AGENT_VERSION=${ZABBIX_AGENT_VERSION}

# Update packages
sudo dnf upgrade -y 

# Check if the Zabbix agent is already running
if pgrep -x "zabbix_agentd" > /dev/null
then
    echo "Zabbix agent is already running. Skipping installation and start."
    exit 0  # Exit the script as Zabbix is already running
else
    # Install the Zabbix agent
    sudo rpm -Uvh $ZABBIX_AGENT_VERSION
    sudo dnf install -y zabbix-agent --exclude=zabbix-tools

    # Configure the agent
    sudo sed -i "s/^Server=127.0.0.1/Server=$ZABBIX_SERVER_IP/" $ZABBIX_AGENT_CONF
    sudo sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_IP/" $ZABBIX_AGENT_CONF
    sudo sed -i "s/^Hostname=Zabbix server/Hostname=hostname/" $ZABBIX_AGENT_CONF

    # Start the Zabbix agent
    sudo /usr/sbin/zabbix_agentd
fi