variable "AWS_ACCESS_KEY"{
}

variable "AWS_SECRET_KEY"{
}

variable "AWS_REGION"{
}

variable "AMIS"{
 type = map(string)
 default = {
  eu-west-2 = "ami-0ebb4b3e90d89aca4"
 }
}

variable "PATH_TO_PRIVATE_KEY"{
	default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY"{
	default = "mykey.pub"
}

#variable "AMIS"{
#  type = map(string)
#  default = {
#	ap-south-1 = "ami-04d8d4462ae1ae813"
#	}
#}

variable "INSTANCE_USERNAME"{
	default = "ubuntu"
}
