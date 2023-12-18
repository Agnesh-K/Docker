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

     
