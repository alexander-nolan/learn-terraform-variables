# tests/variable_validation_tests.tftest.hcl
mock_provider "aws" {}

override_data {
  target = data.aws_availability_zones.available
  values = {
    names = ["us-west-1a", "us-west-1b", "us-west-1c"]
  }
}

run "test_valid_instance_count" {
  command = plan
  
  variables {
    instance_count = 3
    instance_type  = "t2.small"
  }
}