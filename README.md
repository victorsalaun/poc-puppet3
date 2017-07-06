# POC Puppet 3

## Build docker

### centos7-systemd

    cd docker/centos7-systemd
    docker build -t victorsalaun/centos7-systemd .
    docker tag victorsalaun/centos7-systemd latest
    docker push victorsalaun/centos7-systemd

### puppet-master
    
    cd docker/puppet-master
    docker build -t victorsalaun/puppet-master .
    docker tag victorsalaun/puppet-master latest
    docker push victorsalaun/puppet-master
   
### puppet-agent

    cd docker/puppet-agent
    docker build -t victorsalaun/puppet-agent .
    docker tag victorsalaun/puppet-agent latest
    docker push victorsalaun/puppet-agent
     
## Launching

    docker-compose up -d
    
    docker exec pocpuppet3_repo_1 /opt/puppet-agent.sh
    docker exec pocpuppet3_repo_1 /usr/bin/createrepo /opt/repo
    
    docker run -h app.docker --rm --cap-add=SYS_ADMIN --name puppet_test_1 -p 3000:3000 -h app1.docker -e FACTER_environment="dev" --link pocpuppet3_master_1 --link pocpuppet3_repo_1 --network pocpuppet3_default victorsalaun/puppet-agent
    
    docker exec puppet_test_1 puppet agent -t