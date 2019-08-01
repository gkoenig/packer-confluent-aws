write_files:
    - content: |
        #!/bin/bash
        cd /opt/ansible
        ansible-playbook -i localhost cloudinit-kafka.yml -v --extra-vars "{\"ZK_IDS\":[$$(for i in {1..${zookeeper_count}}; do printf $$i; done)]"
        path: /usr/local/bin/setup_kafka.sh
      permissions: '0755'
runcmd:
    - /usr/local/bin/setup_kafka.sh 