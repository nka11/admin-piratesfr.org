#!/bin/bash

. "conf.sh"

DATE="$(date +%Y/%m/%d)"

rrdtool update ${SCRIPTS_DIR}/rrd/loadavg.rrd `awk '{printf "N:%s:%s:%s",$1,$2,$3}' /proc/loadavg` 

rrdtool graph -w 800 -h 260 -a PNG ${GRAPHS_DIR}/load.png \
	--title="Charge serveur quotidienne / PiratesFr.org (${DATE})" \
	DEF:avg1=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg1:AVERAGE \
	DEF:avg5=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg5:AVERAGE \
	DEF:avg15=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg15:AVERAGE \
	AREA:avg1#00FF00:"avg 1" \
	LINE1:avg1#000000 \
	GPRINT:avg1:MIN:"Min\: %lf%s" \
	GPRINT:avg1:AVERAGE:"Avg\: %lf%s" \
	GPRINT:avg1:MAX:"Max\: %lf%s" \
	GPRINT:avg1:LAST:"Last\: %lf%s" > /dev/null

rrdtool graph -w 800 -h 260 -a PNG ${GRAPHS_DIR}/load-week.png \
	--start -604800 --title="Charge serveur hebdomadaire / PiratesFr.org (${DATE})" \
	DEF:avg1=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg1:AVERAGE \
	DEF:avg5=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg5:AVERAGE \
	DEF:avg15=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg15:AVERAGE \
	AREA:avg1#00FF00:"avg 1" \
	LINE1:avg1#000000 \
	GPRINT:avg1:MIN:"Min\: %lf%s" \
	GPRINT:avg1:AVERAGE:"Avg\: %lf%s" \
	GPRINT:avg1:MAX:"Max\: %lf%s" \
	GPRINT:avg1:LAST:"Last\: %lf%s" > /dev/null

rrdtool graph -w 800 -h 260 -a PNG ${GRAPHS_DIR}/load-month.png \
	--start -2678400 --title="Charge serveur mensuelle / PiratesFr.org (${DATE})" \
	DEF:avg1=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg1:AVERAGE \
	DEF:avg5=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg5:AVERAGE \
	DEF:avg15=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg15:AVERAGE \
	AREA:avg1#00FF00:"avg 1" \
	LINE1:avg1#000000 \
	GPRINT:avg1:MIN:"Min\: %lf%s" \
	GPRINT:avg1:AVERAGE:"Avg\: %lf%s" \
	GPRINT:avg1:MAX:"Max\: %lf%s" \
	GPRINT:avg1:LAST:"Last\: %lf%s" > /dev/null

rrdtool graph -w 800 -h 260 -a PNG ${GRAPHS_DIR}/load-yearly.png \
	--start -32140800 --title="Charge serveur annuelle / PiratesFr.org (${DATE})" -u 5  -r \
	DEF:avg1=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg1:AVERAGE \
	DEF:avg5=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg5:AVERAGE \
	DEF:avg15=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg15:AVERAGE \
	AREA:avg1#00FF00:"avg 1" \
	LINE1:avg1#000000 \
	GPRINT:avg1:MIN:"Min\: %lf%s" \
	GPRINT:avg1:AVERAGE:"Avg\: %lf%s" \
	GPRINT:avg1:MAX:"Max\: %lf%s" \
	GPRINT:avg1:LAST:"Last\: %lf%s" > /dev/null

rrdtool graph -w 800 -h 260 -a PNG ${GRAPHS_DIR}/load-semestre.png \
	--start -16070400 --title="Charge serveur semestrielle / PiratesFr.org (${DATE})" \
	DEF:avg1=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg1:AVERAGE \
	DEF:avg5=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg5:AVERAGE \
	DEF:avg15=${SCRIPTS_DIR}/rrd/loadavg.rrd:avg15:AVERAGE \
	AREA:avg1#00FF00:"avg 1" \
	LINE1:avg1#000000 \
	GPRINT:avg1:MIN:"Min\: %lf%s" \
	GPRINT:avg1:AVERAGE:"Avg\: %lf%s" \
	GPRINT:avg1:MAX:"Max\: %lf%s" \
	GPRINT:avg1:LAST:"Last\: %lf%s" > /dev/null

# Reseau
rrdtool update ${SCRIPTS_DIR}/rrd/network-eth2.rrd `sed '/eth0/!d;s%eth0:%%' /proc/net/dev|awk '{printf "N:%s:%s",$1,$9}'`

# Daily Graph
rrdtool graph ${GRAPHS_DIR}/network-eth2-day.png --start -86400 \
	--title="Stats reseau PiratesFr.org (${DATE})" -v "bits" -a PNG -u=512000 \
	DEF:inoctets=${SCRIPTS_DIR}/rrd/network-eth2.rrd:input:AVERAGE \
	DEF:outoctets=${SCRIPTS_DIR}/rrd/network-eth2.rrd:output:AVERAGE \
	CDEF:a=inoctets,8,* \
	CDEF:b=outoctets,8,* \
	AREA:b#00FF00:"Trafic sortant en bits" \
	LINE1:b#000000 \
	GPRINT:b:AVERAGE:"Moy\: %.2lf%s" \
	GPRINT:b:MAX:"Max\: %.2lf%s" \
	GPRINT:b:LAST:"Dernier\: %.2lf%s" \
	AREA:a#FF0000:"Trafic entrant en bits" \
	LINE1:a#000000 \
	GPRINT:a:AVERAGE:"Moy\: %.2lf%s" \
	GPRINT:a:MAX:"Max\: %.2lf%s" \
	GPRINT:a:LAST:"Dernier\: %.2lf%s" \
	HRULE:128000#FF0000 \
	HRULE:256000#FF0000 \
	HRULE:384000#FF0000 \
	HRULE:512000#FF0000 \
	-w 800 -h 260 > /dev/null

#Memoire
rrdtool update ${SCRIPTS_DIR}/rrd/meminfo.rrd `free -m|sed '/^Mem:/!d;s%Mem:%%'|awk '{printf "N:%s:%s:%s:%s:%s",$2,$3,$4,$5,$6}'`

# Daily Graph
rrdtool graph ${GRAPHS_DIR}/meminfo.png --start -86400 \
	--title="Stats memoire PiratesFr.org (${DATE})" -v "MiB" -a PNG  \
	DEF:used=${SCRIPTS_DIR}/rrd/meminfo.rrd:used:AVERAGE \
	DEF:free=${SCRIPTS_DIR}/rrd/meminfo.rrd:free:AVERAGE \
	DEF:shared=${SCRIPTS_DIR}/rrd/meminfo.rrd:shared:AVERAGE \
	DEF:buffers=${SCRIPTS_DIR}/rrd/meminfo.rrd:buffers:AVERAGE \
	DEF:cached=${SCRIPTS_DIR}/rrd/meminfo.rrd:cached:AVERAGE \
	AREA:used#F0FF00:"Used" \
	LINE1:used#000000 \
	AREA:free#FF00F0:"Free" \
	LINE1:free#000000 \
	AREA:buffers#0FF000:"Buffers" \
	AREA:cached#0F0000:"Cached" \
	LINE1:cached#000000 \
	LINE1:buffers#FFFFFF \
	AREA:shared#F00000:"Shared" \
	LINE1:shared#000000 \
	-w 800 -h 260 > /dev/null
