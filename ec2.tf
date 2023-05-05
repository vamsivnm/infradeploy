resource "aws_instance" "web" {
  ami           = "ami-0b0f111b5dcb2800f"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0a915e7fd1f6f0a12"]
  key_name = "newkeypair"
  
  connection {
    host        = "${self.public_ip}"
    user        = "ec2-user"
    type        = "ssh"
    private_key = "${file("/root/newkeypair")}"
  }
   

   provisioner "file" {
     source      = "/root/newkeypair"
     destination = "/home/ec2-user/newkeypair"

    connection {
      host        = "${self.public_ip}"
      user        = "ec2-user"
      type        = "ssh"
      private_key = "${file("/root/newkeypair")}"
     }
   }

   provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/newkeypair",
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "sudo yum install java-1.8.0-openjdk -y",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/root/newkeypair > /etc/ansible/hosts"
  }
  

  tags = {
    Name = "HelloWorld"
  }
}
