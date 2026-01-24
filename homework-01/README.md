

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.
What's the version of `pip` in the image?

```
docker run -it --rm python:3.13 bash
pip --version
```

Answer: 25.3

## Question 2. Understanding Docker networking and docker-compose