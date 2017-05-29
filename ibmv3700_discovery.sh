#!/bin/bash


USER='ruser'
PASSWORD='Password'
SSHCMD='sshpass -p '$PASSWORD' ssh'
REPODIR=/etc/zabbix/scripts/repo
STORWIZEADDR='IP'

system (){
        $SSHCMD $USER@$STORWIZEADDR "svcinfo lssystem; svcinfo lssystemstats; svcinfo lsenclosure" > ${REPODIR}/${STORWIZEADDR}.system.repo.tmp && mv ${REPODIR}/${STORWIZEADDR}.system.repo.tmp ${REPODIR}/${STORWIZEADDR}.system.repo

        echo "{
	       \"data\":[

                {
                        \"{#STORWIZEADDR}\":\"${STORWIZEADDR}\"}]}"
}

drive (){
        ${SSHCMD} $USER@${STORWIZEADDR} "svcinfo lsdrive" > ${REPODIR}/${STORWIZEADDR}.drive.repo.tmp && mv ${REPODIR}/${STORWIZEADDR}.drive.repo.tmp ${REPODIR}/${STORWIZEADDR}.drive.repo

	echo "{
	        \"data\":[
	                " > ${REPODIR}/${STORWIZEADDR}.drive.tmp

	        for DRIVE in $(awk -F ' ' '{if (NR!=1) {print $1}}' ${REPODIR}/${STORWIZEADDR}.drive.repo)
		do
	       	    echo "                  	{\"{#SLOTID}\":"\"${DRIVE}"\",\"{#STORWIZEADDR}\":"\"${STORWIZEADDR}"\"}," >> ${REPODIR}/${STORWIZEADDR}.drive.tmp
			done
		cat ${REPODIR}/${STORWIZEADDR}.drive.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${STORWIZEADDR}.drive.tmp
}

volume (){
	${SSHCMD} $USER@${STORWIZEADDR} "svcinfo lsvdisk" > ${REPODIR}/${STORWIZEADDR}.volume.repo.tmp &&  mv ${REPODIR}/${STORWIZEADDR}.volume.repo.tmp ${REPODIR}/${STORWIZEADDR}.volume.repo

        echo "{
                \"data\":[
                        " > ${REPODIR}/${STORWIZEADDR}.volume.tmp

                for VOLUME in $(awk -F ' ' '{if (NR!=1) {print $2}}' ${REPODIR}/${STORWIZEADDR}.volume.repo );
                do
                        echo "                          {\"{#VOLNAME}\":"\"${VOLUME}"\",\"{#STORWIZEADDR}\":"\"${STORWIZEADDR}"\"}," >> ${REPODIR}/${STORWIZEADDR}.volume.tmp
                done
                cat ${REPODIR}/${STORWIZEADDR}.volume.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${STORWIZEADDR}.volume.tmp
}


if [[ "$2" == "drive" || "$2" == "system" || "$2" == "volume" ]]; then
	$2
fi
