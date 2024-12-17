resource "aws_instance" "volume_practice" {
  
  instance_type          = "t2.large"
  vpc_security_group_ids = ["sg-0981de3d2b9d286ab"]
  # convert StringList to list and get first element
  subnet_id = "subnet-0d681bd461742fc1a"
  ami = data.aws_ami.ami_info.id
  availability_zone = element(local.azs, 0)
  user_data = file("jenkins-agent.sh")
  root_block_device {
    volume_size = 50
  }
  tags = {
    Name = "jenkins-agent"
  }
}