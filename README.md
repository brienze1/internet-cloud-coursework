# Concept to prove:

![img_1.png](img_1.png)

1. What was done
    1. Created docker-compose file with different containers (aka "machines")
        1. 2 containers running kubernetes (used rancher here because it's the only one with docker support), they will
           contain the deployed applications (rancher1 and rancher2)
        2. 1 container running a load balancer to balance the load between the two kubernetes, turning the two
           kubernetes instances into 1 for the client (nginx)
        3. 1 container to run DB (postgres) (commented for now, not being used yet)
        4. 1 container to run commands to deploy/wire everything, the commands are stored inside the
           ./build/rancher/entrypoint.sh file, basically it awaits the ranchers to finish initialization and run a chain
           of commands to deploy, expose and scale the pods (rancher-cli)
    2. The static-site used as prof of concept is available at http://localhost:80 (exposed by nginx container)
    3. The application containers deployed can be seen at https://localhost:441 (exposed by rancher1)
       and https://localhost:442 (exposed by rancher2)
        1. The username and password to access the rancher clusters is admin/password respectively
        2. When connected the pods can be visualized at https://localhost:<port>/dashboard/c/local/explorer/pod
        3. They can also be scaled up/down at https://localhost:<port>
           /dashboard/c/local/explorer/apps.deployment/default/static-site#pods
2. Pre-requisites:
    1. Have docker and docker-compose installed
3. How to run it:
    1. Start
        1. docker-compose -f build/docker-compose.yaml up
    2. Stop
        1. docker-compose -f build/docker-compose.yaml down --volumes

Obs: I used an M2 mac to run everything, and I encountered some problems when running the rancher-cli image, there might
be needed some extra configuration if Intel processors are used to change the `select(.|test(".+linux-arm.+xz"))`
command to something compatible with intel. (I think changing arm to amd will fix it, but didn't test it out)