#!/bin/bash
echo "start 6380"
/usr1/bin/knbs-redis/redis-6.2.7/src/redis-server /usr1/bin/knbs-redis/cluster/cluster-6380/redis-6380.conf &
echo "start 6381"
/usr1/bin/knbs-redis/redis-6.2.7/src/redis-server /usr1/bin/knbs-redis/cluster/cluster-6381/redis-6381.conf &
echo "start end"
