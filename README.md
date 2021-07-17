# Minecraft server

## Information

We run the minecraft server on a m6g.large spot instance on Amazon EC2, at the time of writing it costs $0.0346/hr. Configuring the DNS (for changing IPs) is done through Route 53 and a launch script.

## Creating the Launch Template
*Creating the EFS*: Go to the Elastic File System dashboard and click on "Create file system". After it has been created, note down the file system ID.

*Creating the AMI:* Create an EC2 instance. Install `amazon-efs-utils` if not on Amazon Linux 2 and run `mkdir /mnt/efs` to create a mounting point for the EFS drive. Then install java 16 with `apt install openjdk-16-jre-headless`. 

*Getting Minecraft running:* Attach the EFS drive with `mount -t efs -o tls fs-...:/ /mnt/efs`, where you fill in the dots with your file system ID. Then save [PaperMC server](https://papermc.io/) to `/mnt/efs/minecraft_server/` as `paper.jar` and try running it. To switch between different Minecraft worlds you can create a symbolic link (shortcut, created with `ln -s destination source`) to the one you want to play on. E.g. this is what our drive looks like: 

```
├── minecraft_server -> minecraft_server-1.17.1-amplified
├── minecraft_server-1.16.5
├── minecraft_server-1.16.5-manhunt
└── minecraft_server-1.17.1-amplified
```
*Route 53:* Note down the hosted zone ID in Route 53. Create an A record, the IP does not matter.
Make sure the [change resource](./change-resource-record-sets.json) file is placed at `/mnt/efs/change-resource-record-sets.json`.

*Creating the launch template:* Create the launch template in EC2 by right clicking on your instance: Image and templates → Create template from instance, and provide the [user data script](./user_data.sh) with file system and hosted zone IDs filled in.

## Todo's

- Figure out how to connect to changing IPs with ssh.
- Instead of `screen`, configure `systemctl` to launch the Minecraft server.