resource "aws_key_pair" "mykey"{
	key_name = "mykey"
	public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example"{
	ami = var.AMIS[var.AWS_REGION]
	instance_type = "t2.micro"
	root_block_device {
		delete_on_termination = true
	}
	
	# VPC subnet for public ip1
	subnet_id = "${aws_subnet.main-public-1.id}"

	# Configure Security Group
	vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
	
	key_name = aws_key_pair.mykey.key_name

	tags = {
	 	name = "Terraform Example"
	}

	provisioner "file"{
		source 		= "script.sh"
		destination 	= "/tmp/script.sh"
	}

	provisioner "file"{
		source 		= ".env"
		destination 	= "/tmp/.env"
	}

	provisioner "file"{
		source 		= "docker-compose.yaml"
		destination 	= "/tmp/docker-compose.yaml"
	}
	
	provisioner "remote-exec" {
    inline = [
      	"ll /tmp",
		"sed -i '1s/^.*#//;s/\r$//' /tmp/script.sh",
      	"chmod +x /tmp/script.sh",
		"cd /tmp",
      	"sudo bash script.sh",
		"sudo mkdir airflow",
		# "cd airflow",
		# "mkdir ./dags ./logs ./plugins",
		# "sudo mv /tmp/docker-compose.yaml .",
		# "sudo apt-get remove -y docker-compose",
		# "sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose",
		# "sudo apt-get update",
		# "sudo chmod +x /usr/local/bin/docker-compose",
		# "sudo mv /usr/local/bin/docker-compose /usr/bin",
		# "cd /tmp/airflow",
		"docker-compose up",
    ]
  	}

	#provisioner "local-exec"{
	#	command = "echo ${aws_instance.example.private_ip} >> private_ip.txt"
	#}


	connection {
		host 		= coalesce(self.public_ip, self.private_ip)
		type		= "ssh"
		user		= var.INSTANCE_USERNAME
		private_key	= file(var.PATH_TO_PRIVATE_KEY)
	}
}

resource "aws_ebs_volume" "ebs-volume-1" {
	availability_zone = "${aws_subnet.main-public-1.availability_zone}"
  	size              = 20
	type = "gp2"
	tags = {
    	Name = "extra volume"
  	}
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  	device_name = "/dev/xvdh"
  	volume_id   = aws_ebs_volume.ebs-volume-1.id
  	instance_id = aws_instance.example.id
	force_detach = true

}

output "ip"{
	value = aws_instance.example.public_ip
	description = "Pubic Ip of EC2 instance"
}

output "hostname"{
	value = aws_instance.example.public_dns
	description = "Hostname of the EC2 instance where nginx is installed"
}

output "private_dns"{
	value = aws_instance.example.private_dns
	description = "Private DNS name"
}
