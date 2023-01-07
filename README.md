# Deployment of a containerized e-commerce web application to ECS

## Including: Full CI/CD pipeline with Terraform blue/green deployment strategy

<br>

### Introduction

Source code was obtained from KodeKloud which is a PHP based ecommerce sample web application which can be found on github [here](https://github.com/kodekloudhub/learning-app-ecommerce).

<br>

### Project TODOs

1. Parameterize ECR repository names and S3 buckets names for better project flexibility.
2. Add Route 53 DNS configuration. ALB DNS name is used.
3. Add configuration for SSL cert for HTTPS, port 80/http is currently used.

<br>

### Technologies Used

1. Docker/Dockerhub/docker-compose
2. Terraform Open Source
3. CircleCI - CI/CD
4. ElasticContainerService on AWS

<br>

### Project Structure

| File/Dir Name         | Description                                          |
|-----------------------|------------------------------------------------------|
| assets/               | Supporting Backend db scripts                        |
| css/                  | css files for front end                              |
| db/                   | Contains the backend Dockerfile and bootstrap        |
| docker-compose.yml    | docker-compose file for local testing only           |
| Dockerfile            | Application Dockerfile for frontend                  |
| docs/                 | Supporting documentation for running the application |
| fonts/                | Supporting files for frontend website                |
| img/                  | Supporting images for frontend website               |
| index.php             | Front page for ecommerce website                     |
| js/                   | Supporting Javascript                                |
| README.md             | README.md file                                       |
| scss/                 | Supporting files for frontend website                |
| tf/                   | Directory containing terraform configuration         |
| vendors/              | Supporting files for frontend website                |
|                       |                                                      |

<br>

### Blue/Green Deployment Strategy and CI/CD

![AWS Blue Green Deployment](/docs/terraform-blue-green.png)

This project uses Terraform to deploy a containerized application to ECS on AWS using a blue/green deployment strategy. This can be achieved by using feature toggles on the application load balancer listener like so:


```
resource "aws_alb_listener" "ecomm_listener_http" {
  load_balancer_arn = aws_alb.ecomm_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    # By passing "green", "blue-90" as the traffic_distribution variable we can control how much traffic goes to each environment
    forward {
      target_group {
        arn    = aws_alb_target_group.ecomm_app_group_blue.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100) 
      }

      target_group {
        arn    = aws_alb_target_group.ecomm_app_group_green.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "${var.prefix}-${var.suffix}"
  }
}
```

We can also choose which resources are created by using a toggle at the module level.

```
module "green" {
  source                = "./modules/green"
  count                 = var.is_green ? 1 : 0 # When "is_green" is true the count=1 and resource is created, when 0 resource is destroyed
  type                  = "green"
  prefix                = var.prefix
  suffix                = random_string.suffix.result
  ecomm_vpc_id          = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  ecomm_app_group_green = module.load_balancer_config.ecomm_target_group_arn_green
  ecs_cluster_id        = module.ecs.ecs_cluster_id
  task_definition_id    = module.ecs.ecs_task_definition_id
  security_group_id     = module.ecs.security_group_id
  ecomm_alb_listener    = module.load_balancer_config.ecomm_alb_listener
  depends_on            = [module.ecs]
}
```

More information can be found on the Terraform website for [Feature Toggles](https://www.hashicorp.com/blog/terraform-feature-toggles-blue-green-deployments-canary-test) and [Blue/Green Deployment](https://developer.hashicorp.com/terraform/tutorials/aws/blue-green-canary-tests-deployments?utm_medium=WEB_IO&in=terraform%2Faws&utm_offer=ARTICLE_PAGE&utm_source=WEBSITE&utm_content=DOCS).



<br>

### Project setup

**Prerequisites** : You'll need to create two ECR repositories in AWS, one for the frontend application and the other for the mariaDB backend. This will be needed before running as the container names have been hard coded into the task definition. I'm also using a toggle file on S3 to persist the current state. This is simply a text file with the string "blue" or "green" which indicates the current deployment toggle.


1. Clone the github repository.

```

> git clone https://github.com/TheLinuxEnthusiast/ecomm-aws-bluegreen.git
> cd ecomm-aws-bluegreen/

```

2. Change into the tf/ directory and initialize the project (Change the bucket name for your project otherwise you can remove the remote backend block).

```

terraform {

  backend "s3" {
    bucket = "ecomm-terraform-state-df" # Change this if required
    key    = "network/terraform.state" # Change this if required
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

```

```

> cd tf/
> terraform init

```

3. Setup an initial blue application by running

```

> # Blue deployment
> cd tf/
> terraform apply -var-file=variables/development.tfvars -auto-approve

```

4. Create Green env and rebalance traffic 

```

> # Create green environment and flip traffic to 90/10 blue/green
> terraform apply -var-file=variables/development.tfvars -var is_green="true" -var traffic_distribution="blue-90" -auto-approve

> # Destroy blue environment, green with 100% traffic
> terraform apply -var-file=variables/development.tfvars -var is_green="true" -var is_blue="false" -var traffic_distribution="green" -auto-approve

```