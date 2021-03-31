docker build -t twang76912/multi-client-k8s:latest -t twang76912/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t twang76912/multi-server-k8s-pgfix:latest -t twang76912/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t twang76912/multi-worker-k8s:latest -t twang76912/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker
# as we already login docker in travis in before_install, so no need to login again
docker push twang76912/multi-client-k8s:latest
docker push twang76912/multi-server-k8s-pgfix:latest
docker push twang76912/multi-worker-k8s:latest

docker push twang76912/multi-client-k8s:$SHA
docker push twang76912/multi-server-k8s-pgfix:$SHA
docker push twang76912/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=twang76912/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=twang76912/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=twang76912/multi-worker-k8s:$SHA