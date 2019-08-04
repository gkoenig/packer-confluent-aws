#cloud-config
repo_update: true
repo_upgrade: all

write_files:
    - content: |
        #!/bin/bash
        cd /opt/ansible
        ansible-playbook cloudinit-zookeeper.yml -v 
      path: /usr/local/bin/setup_zk.sh
      permissions: '0755'
runcmd:
    - /usr/local/bin/setup_zk.sh      