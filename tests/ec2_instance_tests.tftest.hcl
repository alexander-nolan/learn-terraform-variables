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

run "validate_ec2_instance_tags" {
  command = plan

  variables {
    instance_count = 2
    instance_type  = "t2.micro"
    subnet_ids     = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-12345"]
    tags = {
      environment = "dev"
    }
  }

  # Test that instances have project tag
  assert {
    condition     = alltrue([for instance in aws_instance.app : contains(keys(instance.tags), "project")])
    error_message = "All EC2 instances must have project tag"
  }
}