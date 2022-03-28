# https://docs.datafabric.hpe.com/62/AdministratorGuide/ShutDownCluster.html

## Listing all servises
/opt/mapr/bin/maprcli node list -filter "[rp==/*]and[svc==nfs]" -columns id,h,hn,svc,rp
/opt/mapr/bin/maprcli node list -filter "[rp==/*]and[svc==nfs4]" -columns id,h,hn,svc,rp

## Shutting down nfs
/opt/mapr/bin/maprcli node services -nfs stop -filter [svc=="nfs"]
/opt/mapr/bin/maprcli node services -nfs4 stop -filter [svc=="nfs4"]

## Shuting down ecosystem servises
maprcli node services -name drill-bits -filter [svc=="drill-bits"] -action stop
maprcli node services -name fileserver -filter [svc=="fileserver"] -action stop
maprcli node services -name resourcemanager -filter [svc=="resourcemanager"] -action stop
maprcli node services -name historyserver -filter [svc=="historyserver"] -action stop
maprcli node services -name nodemanager -filter [svc=="nodemanager"] -action stop

## Shutting down RM and NM
maprcli node services -name resourcemanager -filter <filter> -action stop
maprcli node services -name nodemanager -nodes <node> -action stop
