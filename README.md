## STEPS

### Without Skaffold (in a docker container running on EKS)
calculate_image_tag = <date>_<timestamp>_<git_commit_id> (write a script for this)

```
$ docker build -v /var/run/docker.sock:/var/run/docker.sock -t 574940526930.dkr.ecr.us-east-1.amazonaws.com/tools:<calculate_image_tag> .
$ docker push -v /var/run/docker.sock:/var/run/docker.sock 574940526930.dkr.ecr.us-east-1.amazonaws.com/tools:<calculate_image_tag>

$ docker build -v /var/run/docker.sock:/var/run/docker.sock -t 574940526930.dkr.ecr.us-east-1.amazonaws.com/tools:latest .
$ docker push -v /var/run/docker.sock:/var/run/docker.sock 574940526930.dkr.ecr.us-east-1.amazonaws.com/tools:latest
```

### With Skaffold
```
skaffold build
skaffold build -t latest (optional but recommended)
```
