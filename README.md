### Running
```
docker build -t serverless .
docker run -p 9000:8080 serverless
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```
