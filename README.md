# Docker

## Installing docker on Ubuntu:
  Here are the steps to install Docker on a Ubuntu system:

  1. Remove existing packages (if any):
     ```
     for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
     ```
  2. Update Package Index:
     ```
     sudo apt-get update
     ```
  3. Install Dependencies:
     ```
     sudo apt-get install ca-certificates curl gnupg -y
     sudo install -m 0755 -d /etc/apt/keyrings
     ```
  4. Add Docker's official GPG key to ensure the integrity of the packages:
     ```
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
     sudo chmod a+r /etc/apt/keyrings/docker.gpg
     ```
  5. Set Up the Stable Docker Repository:
     ```
     echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     ```
  6. Update the package index once more to include the Docker repository:
     ```
     sudo apt-get update
     ```
  7. Install Docker Engine:
     ```
     sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
     ```
  8. Enable Docker Service Start to automatically start on boot.
     ```
     sudo systemctl enable --now docker
     ```
  9. Start Docker Service
     ```
     sudo service docker start
     ```
  10. Additionally check version of docker installed
      ```
      sudo docker version
      ```
  11. Verify Installation:
      ```
      sudo docker run hello-world
      ```

  That's it! You have successfully installed Docker on Ubuntu.

## Unstalling docker on Ubuntu:

     ```
     sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extra -y && sudo rm -rf /var/lib/docker && sudo rm -rf /var/lib/containerd
     ```
## Docker Basic Commands:

  These are some fundamental Docker commands to get started:

  1. Check Docker version installed:
     ```
     docker version
     ```
  2. Pull a Docker image:
     ```
     docker pull <directory(optional)/image_name>
     ```
  3. Run a Docker container:
     ```
     docker run <options> <image_name>
     ```
  4. List running docker containers:
     ```
     docker ps
     ```
  5. List all active / inactive containers:
     ```
     docker ps -a
     ```
  6. List all downloaded docker images:
     ```
     docker images
     ```
  7. Remove specific containers: (works only on inactive containers)
     ```
     docker rm <container_id> <container_id> <container_id> ...
     ```
  8. Remove active / inactive containers:
     ```
     docker kill <container_id> <container_id> <container_id> 
     ```
  9. Remove all containers at once:
     ```
     docker rm -f $(docker ps -a -q)
     ```
  10. Remove local docker images from device:
      ```
      docker rmi <image_name> <image_name>
      ```
  11. Remove all local docker images at once:
      ```
      docker image prune -a
      ```
  12. Remove all docker volumes at once:
      ```
      docker volume rm $(docker volume ls -q
      ```
  13. Stop a running docker container:
      ```
      docker stop <container_id>
      ```
  14. View logs of a container:
      ```
      docker logs <container_id>
      ```
  15. Execute a Command in a Running Container:
      ```
      docker exec -it <container_id> <command>
      ```
  16. List Docker netwoks:
      ```
      docker network ls
      ```
  17. Remove All Stopped Containers:
      ```
      docker container prune
      ```
  18. Remove All Unused Images:
      ```
      docker image prune
      ```
  19. Inspect docker container:
      ```
      docker inspect <container_id>
      ```

## Running apache2 inside docker:

  ### 1. Easiest method to import file from docker hub library using below command:
  
     ```
     sudo docker run -d --name <name> -e TZ=UTC -p 8080:80 -v /localpath/to/website:/var/www/html ubuntu/apache2
     ```
       - -d                       :runs the apache2 in background
       - name                     :give desired name to your container
       - -p                       :map localhost port to default apache2 port inside container
       - /localpath/to/website    :local index.html file to run on server
       - ubuntu/apache2           :image name on docker hub repository

  ### 2. Running apache2 inside docker with base Ubuntu OS:

  - Create new Dockerfile
       
       ```
       touch Dockerfile
       ```
       
  - Create new file index.html and paste your desired webpage html code
       
       ```
       touch index.html
       nano index.html
       ```
       
       ```
       <!-- index.html -->
       <!DOCTYPE html>
       <html>
       <head>
         <title>My Custom Webpage</title>
       </head>
       <body>
         <h1>Hello from My Personalised Webapage!</h1>
       </body>
       </html>
       ```
       
  - Edit Dockerfile to give commands:
       
       ```
       nano Dockerfile
       ```
       
       ```
       # Use Ubuntu as the base image
       FROM ubuntu

       # Install Apache2 and other dependencies
       RUN apt-get update && \
       apt-get install -y apache2 && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/*

       # Copy custom HTML file to Apache document root
       COPY index.html /var/www/html/
       # Expose port 80 for Apache
       EXPOSE 80

       # Start Apache in the foreground
       CMD ["apache2ctl", "-D", "FOREGROUND"]
       ```

  - Build the Docker image:
    
      ```
      docker build -t my-apache2 -f Dockerfile .
      ```

  - Run the Docker container:
    
      ```
      docker run -d --name apache2_ubuntu -p 80:80 my-apache2
      ```

  - Access the webpage:
      Open a web browser and navigate to http://localhost:80. You should see your custom webpage served by Apache.
      
  ### 3. Testing Example Voting App using docker:

  - Prerequisites:
      Install docker and git on ubuntu OS.

  - Architecture:
    - A front-end web app in Python which lets you vote between two options
    - A Redis which collects new votes
    - A .NET worker which consumes votes and stores them in…
    - A Postgres database backed by a Docker volume
    - A Node.js web app which shows the results of the voting in real time
   
      ![image](https://github.com/Agneshkastury/Docker/assets/154126091/2d37bc00-7354-42ad-8ee7-6c405c2a82b1)


  - Run below commands in sequence:
    
    ```
    git clone https://github.com/dockersamples/example-voting-app.git
    cd example-voting-app/vote
    docker build . -t vote
    cd .. && cd worker/
    docker build . -t worker
    cd .. && cd result/
    docker build . -t result
    docker pull redis
    docker pull postgres:9.5

    docker run -d --name=redis redis
    docker run -d --name=db -e POSTGRES_PASSWORD=password -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.5
    docker run -d --name=vote -p 5000:80 --link redis:redis vote
    docker run -d --name=result -p 5001:80 --link db:db result
    docker run -d --name=worker --link db:db --link redis:redis worker
    ```

  - Open a web browser and navigate to http://localhost:5000. You should see voting page and cast your vote.

    ![Screenshot (50)](https://github.com/Agneshkastury/Docker/assets/154126091/aa07210e-1651-4463-a681-156ac3e00c43)

  - Then open navigate to http://localhost:5001 to see the vote cast.

    ![Screenshot (51)](https://github.com/Agneshkastury/Docker/assets/154126091/4a5dcf58-42e1-44f4-a509-2c9e0b1f68b4)

  ### 3. Testing Example Voting App using docker-compose (version 1):
  - Prerequisites:
      Install docker-compose using following commands:
      ```
      apt-get update
      apt-get install docker-compose -y
      ```

  - Create and load docker-compose file:

    Create a file named docker-compose.yml in your project directory. This file defines the services, networks, and volumes for your application.
    
      ```
      touch docker-compose.yml
      nano docker-compose.yml
      ```
      
  - Add docker-compose code as under:
    
      ```
      redis:
        image: redis
      db:
        image: postgres:9.5
        restart: always
        environment: 
          POSTGRES_PASSWORD: mypass
          POSTGRES_HOST_AUTH_METHOD: trust
      vote:
        image: vote
        ports:
          - 5000:80
        links:
          - redis
      result:
        image: result
      ports:
        - 5001:80
      links:
        - db
      worker:
        image: worker
      links:
        - redis
        - db
      ```

  - Run Docker-compose:

    - Use the following command to start the services defined in your docker-compose.yml file:
    
      ```
      docker-compose up
      ```
    - Open a web browser and navigate to http://localhost:5000. You should see voting page and cast your vote.

      ![Screenshot (50)](https://github.com/Agneshkastury/Docker/assets/154126091/aa07210e-1651-4463-a681-156ac3e00c43)

    - Then open navigate to http://localhost:5001 to see the vote cast.

      ![Screenshot (51)](https://github.com/Agneshkastury/Docker/assets/154126091/4a5dcf58-42e1-44f4-a509-2c9e0b1f68b4)
    
  - Verify Running Containers by following command:
    
      ```
      docker-compose ps
      ```
    
  - Stop and Remove Containers:

    When you are done, you can stop and remove the containers using the following command:
    
      ```
      docker-compose down
      ```

   ### 3. Testing Example Voting App using docker-compose (version 3):

   - All process and commands remain same as version 1 only change is in docker-compose.yml code as under:
     
     - No need to specify links as it is done automatically in version 3 onwards.
     - Also, if the minor version 3.x is not specified it takes 3.0 by default not latest one.
     
     ```
     version: "3.8"
       services:
         redis:
          image: redis
         db:
          image: postgres:9.5
          restart: always
          environment:
            POSTGRES_USER: postgres 
            POSTGRES_PASSWORD: postgres
         vote:
          image: vote
          ports:
            - 5000:80
         result:
          image: result
          ports:
            - 5001:80
         worker:
            image: worker
     ```
  




































 
      
     
     
     


     
