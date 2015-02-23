@rem start queue manager
set PATH=%PATH%;"C:\Program Files (x86)\IBM\WebSphere MQ\bin"
@rem strmqm IB9QMGR

 call mqsicreatebroker TESTNODE_John
 call mqsistart TESTNODE_John
 call mqsicreateexecutiongroup TESTNODE_John -e default

@rem set up environment for SAP nodes
call mqsichangeproperties TESTNODE_John -c EISProviders -o SAP -n nativeLibs,jarsURL -v "C:\John\sapjco3\308\64","C:\John\sapjco3\308\64"
call mqsisetdbparms TESTNODE_John -n MQTT::iotFoundation -u "a-3siysh-fiux9wzyex" -p "bftwcV9@*TZy(iwF)1"
mkdir C:\ProgramData\IBM\MQSI\components\TESTNODE_John\policies\docs\MQTTSubscribe
mkdir C:\ProgramData\IBM\MQSI\components\TESTNODE_John\policies\docs\MQTTPublish
cp ..\policy\InternalBroker.policy C:\ProgramData\IBM\MQSI\components\TESTNODE_John\policies\docs\MQTTPublish\InternalBroker
cp ..\policy\BusEvents.policy C:\ProgramData\IBM\MQSI\components\TESTNODE_John\policies\docs\MQTTSubscribe\BusEvents
mqsichangeproperties TESTNODE_John -b pubsub -o BusinessEvents/MQTT -n policyUrl -v /MQTTPublish/InternalBroker.policy
call mqsistop TESTNODE_John
call mqsistart TESTNODE_John
call mqsichangeresourcestats TESTNODE_John -e default -c active
@rem build bar file
mkdir output
call mqsipackagebar -a output\demo.bar -w ..\ad -y VehicleMaintenance -k PredictiveMaintenance
call mqsideploy -a output\demo.bar TESTNODE_John -e default
@rem activate flow monitoring
call mqsichangeflowmonitoring TESTNODE_John -e default -c active -j -k PredictiveMaintenance


@rem deploy policy
@rem mqsicreatepolicy TESTNODE_John -t MQTTSubscribe -f ..\policy\BusEvents.policy -l BusEvents
@rem mqsichangeproperties TESTNODE_John -e default -o ComIbmJVMManager -n jvmDebugPort -v 1818
