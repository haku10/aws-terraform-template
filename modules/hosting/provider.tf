terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws, aws.east]
    }
  }
}
