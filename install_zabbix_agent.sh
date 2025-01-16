#!/bin/bash
set -e

# Variables
ZABBIX_SERVER_IP="x.x.x.x"
ZABBIX_AGENT_CONF="/etc/zabbix/zabbix_agentd.conf"

# Update packages
sudo dnf update -y

# Install the Zabbix agent
sudo rpm -Uvh https://repo.zabbix.com/zabbix/7.0/amazonlinux/2023/x86_64/zabbix-release-latest-7.0.amzn2023.noarch.rpm
sudo dnf install -y zabbix-agent

# Configure the agent
sudo sed -i "s/^Server=127.0.0.1/Server=$ZABBIX_SERVER_IP/" $ZABBIX_AGENT_CONF
sudo sed -i "s/^ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_IP/" $ZABBIX_AGENT_CONF

# Start and enable the Zabbix agent
sudo service zabbix-agent start
sudo service enable zabbix-agent
