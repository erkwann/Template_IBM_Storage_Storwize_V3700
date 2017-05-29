# Template_IBM_Storage_Storwize_V3700
Template IBM Storage Storwize V3700

original template
https://github.com/gghuber/Zabbix-Template-IBM-Storage-Storwize-V3700


i did correct this template and translate it into " english" (google trad)

first you have to create two repository /etc/zabbix/scripts and /etc/zabbix/scripts/repo

then put all the scripts into /etc/zabbix/scripts  and modify the file "discovery"
add userparameter
UserParameter=storwize.discovery[*],/etc/zabbix/scripts/ibmv3700_discovery.sh $1 $2
UserParameter=storwize.drive.stats[*],/etc/zabbix/scripts/ibmv3700_stats_drive.sh $1 $2 $3
UserParameter=storwize.volume.stats[*],/etc/zabbix/scripts/ibmv3700_stats_volume.sh $1 $2 $3
UserParameter=storwize.system.stats[*],/etc/zabbix/scripts/ibmv3700_stats_system.sh $1 $2 

!!! you have to install sshpass !!!

add the template and all will be ok !!

