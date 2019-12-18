# seedbox-automation
Repository for box side automation code


## Playbook: [dsa_setup.yml](dsa_setup.yml)
> **Description:** This is playbook for deploying KVM, creating Partition and installing DSA components. Playbook will run ansible test cases after# every role execution for verifying deployment of dsa components.


## Playbook: [dsa_setup_on_dbvm.yml](dsa_setup_on_dbvm.yml)
> **Description:** This is playbook for installing DSA components on database VM. Playbook will run ansible test cases after every role execution for verifying deployment of dsa components.

## Role: [test_tdrest](test_tdrest)
> **Description:** Following task will check TDrest service package installation and service status

> **Task:** Check tdrest is installed or not

> **Task:** Role=test_TDREST | Task=TDREST Test Case | Description=Verify TDRest service installation

> **Task:** check TDRest status

> **Task:** Role=test_TDREST | Task=TDREST Test Case | Description=Verify tdrestd service status


## Role: [barcmd](barcmd)
> **Description:** Following task will install barcmdline package

> **Task:** install BarCmdLine package


## Role: [diskpartition](diskpartition)
> **Description:** Following tasks will create partition on seedbox. It will download all required Qcow images on Seedbox.


## Role: [tdrest](tdrest)
> **Description:** Following task will get the TD rest package path and It will install TD Rest package

> **Task:** get the tdrest pkg path

> **Task:** install the tdrest pkg


## Role: [test_common](test_common)
> **Description:** Following task will check whether tdactivemq and JDK package is installed or not

> **Task:** Check tdactivemq status

> **Task:** Role=test_common | Task=TDActivemq Test Case | Description=Verify tdactivemq service status

> **Task:** Check JDK status

> **Task:** Role=test_common | Task=JDK Test Case | Description=Verify TD JDK installation


## Role: [common](common)
> **Description:** Following tasks will download dsa.tar.gz file. It will also install prerequisites like TD Jdk and TD ActiveMQ

> **Task:** download the dsa package

> **Task:** install prerequisities for dsa


## Role: [kvm](kvm)
> **Description:** Following task will prepare prerequisites required for KVM vm's and It will start KVM vm's from downloaded Qcow2 images.

> **Task:** Configure prerequisites required for starting KVM vm's

> **Task:** Start vms from qcow2 images


## Role: [test_kvm](test_kvm)
> **Description:** Following tasks will check for KVM package installation and it's service status. It will also check for KVM vm's status and static IP assignment.

> **Task:** check libvirtd status

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify Libvirt service status

> **Task:** Check virsh status

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify virsh cli tool functionality

> **Task:** Check default network status

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify libvirt default network status

> **Task:** Check dsc repository vm status

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify dsc repository VM status

> **Task:** Check viewpoint vm status

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify Viewpoint vm status

> **Task:** Check dsc repository Static IP accessibility

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify dsc repository Static IP accessibility

> **Task:** Check viewpoint Static IP accessibility

> **Task:** Role=test_kvm | Task=KVM Test Case | Description=Verify viewpoint Static IP accessibility


## Role: [test_barcmd](test_barcmd)
> **Description:** Following task will check whether barcmd package is installed or not

> **Task:** Check barcmd is installed or not

> **Task:** Role=test_BarCmd | Task=BarCmd Test Case | Description=Verify BARCmdline service installation


## Role: [clienthandler](clienthandler)
> **Description:** Following task will install clienthandler package

> **Task:** install the clienthandler


## Role: [test_db](test_db)
> **Description:** Following tasks will check database service status

> **Task:** make database box as passwordless/copy private-key

> **Task:** check database status

> **Task:** DSC Test case- Verify database service


## Role: [uninstallPackages](uninstallPackages)
> **Task:** download python xml package

> **Task:** install python-xml dependecy

> **Task:** Check tdactivemq is installed or not

> **Task:** remove tdactivemq package

> **Task:** Check teradata-jdk7 is installed or not

> **Task:** remove teradata-jdk7 package

> **Task:** Check ClientHandler is installed or not

> **Task:** remove clienthandler package

> **Task:** Check BARCmdline is installed or not

> **Task:** remove BARCmdline package

> **Task:** Check BARPortlets is installed or not

> **Task:** remove BARPortlets package

> **Task:** Check DSC is installed or not

> **Task:** remove DSC package

> **Task:** Check TDRest is installed or not

> **Task:** remove Tdrestd package


## Role: [test](test)
> **Task:** check bynet status

> **Task:** BYNET Test case- Verify bynet service


## Role: [test_dsc](test_dsc)
> **Description:** Following task will check DSC service package installation and service status

> **Task:** Check DSC Service installation

> **Task:** Role=test_dsc | Task=DSC Test Case | Description=Verify dsc service installation

> **Task:** Check dsc service status

> **Task:** Role=test_dsc | Task=DSC Test Case | Description=Verify dsc service status


## Role: [dsa_repo](dsa_repo)
> **Description:** Following task will add provided URL in zypper repository

> **Task:** add ftp zypper repo


## Role: [dsc](dsc)
> **Description:** Following task will install DSC service on seedbox

> **Task:** include credential file

> **Task:** Install the DSC


## Role: [test_clienthandler](test_clienthandler)
> **Description:** Following task will check for clienthandler package installation and clienthandler service status

> **Task:** Check clienthandler is installed or not

> **Task:** Role=test_clienthandler | Task=Clienthandler Test Case | Description=Verify clienthandler service installation

> **Task:** Check clienthandler service status

> **Task:** Role=test_clienthandler | Task=Clienthandler Test Case | Description=Verify Clienthandler service status


## Role: [test_diskpartition](test_diskpartition)
> **Description:** Following tasks will check for partition size, partition file system, partition name. It will also verify size of downloaded Qcow2 images.

> **Task:** Role=test_DiskPartion | Task=DiskPartion Test Case | Description=Verify partition name

> **Task:** Role=test_DiskPartion | Task=DiskPartion Test Case | Description=Verify partition File type

> **Task:** check no. of partitions

> **Task:** Role=test_DiskPartion | Task=DiskPartion Test Case | Description=Verify no of paritions

> **Task:** get the partition Path

> **Task:** Role=test_DiskPartion | Task=DiskPartion Test Case | Description=Verify partition path

> **Task:** get size of db qcow2 file disk1

> **Task:** get size of db qcow2 file disk2

> **Task:** get size of db qcow2 file disk3

> **Task:** get size of vp qcow2 file disk1

> **Task:** get size of vp qcow2 file disk2


## Role: [dbstart](dbstart)
> **Description:** Following tasks will copy private key on Database VM. Using Ssh login , ansible will start Database service.

> **Task:** copy private-key

> **Task:** start db service

> **Task:** pause of 120 seconds for database service to be running
