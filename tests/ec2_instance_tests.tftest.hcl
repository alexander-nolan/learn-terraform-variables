# tests/ec2_instance_tests.tftest.hcl

mock_provider "aws" {}

override_data {
  target = data.aws_availability_zones.available
  values = {
    names = ["us-west-1a", "us-west-1b", "us-west-1c"]
  }
}

variables {
  instance_count = 2
  instance_type  = "t2.micro"
}

run "test_ec2_instance_count" {
  command = plan
  
  assert {
    condition     = length(module.ec2_instances.instance_ids) == 2
    error_message = "Should create exactly 2 EC2 instances"
  }
}