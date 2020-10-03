resource "aws_key_pair" "mykey"{
	key_name = "mykey"
	public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example"{
	ami = var.AMIS[var.AWS_REGION]
	instance_type = "t2.micro"
	
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
	
	provisioner "remote-exec" {
  	 	 inline = [
				"ll /tmp",
				"sed -i '1s/^.*#//;s/\r$//' /tmp/script.sh",
      			"chmod +x /tmp/script.sh",
				"cd /tmp",
      			"sudo ./script.sh",
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


output "ip"{
	value = aws_instance.example.public_ip
}
