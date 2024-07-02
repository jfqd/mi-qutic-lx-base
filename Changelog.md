# Changelog

## 20231121.1 - 2024-07-02

* add optional ipv6 route-option
* add mail-adminaddr to aliases

## 20231121.0 - 2024-07-02

* disable ssh and rpcbind services
* include mailutils package
* cleanup zabbix package
* use latest base image

## 20230721.0 - 2023-10-25

* switch to ubuntu 22.04
* use latest base image

## 20210413.6 - 2022-11-30

* migrate to postfix

## 20210413.5 - 2022-10-22

* change build hostname too
* fix exim config
* add apt-get-install wrapper
* move zabbix-sed into mdata-setup

## 20210413.4 - 2022-03-22

* load filebeats from own server
* fix update to latest
* ensure zabbix without PID file

## 20210413.3 - 2022-01-20

* add ps-cpu and -mem aliases
* limit systemd log file size
* add filebeats

## 20210413.2 - 2021-06-17

* increase system limits
* add fstab mount script
* include package for nfs mount
* set system-editor

## 20210413.1 - 2021-05-31

* include cron package
* fix zabbix config overwrite question

## 20210413.0 - 2022-05-03

* switch to ubuntu 20.04

## 20180404.6

* fix ntp error messages
* add noninteractive to update script

## 20180404.5

* revert to debian 9 for now
* fix locale-gen call
* add basic uptodate script
* add change-cert script

## 20200713.0

* switch to debian 10
* add dtrace tools

## 20180404.4

* add systemd health-check
* fix exim config
* remove nagios and munin
* add zabbix-agent

## 20180404.3

* include nagios-nrpe-server
* fix exim4 config
* add nrpe config

## 20180404.2

* export various vars
* add bootstrap service

## 20180404.1

* first lx-brand build
