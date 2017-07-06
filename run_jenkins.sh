
#!/usr/bin/env bash

docker-compose up -d
docker exec pocpuppet3_repo_1 /opt/puppet-agent.sh
docker exec pocpuppet3_repo_1 /usr/bin/createrepo /opt/repo

# Test
EXIT=0
for env in dev prod
do
    echo "Launch container"
    docker run -h app1.docker.$env -d --cap-add=SYS_ADMIN --name puppet_test_1 -e FACTER_environment="${env}" --link pocpuppet3_master_1 --link pocpuppet3_repo_1 --network pocpuppet3_default victorsalaun/puppet-agent
    echo "Execute puppet"
    docker exec puppet_test_1 puppet agent -t
    RETURN=$?
    if [ $RETURN -ne 2 ] && [ $RETURN -ne 0 ]
    then
    	echo "Fail in puppet run ${env}."
    	EXIT=1
    else
        echo "Success in puppet run ${env}."
    fi
    echo "Stop container"
    docker stop puppet_test_1
    echo "Rm container"
    docker rm -v puppet_test_1
done