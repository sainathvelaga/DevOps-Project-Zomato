module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-tf"

  instance_type          = "t2.small"
  vpc_security_group_ids = ["sg-0981de3d2b9d286ab"] #replace your SG
  subnet_id = "subnet-0d681bd461742fc1a" #replace your Subnet
  ami = data.aws_ami.ami_info.id
  create_spot_instance = "true"
  user_data = file("jenkins.sh")
  tags = {
    Name = "jenkins-tf"
  }
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type          = "t2.large"
  vpc_security_group_ids = ["sg-0981de3d2b9d286ab"]
  # convert StringList to list and get first element
  subnet_id = "subnet-0d681bd461742fc1a"
  ami = data.aws_ami.ami_info.id
  create_spot_instance = "true"
  user_data = file("jenkins-agent.sh")
  tags = {
    Name = "jenkins-agent"
  }
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
      allow_overwrite = true
    }
    
  ]

}