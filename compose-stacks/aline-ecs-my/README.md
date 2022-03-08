Project to deploy an ECS cluster using docker compose

# Use an ECS docker context
docker context create ecs my-ecs-context
docker context us my-ecs-context

# Deploy with docker compose up
docker compose up

# Tear down with docker compose down
docker compose down

# Check equivalent Cloudformation template
docker compose convert